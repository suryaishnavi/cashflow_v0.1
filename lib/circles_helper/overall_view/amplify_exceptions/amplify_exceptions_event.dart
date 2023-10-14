part of 'amplify_exceptions_bloc.dart';

sealed class AmplifyExceptionsEvent extends Equatable {
  const AmplifyExceptionsEvent();

  @override
  List<Object> get props => [];
}

class AmplifyPlugInExceptionsEvent extends AmplifyExceptionsEvent {
  final AmplifyException error;
  // final String error;

  const AmplifyPlugInExceptionsEvent({required this.error});

  @override
  List<Object> get props => [error];
}
