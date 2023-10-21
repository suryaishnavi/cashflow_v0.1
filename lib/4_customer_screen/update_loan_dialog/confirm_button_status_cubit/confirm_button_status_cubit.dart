import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'confirm_button_status_state.dart';

class ConfirmButtonStatusCubit extends Cubit<ConfirmButtonStatusChangedState> {
  ConfirmButtonStatusCubit() : super(const ConfirmButtonStatusChangedState(status: false));

  void changeStatus(bool status) {
    emit(ConfirmButtonStatusChangedState(status: status));
  }
}
