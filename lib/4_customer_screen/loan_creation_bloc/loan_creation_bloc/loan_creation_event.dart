part of 'loan_creation_bloc.dart';

abstract class LoanCreationEvent extends Equatable {
  const LoanCreationEvent();

  @override
  List<Object> get props => [];
}

class LoanSubmissionEvent extends LoanCreationEvent {
  final String paidEmis;
  final bool isNewLoan;
  final String givenAmount;
  final String emiAmount;
  final String totalEmis;
  final String date;
  // final String endDate;

  const LoanSubmissionEvent({
    required this.paidEmis,
    required this.isNewLoan,
    required this.givenAmount,
    required this.emiAmount,
    required this.totalEmis,
    required this.date,
    // required this.endDate,
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
  final String? loanIdentity;
  final String paidEmis;
  final bool isNewLoan;
  final String givenAmount;
  final String emiAmount;
  final String totalEmis;
  final String date;

  const AdditionalLoanCreationEvent({
    this.loanIdentity,
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

class LoanCreationResetEvent extends LoanCreationEvent {}
