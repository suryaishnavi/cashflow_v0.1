import 'package:flutter_bloc/flutter_bloc.dart';
import '../../1_session/session_cubit/session_cubit.dart';
import 'auth_credentials.dart';

enum AuthState { confirmSignUp, initial }

class AuthCubit extends Cubit<AuthState> {
  late AuthCredentials credentials;
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.initial);
  void showConfirmSignUp({
    required String signInId,
    required String password,
  }) {
    credentials = AuthCredentials(
      signInId: signInId,
      password: password,
    );
    emit(AuthState.confirmSignUp);
    emit(AuthState.initial);
  }

  void onSignUp() => sessionCubit.firstTimeUserCreation();
}
