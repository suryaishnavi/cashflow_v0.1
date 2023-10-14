part of 'circle_bloc.dart';

sealed class CircleState extends Equatable {
  const CircleState();

  @override
  List<Object> get props => [];
}

class CirclesLoadingState extends CircleState {}

class CirclesLoadedState extends CircleState {
  final List<Circle> circles;

  const CirclesLoadedState({required this.circles});

  @override
  List<Object> get props => [circles];
}

class CircleErrorState extends CircleState {
  final Exception error;

  const CircleErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class DatastoreErrorState extends CircleState {
  final AppUser appUser;
  final DataStoreException error;

  const DatastoreErrorState({required this.error, required this.appUser});

  @override
  List<Object> get props => [error];
}

class CircleEmptyState extends CircleState {}
