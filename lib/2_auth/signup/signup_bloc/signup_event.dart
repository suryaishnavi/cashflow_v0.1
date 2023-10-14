part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
}

class SignupUserNameChange extends SignupEvent {
  final String userName;
  SignupUserNameChange({required this.userName});

  @override
  List<Object> get props => [userName];
}

class SignupEmailChange extends SignupEvent {
  final String email;
   SignupEmailChange({required this.email});

  @override
  List<Object> get props => [email];
}

class SignupPhoneChange extends SignupEvent {
  final String phone;
  SignupPhoneChange({required this.phone});

  @override
  List<Object> get props => [phone];
}

class SignupPasswordChange extends SignupEvent {
  final String password;
  SignupPasswordChange({required this.password});

  @override
  List<Object> get props => [password];
}

class SignupSubmitted extends SignupEvent {
  @override
  List<Object> get props => [];
}