part of 'signin_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninStateLoading extends SigninState {}

class SigninStateSignInSubmission extends SigninState {
  final String phoneNumber;
  final String password;

  const SigninStateSignInSubmission({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];
}

class SigninStateSubmissionFailed extends SigninState {
  final Exception exception;

  const SigninStateSubmissionFailed(this.exception);

  @override
  List<Object> get props => [exception];
}

class SigninStateSignInSuccess extends SigninState {}

class SigninStateForgetPassword extends SigninState {}

// redirect to confirm code page

