part of 'password_reset_bloc.dart';

class PasswordResetState extends Equatable {
  final int index;
  final String email;
  final String code;
  final String password;
  final String error;

  const PasswordResetState({
    required this.error,
    required this.index,
    required this.email,
    required this.code,
    required this.password,
  });

  @override
  List<Object> get props => [index, email, code, password];


  PasswordResetState copyWith({
    int? index,
    String? email,
    String? code,
    String? password,
    String? error,
  }) {
    return PasswordResetState(
      index: index ?? this.index,
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      error: error ?? this.error,
    );
  }
}