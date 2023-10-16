part of 'loan_creation_bloc.dart';

sealed class LoanCreationState extends Equatable {
  const LoanCreationState();
  @override
  List<Object> get props => [];
}

class LoanCreationInitial extends LoanCreationState {
  final EmiType emiType;
  final String loanIdentity;
  const LoanCreationInitial({required this.emiType, required this.loanIdentity});
}

class LoanCreationLoadingState extends LoanCreationState {}

class LoanCreationSuccessState extends LoanCreationState {
  final String message;
  final String loanIdentity;

  const LoanCreationSuccessState({
    required this.message,
    required this.loanIdentity,
  });

  @override
  List<Object> get props => [message];
}


class LoanCreationErrorState extends LoanCreationState {
  final String message;

  const LoanCreationErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}