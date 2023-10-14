part of 'password_reset_bloc.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordEvent extends PasswordResetEvent {
  final String email;
  const ResetPasswordEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class ConfirmResetPasswordEvent extends PasswordResetEvent {
  final String code;
  final String password;
  const ConfirmResetPasswordEvent({
    required this.code,
    required this.password,
  });
  @override
  List<Object> get props => [code, password];
}

class DecrementEvent extends PasswordResetEvent {}