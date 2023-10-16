part of 'loan_creation_bloc.dart';

sealed class LoanCreationEvent extends Equatable {
  const LoanCreationEvent();

  @override
  List<Object> get props => [];
}

class LoanCreationInitialEvent extends LoanCreationEvent {}

class LoanSubmissionEvent extends LoanCreationEvent {
  final String paidEmis;
  final bool isNewLoan;
  final String givenAmount;
  final String emiAmount;
  final String totalEmis;
  final String date;
  final String loanIdentity;

  const LoanSubmissionEvent({
    required this.paidEmis,
    required this.isNewLoan,
    required this.givenAmount,
    required this.emiAmount,
    required this.totalEmis,
    required this.date,
    required this.loanIdentity,
  });

  @override
  List<Object> get props => [
        givenAmount,
        emiAmount,
        totalEmis,
        date, /*endDate*/
      ];
}

class AdditionalLoanCreationEvent extends LoanCreationEvent {
  final String loanIdentity;
  final String paidEmis;
  final bool isNewLoan;
  final String givenAmount;
  final String emiAmount;
  final String totalEmis;
  final String date;

  const AdditionalLoanCreationEvent({
    required this.loanIdentity,
    required this.paidEmis,
    required this.isNewLoan,
    required this.givenAmount,
    required this.emiAmount,
    required this.totalEmis,
    required this.date,
  });

  @override
  List<Object> get props => [givenAmount, emiAmount, totalEmis, date];
}
