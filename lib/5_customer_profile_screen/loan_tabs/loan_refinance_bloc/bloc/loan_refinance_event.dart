part of 'loan_refinance_bloc.dart';

sealed class LoanRefinanceEvent extends Equatable {
  const LoanRefinanceEvent();

  @override
  List<Object> get props => [];
}

class OldLoanRefinanceEvent extends LoanRefinanceEvent {
  final Loan oldLoan;

  const OldLoanRefinanceEvent({required this.oldLoan});

  @override
  List<Object> get props => [oldLoan];
}

class GivenAmountChangedEvent extends LoanRefinanceEvent {
  final int newGivenAmount;
  final int newEmiAmount;
  final int newTotalEMis;
  final DateTime givenLoanDate;

  const GivenAmountChangedEvent({
    required this.newGivenAmount,
    required this.newEmiAmount,
    required this.newTotalEMis,
    required this.givenLoanDate,
  });

  @override
  List<Object> get props => [
        newGivenAmount,
        newEmiAmount,
        newTotalEMis,
        givenLoanDate,
      ];
}

class EditLoanDetailsEvent extends LoanRefinanceEvent {}

class CloseLoanEditEvent extends LoanRefinanceEvent {}

class SubmitModifiedLoanEvent extends LoanRefinanceEvent {
  final int givenAmount;
  final int emiAmount;
  final int emiCount;
  final DateTime startDate;
  const SubmitModifiedLoanEvent({
    required this.givenAmount,
    required this.emiAmount,
    required this.emiCount,
    required this.startDate,
  });
}

class SubmitLoanRefinancingEvent extends LoanRefinanceEvent {}
