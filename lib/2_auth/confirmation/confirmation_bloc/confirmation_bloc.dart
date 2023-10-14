import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../0_repositories/auth_repository.dart';
import '../../../info_helper/form_submission_status.dart';
import '../../auth_helper_cubit/auth_cubit.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  ConfirmationBloc({required this.authRepo, required this.authCubit})
      : super(const ConfirmationState(confirmationCode: '')) {
    on<ResendConfirmationCode>((event, emit) async {
      final credentials = authCubit.credentials;
      await authRepo.resendConfirmationCode(
        // phoneNumber: credentials.phoneNumber,
        username: credentials.signInId,
      );
    });

    on<ConfirmationSubmitted>(((event, emit) async {
      emit(state.copyWith(confirmationCode: event.code));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(formStatus: FormSubmitting()));
      final credentials = authCubit.credentials;
      try {
        bool result = await authRepo.confirmSignUp(
          // phoneNumber: credentials.phoneNumber,
          email: credentials.signInId,
          confirmationCode: state.confirmationCode,
        );
        if (result) {
          final signInResult = await authRepo.logIn(
            email: credentials.signInId,
            // phoneNumber: credentials.phoneNumber,
            password: credentials.password,
          );
          emit(state.copyWith(formStatus: SubmissionSuccess()));
          emit(state.copyWith(formStatus: FormSubmitting()));
          if (signInResult.isSignedIn) {
            authCubit.onSignUp();
          }
        }
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
        emit(state.copyWith(formStatus: const InitialFormStatus()));
      }
    }));
  }
}
