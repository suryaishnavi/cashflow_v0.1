part of 'update_loan_dialog_bloc.dart';

sealed class UpdateLoanDialogEvent extends Equatable {
  const UpdateLoanDialogEvent();

  @override
  List<Object> get props => [];
}

final class GetLoanDataEvent extends UpdateLoanDialogEvent {
  final Customer customer;

  const GetLoanDataEvent({required this.customer});

  @override
  List<Object> get props => [customer];
}

final class NewEmiEvent extends UpdateLoanDialogEvent {
  final Loan loan;
  final String emiValue;

  const NewEmiEvent({
    required this.loan,
    required this.emiValue,
  });

  @override
  List<Object> get props => [loan, emiValue];
}

final class MarkCustomerAsInactiveEvent extends UpdateLoanDialogEvent {
  final Customer customer;

  const MarkCustomerAsInactiveEvent({required this.customer});

  @override
  List<Object> get props => [customer];
}