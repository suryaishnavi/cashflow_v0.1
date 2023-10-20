part of 'update_loan_dialog_bloc.dart';

sealed class UpdateLoanDialogState extends Equatable {
  const UpdateLoanDialogState();

  @override
  List<Object> get props => [];
}

final class UpdateLoanDialogInitialState extends UpdateLoanDialogState {}

final class UpdateLoanDialogLoadingState extends UpdateLoanDialogState {}

final class CreatedChatViewState extends UpdateLoanDialogState {
  final Customer customer;
  final List<ChatModel> chatModels;

  const CreatedChatViewState({required this.chatModels, required this.customer});

  @override
  List<Object> get props => [chatModels];
}

final class UpdateLoanDialogFailureState extends UpdateLoanDialogState {
  final String errorMessage;

  const UpdateLoanDialogFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
