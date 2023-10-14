import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/auth_repository.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthRepository authRepo;
  PasswordResetBloc({required this.authRepo})
      : super(const PasswordResetState(
          code: "",
          email: "",
          index: 0,
          password: "",
          error: "",
        )) {
    on<ResetPasswordEvent>(
      (event, emit) async {
        try {
          final result = await authRepo.resetPassword(event.email);
          if (result) {
            emit(state.copyWith(email: event.email));
            emit(state.copyWith(index: state.index + 1));
          }
        } catch (e) {
          emit(state.copyWith(error: e.toString()));
        }
      },
    );
    on<ConfirmResetPasswordEvent>((event, emit) async {
      try {
        final bool result = await authRepo.confirmResetPassword(
          username: state.email,
          confirmationCode: event.code,
          newPassword: event.password,
        );
        if (result) {
          emit(state.copyWith(code: event.code));
          emit(state.copyWith(password: event.password));
          emit(state.copyWith(index: state.index + 1));
        }
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}
