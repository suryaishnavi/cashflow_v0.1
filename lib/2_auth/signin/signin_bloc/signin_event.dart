part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SigninEventSubmitted extends SigninEvent {
  final String phoneNumber;
  final String password;

  const SigninEventSubmitted({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];
}


class SigninEventForgetPassword extends SigninEvent {}