part of 'circle_bloc.dart';

sealed class CircleEvent extends Equatable {
  const CircleEvent();

  @override
  List<Object> get props => [];
}

class LoadCirclesEvent extends CircleEvent {
  final AppUser appUser;

  const LoadCirclesEvent({required this.appUser});

  @override
  List<Object> get props => [appUser];
}

class ShowCustomersEvent extends CircleEvent {
  final Circle circle;

  const ShowCustomersEvent({required this.circle});

  @override
  List<Object> get props => [circle];
}

// class NewCircleEvent extends CircleEvent {
//   final Circle circle;

//   const NewCircleEvent({required this.circle});

//   @override
//   List<Object> get props => [circle];
// }

class ObserveCircles extends CircleEvent {
  final AppUser appUser;

  const ObserveCircles({required this.appUser});

  @override
  List<Object> get props => [appUser];
}

class ShowCities extends CircleEvent {
  final Circle circle;

  const ShowCities({required this.circle});

  @override
  List<Object> get props => [circle];
}

class DeleteCircle extends CircleEvent {
  final Circle circle;

  const DeleteCircle({required this.circle});

  @override
  List<Object> get props => [circle];
}
