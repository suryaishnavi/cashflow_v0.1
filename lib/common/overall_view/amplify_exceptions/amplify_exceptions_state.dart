part of 'amplify_exceptions_bloc.dart';

sealed class AmplifyExceptionsState extends Equatable {
  const AmplifyExceptionsState();

  @override
  List<Object> get props => [];
}

final class AmplifyExceptionsInitial extends AmplifyExceptionsState {}

final class AmplifyPlugInExceptionsState extends AmplifyExceptionsState {
  final AmplifyException error;
  // final String error;

  const AmplifyPlugInExceptionsState({required this.error});

  @override
  List<Object> get props => [error];
}
