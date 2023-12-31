import 'package:cashflow/0_repositories/customers_and_loan_data_repository.dart';
import 'package:cashflow/4_customer_screen/loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../4_customer_screen/update_loan_dialog/update_loan_dialog_bloc/update_loan_dialog_bloc.dart';
import '../../../../common/screen_helper_cubit/common_cubit.dart';
import '../../../../models/ModelProvider.dart';

part 'loan_refinance_event.dart';
part 'loan_refinance_state.dart';

class LoanRefinanceBloc extends Bloc<LoanRefinanceEvent, LoanRefinanceState> {
  final ScreensCubit screensCubit;
  final UpdateLoanDialogBloc updateLoanDialogBloc;
  final LoanCreationBloc loanCreationBloc;
  final CustomerAndLoanDataRepository customerAndLoanDataRepository;

  late Loan oldLoan;
  late int balanceAmount;
  late String loanIdentity;
  LoanRefinanceBloc({
    required this.screensCubit,
    required this.updateLoanDialogBloc,
    required this.loanCreationBloc,
    required this.customerAndLoanDataRepository,
  }) : super(LoanRefinanceLoadingState()) {
    on<OldLoanRefinanceEvent>(_onOldLoanRefinanceEvent);
    on<GivenAmountChangedEvent>(_onGivenAmountChangedEvent);
    on<EditLoanDetailsEvent>(_onModifyLoanDetailsEvent);
    on<CloseLoanEditEvent>(_onCloseLoanEditEvent);
    on<SubmitModifiedLoanEvent>(_onSubmitModifiedLoanEvent);
    on<SubmitLoanRefinancingEvent>(_onSubmitLoanRefinancingEvent);
  }
  _onOldLoanRefinanceEvent(
    OldLoanRefinanceEvent event,
    Emitter<LoanRefinanceState> emit,
  ) async {
    final LoanSerialNumber loanSerialNumber =
        await customerAndLoanDataRepository.getCircleCurrentSerialNo(
      circleId: screensCubit.currentCircle.circle!.id,
    );
    loanIdentity = loanSerialNumber.serialNumber;
    oldLoan = event.oldLoan;
    try {
      final int givenAmount = event.oldLoan.givenAmount;
      final int collectableAmount = event.oldLoan.collectibleAmount;
      final int customerPaidAmount = event.oldLoan.paidAmount;
      balanceAmount = collectableAmount - customerPaidAmount;
      final int newGivenAmount = givenAmount - balanceAmount;
      final int emiAmount = event.oldLoan.emiAmount;
      final int emiCount = event.oldLoan.totalEmis;
      emit(LoanRefinanceInitialState(
        oldLoan: event.oldLoan,
        balanceAmount: balanceAmount,
        givenAmount: givenAmount,
        newGivenAmount: newGivenAmount,
        emiAmount: emiAmount,
        emiCount: emiCount,
        startDate: DateTime.parse(DateTime.now().toString().split(' ')[0]),
        loanIdentity: loanIdentity,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }

  _onModifyLoanDetailsEvent(
    EditLoanDetailsEvent event,
    Emitter<LoanRefinanceState> emit,
  ) async {
    try {
      emit(ModifyLoanDetailsState(
        givenAmount: state.props[0] as int,
        emiAmount: state.props[3] as int,
        emiCount: state.props[4] as int,
        loanIdentity: loanIdentity,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }

  _onGivenAmountChangedEvent(
    GivenAmountChangedEvent event,
    Emitter<LoanRefinanceState> emit,
  ) async {
    try {
      final int givenAmount = event.newGivenAmount;
      final int balanceAmount = state.props[1] as int;
      final int newGivenAmount = givenAmount - balanceAmount;
      await Future.delayed(const Duration(milliseconds: 500));
      emit((state as LoanRefinanceInitialState).copyWith(
        givenAmount: givenAmount,
        newGivenAmount: newGivenAmount,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }

  _onCloseLoanEditEvent(
    CloseLoanEditEvent event,
    Emitter<LoanRefinanceState> emit,
  ) async {
    try {
      emit(LoanRefinanceInitialState(
        oldLoan: oldLoan,
        balanceAmount: oldLoan.collectibleAmount - oldLoan.paidAmount,
        givenAmount: oldLoan.givenAmount,
        newGivenAmount: oldLoan.givenAmount -
            (oldLoan.collectibleAmount - oldLoan.paidAmount),
        emiAmount: oldLoan.emiAmount,
        emiCount: oldLoan.totalEmis,
        startDate: oldLoan.dateOfCreation.getDateTime(),
        loanIdentity: loanIdentity,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }

  _onSubmitModifiedLoanEvent(
    SubmitModifiedLoanEvent event,
    Emitter<LoanRefinanceState> emit,
  ) {
    try {
      emit(LoanRefinanceLoadingState());
      final int givenAmount = event.givenAmount;
      final int emiAmount = event.emiAmount;
      final int emiCount = event.emiCount;
      final DateTime startDate = event.startDate;
      final int newGivenAmount = givenAmount - balanceAmount;
      final String modifiedloanIdentity = event.loanIdentity;
      emit(LoanRefinanceInitialState(
        oldLoan: oldLoan,
        balanceAmount: balanceAmount,
        givenAmount: givenAmount,
        newGivenAmount: newGivenAmount,
        emiAmount: emiAmount,
        emiCount: emiCount,
        startDate: startDate,
        loanIdentity: modifiedloanIdentity,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }

  _onSubmitLoanRefinancingEvent(
    SubmitLoanRefinancingEvent event,
    Emitter<LoanRefinanceState> emit,
  ) async {
    final DateTime date = state.props[5] as DateTime;
    final String modifiedDate = date.toString().split(' ')[0];
    try {
      final int givenAmount = state.props[0] as int;
      final int emiAmount = state.props[3] as int;
      final int emiCount = state.props[4] as int;
      final String modifiedloanIdentity = state.props[6] as String;
      // debug print all the values
      // emit(LoanRefinanceLoadingState());
      // close old lone by passing emi amount to update loan dialog cubit
      await updateLoanDialogBloc.updateLoan(
        emiValue: '$balanceAmount',
        loan: oldLoan,
        customer: screensCubit.currentCustomer.customer as Customer,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      // create new loan by passing new loan details to loan creation bloc
      loanCreationBloc.add(AdditionalLoanCreationEvent(
        paidEmis: '0',
        isNewLoan: true,
        givenAmount: '$givenAmount',
        emiAmount: '$emiAmount',
        totalEmis: '$emiCount',
        date: modifiedDate,
        loanIdentity: modifiedloanIdentity,
      ));
    } catch (e) {
      emit(LoanRefinanceFailure(message: e.toString()));
    }
  }
}
