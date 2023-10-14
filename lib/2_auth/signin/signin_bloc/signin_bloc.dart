import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/auth_repository.dart';
import '../../auth_helper_cubit/auth_cubit.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;
  SigninBloc({required this.authRepo, required this.authCubit})
      : super(SigninInitial()) {
    on<SigninEventSubmitted>(_onLoginWithCreditentials);
  }
  void _onLoginWithCreditentials(
    SigninEventSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(SigninStateLoading());
    try {
      final result = await authRepo.logIn(
        // phoneNumber: state.phoneNumber,
        email: event.phoneNumber,
        password: event.password,
      );
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        authCubit.showConfirmSignUp(
          signInId: event.phoneNumber,
          password: event.password,
        );
        return;
      }
      if (result.isSignedIn) {
        emit(SigninStateSignInSuccess());
      }
    } on Exception catch (e) {
      emit(SigninStateSubmissionFailed(e));
    }
  }
}
