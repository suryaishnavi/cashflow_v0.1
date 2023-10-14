part of 'confirmation_bloc.dart';

abstract class ConfirmationEvent extends Equatable {}

class ConfirmationSubmitted extends ConfirmationEvent {
  final String code;
  ConfirmationSubmitted({required this.code});
  @override
  List<Object> get props => [code];
}

class ResendConfirmationCode extends ConfirmationEvent {
  @override
  List<Object> get props => [];
}