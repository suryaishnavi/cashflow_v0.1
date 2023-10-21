part of 'confirm_button_status_cubit.dart';

final class ConfirmButtonStatusChangedState extends Equatable {
  final bool status;

  const ConfirmButtonStatusChangedState({required this.status});

  @override
  List<Object> get props => [status];
}
