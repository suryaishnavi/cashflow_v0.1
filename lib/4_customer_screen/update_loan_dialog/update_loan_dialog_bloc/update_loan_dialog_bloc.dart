import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/customer_data_repository.dart';
import '../../../0_repositories/dependency_injection.dart';
import '../../../0_repositories/emi_date_calculator.dart';
import '../../../0_repositories/emis_data_repository.dart';
import '../../../0_repositories/loans_data_repository.dart';
import '../../../info_helper/chat_model.dart';
import '../../../info_helper/custom_transaction_modal.dart';
import '../../../models/ModelProvider.dart';

part 'update_loan_dialog_event.dart';
part 'update_loan_dialog_state.dart';

class UpdateLoanDialogBloc
    extends Bloc<UpdateLoanDialogEvent, UpdateLoanDialogState> {
  final EmiDateCalculator emiCalc = getIt<EmiDateCalculator>();
  final LoansDataRepository loansDataRepository;
  final EmisDataRepository emisDataRepository;
  final CustomerDataRepository customerDataRepository;
  StreamSubscription? emiStreamSubscription;
  UpdateLoanDialogBloc({
    required this.loansDataRepository,
    required this.emisDataRepository,
    required this.customerDataRepository,
  }) : super(UpdateLoanDialogInitialState()) {
    on<GetLoanDataEvent>(_onGetLoanDataEvent);
    on<NewEmiEvent>(_onNewEmiEvent);
    observeEmi();
  }
  Future<void> _onGetLoanDataEvent(GetLoanDataEvent event, Emitter emit) async {
    // emit(UpdateLoanDialogLoadingState());
    List<ChatModel> chatModels = [];
    List<Loan> loans = [];
    // Get all loans

    loans =
        await loansDataRepository.getAllLoans(customerID: event.customer.id);
    // for every loan, get all emis and make transaction model and chat model
    for (Loan loan in loans) {
      List<CustomTransactionModel> transactions = [];
      CustomTransactionModel transaction = CustomTransactionModel(
        amount: loan.collectibleAmount,
        date: loan.dateOfCreation.getDateTime(),
        type: TransactionType.loan,
      );
      transactions.add(transaction);
      List<Emi> emis = await emisDataRepository.getAllEmis(loanId: loan.id);
      // for every emi, make transaction model
      for (Emi emi in emis) {
        CustomTransactionModel transaction = CustomTransactionModel(
          amount: emi.paidAmount!,
          date: emi.paidDate!.getDateTime(),
          type: TransactionType.emi,
        );
        transactions.add(transaction);
      }
      ChatModel chatModel = ChatModel(
        loan: loan,
        transaction: transactions,
      );
      chatModels.add(chatModel);
    }
    // sort chat models by date
    chatModels.sort((a, b) => a.loan.dateOfCreation
        .getDateTime()
        .compareTo(b.loan.dateOfCreation.getDateTime()));
    try {
      emit(CreatedChatViewState(
          chatModels: chatModels, customer: event.customer));
    } catch (e) {
      emit(UpdateLoanDialogFailureState(errorMessage: e.toString()));
    }
  }

  _onNewEmiEvent(NewEmiEvent event, Emitter emit) async {
    await updateLoan(
      emiValue: event.emiValue,
      loan: event.loan,
      customer: (state as CreatedChatViewState).customer,
    );
  }

  // ! update loan amount on popup
  Future<void> updateLoan({
    required String emiValue,
    required Loan loan,
    required Customer customer,
  }) async {
    if (emiValue.isNotEmpty) {
      final int emiAmount = double.parse(emiValue).roundToDouble().toInt();
      final int totalPaidAmount = loan.paidAmount + emiAmount;
      final LoanStatus loanStatus = (totalPaidAmount < loan.collectibleAmount)
          ? LoanStatus.ACTIVE
          : LoanStatus.CLOSED;

      await newEmiAndUpdateLoan(
        paidAmount: emiAmount,
        emiAmount: loan.emiAmount,
        loan: loan,
        loanStatus: loanStatus,
        customer: customer,
      );
    }
  }

  // ! creating new emi and update loan
  Future<void> newEmiAndUpdateLoan({
    required int emiAmount,
    required Loan loan,
    required LoanStatus loanStatus,
    required Customer customer,
    required int paidAmount,
  }) async {
    final DateTime today =
        DateTime.parse(DateTime.now().toString().split(' ')[0]);
    final DateTime endDate = loan.endDate.getDateTime();
    // is endDate before today

    int currentEmi = loan.paidEmis + 1;
    // Check if there are extra EMIs due and it's before the end date
    bool isExtraEmi =
        (loan.totalEmis < currentEmi) && (today.isBefore(endDate));
    // * create new emi
    await emisDataRepository.createNewEMi(
      emiNumber: loan.paidEmis + 1,
      appUserId: loan.sub,
      customerName: customer.customerName,
      loanIdentity: loan.loanIdentity,
      emiAmount: emiAmount,
      loanId: loan.id,
      paidAmount: paidAmount,
      dueDate: emiCalc.calculateLoanEndDate(
          loanTakenDate: loan.dateOfCreation.getDateTime(),
          totalEmis: loan.paidEmis + 1,
          emiFrequency: loan.emiType),
      isExtraEmi: isExtraEmi,
    );
    // * update loan
    await loansDataRepository.updateLoans(
      loan: loan,
      paidAmount: loan.paidAmount + paidAmount,
      currentEmi: loan.paidEmis + 1,
      loanStatus: loanStatus,
      nextDueDate: emiCalc.calculateLoanEndDate(
          loanTakenDate: loan.dateOfCreation.getDateTime(),
          totalEmis: loan.paidEmis + 2,
          emiFrequency: loan.emiType),
      endDate: loan.endDate,
    );
    // * update customer
    await customerDataRepository.updateCustomerLoanUpdatedDate(
      loanIdentity: loan.loanIdentity,
      customer: customer,
      paidAmount: paidAmount,
      emiAmount: emiAmount,
      loanStatus: loanStatus,
    );
  }

  observeEmi() {
    emiStreamSubscription = emisDataRepository.observeEmi().listen((event) {
      add(GetLoanDataEvent(customer: (state as CreatedChatViewState).customer));
    });
  }

  // dispose emiStreamSubscription
  @override
  Future<void> close() {
    emiStreamSubscription?.cancel();
    emiStreamSubscription = null;
    return super.close();
  }
}
