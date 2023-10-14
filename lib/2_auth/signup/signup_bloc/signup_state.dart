part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String userName;
  bool get isValidUsername => userName.length >= 3;
  final String email;
  bool get isValidEmail => email.length > 3 && email.contains('@');
  final String phone;
  bool get isValidPhone => phone.length == 10;
  final String password;
  bool get isValidPassword => password.length >= 8;

  final FormSubmissionStatus formStatus;

  const SignupState({
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
    this.formStatus = const InitialFormStatus(),
  });

  SignupState copyWith({
    String? userName,
    String? email,
    String? phone,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignupState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object> get props => [userName, email, phone, password, formStatus];
}
