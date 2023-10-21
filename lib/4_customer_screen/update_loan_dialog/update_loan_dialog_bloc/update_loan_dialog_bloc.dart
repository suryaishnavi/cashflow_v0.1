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
    on<MarkCustomerAsInactiveEvent>(_onMarkCustomerAsInactiveEvent);
    observeEmi();
  }

  Future<void> _onGetLoanDataEvent(GetLoanDataEvent event, Emitter emit) async {
    List<ChatModel> chatModels = [];
    List<Loan> loans = [];
    // Get all Active loans of the customer
    loans = await loansDataRepository.getAllLoans(
      customerID: event.customer.id,
      loanStatus: LoanStatus.ACTIVE,
    );
    if (loans.isEmpty) {
      emit(LoansEmptyStateEvent());
      return;
    }
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
    final updatedLoan = await loansDataRepository.getLoanById(loanId: loan.id);
    if (emiValue.isNotEmpty) {
      final int emiAmount = double.parse(emiValue).roundToDouble().toInt();
      final int totalPaidAmount = updatedLoan.paidAmount + emiAmount;
      final LoanStatus loanStatus =
          (totalPaidAmount < updatedLoan.collectibleAmount)
              ? LoanStatus.ACTIVE
              : LoanStatus.CLOSED;

      await newEmiAndUpdateLoan(
        paidAmount: emiAmount,
        emiAmount: loan.emiAmount,
        updatedLoan: updatedLoan,
        loanStatus: loanStatus,
        customer: customer,
      );
    }
  }

  // ! creating new emi and update loan
  Future<void> newEmiAndUpdateLoan({
    required int emiAmount,
    required Loan updatedLoan,
    required LoanStatus loanStatus,
    required Customer customer,
    required int paidAmount,
  }) async {
    // * get updated loan and customer
    final updatedCustomer =
        await customerDataRepository.getCustomerById(customerID: customer.id);

    final DateTime today =
        DateTime.parse(DateTime.now().toString().split(' ')[0]);
    final DateTime endDate = updatedLoan.endDate.getDateTime();
    // is endDate before today

    int currentEmi = updatedLoan.paidEmis + 1;
    // Check if there are extra EMIs due and it's before the end date
    bool isExtraEmi =
        (updatedLoan.totalEmis < currentEmi) && (today.isBefore(endDate));
    // * create new emi
    await emisDataRepository.createNewEMi(
      emiNumber: updatedLoan.paidEmis + 1,
      appUserId: updatedLoan.sub,
      customerName: updatedCustomer.customerName,
      loanIdentity: updatedLoan.loanIdentity,
      emiAmount: emiAmount,
      loanId: updatedLoan.id,
      paidAmount: paidAmount,
      dueDate: emiCalc.calculateLoanEndDate(
          loanTakenDate: updatedLoan.dateOfCreation.getDateTime(),
          totalEmis: updatedLoan.paidEmis + 1,
          emiFrequency: updatedLoan.emiType),
      isExtraEmi: isExtraEmi,
    );
    // * update loan
    await loansDataRepository.updateLoans(
      loan: updatedLoan,
      paidAmount: updatedLoan.paidAmount + paidAmount,
      currentEmi: updatedLoan.paidEmis + 1,
      loanStatus: loanStatus,
      nextDueDate: emiCalc.calculateLoanEndDate(
          loanTakenDate: updatedLoan.dateOfCreation.getDateTime(),
          totalEmis: updatedLoan.paidEmis + 2,
          emiFrequency: updatedLoan.emiType),
      endDate: updatedLoan.endDate,
    );
    // * update customer
    await customerDataRepository.updateCustomerLoanUpdatedDate(
      loanIdentity: updatedLoan.loanIdentity,
      customer: updatedCustomer,
      paidAmount: paidAmount,
      emiAmount: emiAmount,
      loanStatus: loanStatus,
    );
  }

  // * mark customer as inactive
  Future<void> _onMarkCustomerAsInactiveEvent(
      MarkCustomerAsInactiveEvent event, Emitter emit) async {
    await customerDataRepository.markAsInactive(customer: event.customer);
  }

// * Observing emi stream
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
