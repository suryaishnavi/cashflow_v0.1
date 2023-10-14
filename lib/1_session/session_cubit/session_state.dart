part of 'session_cubit.dart';

abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object> get props => [];
}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final AppUser user;

  const Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class OnboardingState extends SessionState {}