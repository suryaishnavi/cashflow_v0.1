part of 'loan_refinance_bloc.dart';

sealed class LoanRefinanceState extends Equatable {
  const LoanRefinanceState();

  @override
  List<Object> get props => [];
}

class LoanRefinanceInitialState extends LoanRefinanceState {
  final Loan oldLoan;
  final int givenAmount;
  final int balanceAmount;
  final int newGivenAmount;
  final int emiAmount;
  final int emiCount;
  final DateTime startDate;
  const LoanRefinanceInitialState({
    required this.oldLoan,
    required this.givenAmount,
    required this.balanceAmount,
    required this.newGivenAmount,
    required this.emiAmount,
    required this.emiCount,
    required this.startDate,
  });

  @override
  List<Object> get props => [
        givenAmount,
        balanceAmount,
        newGivenAmount,
        emiAmount,
        emiCount,
        startDate,
      ];

  LoanRefinanceInitialState copyWith({
    Loan? oldLoan,
    int? givenAmount,
    int? balanceAmount,
    int? newGivenAmount,
    int? emiAmount,
    int? emiCount,
    DateTime? startDate,
  }) {
    return LoanRefinanceInitialState(
      oldLoan: oldLoan ?? this.oldLoan,
      givenAmount: givenAmount ?? this.givenAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      newGivenAmount: newGivenAmount ?? this.newGivenAmount,
      emiAmount: emiAmount ?? this.emiAmount,
      emiCount: emiCount ?? this.emiCount,
      startDate: startDate ?? this.startDate,
    );
  }
}

final class LoanRefinanceLoadingState extends LoanRefinanceState {}

final class LoanRefinanceSuccess extends LoanRefinanceState {
  final Loan newLoan;
  const LoanRefinanceSuccess({required this.newLoan});

  @override
  List<Object> get props => [newLoan];
}

final class LoanRefinanceFailure extends LoanRefinanceState {
  final String message;
  const LoanRefinanceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class ModifyLoanDetailsState extends LoanRefinanceState {}
