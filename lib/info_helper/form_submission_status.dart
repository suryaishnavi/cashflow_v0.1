import 'package:equatable/equatable.dart';

abstract class FormSubmissionStatus extends Equatable {
  const FormSubmissionStatus();
  @override
  List<Object> get props => [];
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;
  
  const SubmissionFailed(this.exception);

  @override
  List<Object> get props => [exception];
}

// Compare this snippet from lib\auth\login\login_bloc\login_bloc.dart