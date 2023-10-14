part of 'create_circle_bloc.dart';

abstract class CreateCircleEvent extends Equatable {
  const CreateCircleEvent();

  @override
  List<Object> get props => [];
}

class CircleNameChanged extends CreateCircleEvent {
  final String circleName;

  const CircleNameChanged({required this.circleName});

  @override
  List<Object> get props => [circleName];
}

class DayChanged extends CreateCircleEvent {
  final WeekDay selectedDay;

  const DayChanged({required this.selectedDay});

  @override
  List<Object> get props => [selectedDay];
}

class CircleSubmission extends CreateCircleEvent {
  const CircleSubmission();
}
