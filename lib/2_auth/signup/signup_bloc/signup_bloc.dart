import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../0_repositories/auth_repository.dart';
import '../../../info_helper/form_submission_status.dart';
import '../../auth_helper_cubit/auth_cubit.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  SignupBloc({required this.authRepo, required this.authCubit})
      : super(const SignupState(
            userName: '', email: '', phone: '', password: '')) {
    on<SignupUserNameChange>((event, emit) {
      emit(state.copyWith(userName: event.userName));
    });

    on<SignupEmailChange>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignupPhoneChange>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });

    on<SignupPasswordChange>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignupSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        // const bool isSignedUp = true;
        final bool isSignedUp = await authRepo.signUp(
          name: state.userName,
          email: state.email,
          phoneNumber: state.phone,
          password: state.password,
        );
        if (isSignedUp) {
          emit(state.copyWith(formStatus: SubmissionSuccess()));
          authCubit.showConfirmSignUp(
            // signInId: state.phone,
            signInId: state.email,
            password: state.password,
          );
        }
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
        emit(state.copyWith(formStatus: const InitialFormStatus()));
      }
    });
  }
}
