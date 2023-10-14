part of 'create_circle_bloc.dart';

class CreateCircleState extends Equatable {
  final WeekDay selectedDay;
  final String circleName;
  final FormSubmissionStatus formStatus;
  
  bool get isValidCircleName => circleName.length > 3;

  const CreateCircleState({
    required this.circleName,
    required this.selectedDay,
    this.formStatus = const InitialFormStatus(),
  });

  CreateCircleState copyWith({
    WeekDay? selectedDay,
    String? circleName,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateCircleState(
      selectedDay: selectedDay ?? this.selectedDay,
      circleName: circleName ?? this.circleName,
      formStatus: formStatus ?? this.formStatus,
    );
  }
  @override
  List<Object> get props => [selectedDay, circleName];
}