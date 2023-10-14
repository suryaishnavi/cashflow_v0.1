part of 'update_loan_dialog_cubit.dart';

abstract class UpdateLoanDialogState extends Equatable {
  const UpdateLoanDialogState();

  @override
  List<Object> get props => [];
}

class UpdateLoanDialogInitial extends UpdateLoanDialogState {}

class LoansLoadedState extends UpdateLoanDialogState {
  final List<Loan> loans;

  const LoansLoadedState({
    required this.loans,
  });

  @override
  List<Object> get props => [loans];
}

class CustomerMarkedAsInactiveState extends UpdateLoanDialogState {}

class ErrorState extends UpdateLoanDialogState {
  final Exception message;

  const ErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class LoanUpdatedState extends UpdateLoanDialogState {
  final Customer customer;
  const LoanUpdatedState({
    required this.customer,
  });
}

class LoanUpdatedErrorState extends UpdateLoanDialogState {
  final String message;

  const LoanUpdatedErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
