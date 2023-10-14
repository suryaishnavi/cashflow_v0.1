part of 'confirmation_bloc.dart';

class ConfirmationState extends Equatable {
  final String confirmationCode;
  final FormSubmissionStatus formStatus;

  const ConfirmationState({
    required this.confirmationCode,
    this.formStatus = const InitialFormStatus(),
  });

  ConfirmationState copyWith({
    String? confirmationCode,
    FormSubmissionStatus? formStatus,
  }) {
    return ConfirmationState(
      confirmationCode: confirmationCode ?? this.confirmationCode,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object> get props => [confirmationCode, formStatus];
}
