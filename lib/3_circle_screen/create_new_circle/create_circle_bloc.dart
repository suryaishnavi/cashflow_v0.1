import 'package:cashflow/1_session/session_cubit/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../0_repositories/circle_data_repository.dart';
import '../../0_repositories/city_repository.dart';
import '../../info_helper/form_submission_status.dart';
import '../../models/ModelProvider.dart';
import '../circles_bloc/circle_bloc.dart';

part 'create_circle_event.dart';
part 'create_circle_state.dart';

class CreateCircleBloc extends Bloc<CreateCircleEvent, CreateCircleState> {
  final CircleDataRepository circleDataRepo;
  final CityRepository cityRepo;
  final SessionCubit sessionCubit;
  final CircleBloc circleBloc;
  CreateCircleBloc({
    required this.cityRepo,
    required this.sessionCubit,
    required this.circleBloc,
    required this.circleDataRepo,
  }) : super(const CreateCircleState(
          circleName: '',
          selectedDay: WeekDay.MONDAY,
        )) {
    on<CircleNameChanged>((event, emit) {
      emit(state.copyWith(circleName: event.circleName));
    });
    on<DayChanged>((event, emit) {
      emit(state.copyWith(selectedDay: event.selectedDay));
    });
    // ------------------------------------------------------------
    on<CircleSubmission>(
      (event, emit) async {
        emit(state.copyWith(formStatus: FormSubmitting()));
        try {
          final circle = await circleDataRepo.createCircle(
            sub: sessionCubit.user.id,
            circleName: state.circleName,
            day: state.selectedDay,
            appuserID: sessionCubit.user.id,
          );
          await circleDataRepo.createNewSerialNo(circleID: circle.id);
          await cityRepo.addNewCity(
              name: circle.circleName, circleID: circle.id);
          // circleBloc.add(NewCircleEvent(circle: circle));
          emit(state.copyWith(formStatus: SubmissionSuccess()));
        } on Exception catch (e) {
          emit(state.copyWith(formStatus: SubmissionFailed(e)));
        }
      },
    );
    // ------------------------------------------------------------
  }
}
