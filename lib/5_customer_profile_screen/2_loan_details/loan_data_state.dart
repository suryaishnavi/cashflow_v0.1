part of 'loan_data_cubit.dart';

abstract class LoanDataState extends Equatable {
  const LoanDataState();

  @override
  List<Object> get props => [];
}

class LoanLoadingState extends LoanDataState {}

class LoanLoadedState extends LoanDataState {
  final List<Loan> loansData;

  const LoanLoadedState({required this.loansData});

  @override
  List<Object> get props => [loansData];
}

class LoanDataErrorState extends LoanDataState {
  final Exception message;

  const LoanDataErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LoanUpdatedState extends LoanDataState {}

class LoanFailedToUpdate extends LoanDataState {}
