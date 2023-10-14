import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/city_repository.dart';
import '../../../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../../../info_helper/current_circle_id.dart';
import '../../../info_helper/current_circle.dart';
import '../../../models/ModelProvider.dart';

part 'cities_event.dart';
part 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  final CurrentCircle currentCircle = CurrentCircle();
  final ScreensCubit screensCubit;
  StreamSubscription<CurrentCircleId>? _currentCircleStreamSubscription;
  StreamSubscription? _cityStreamSubscription;

  final CityRepository cityRepository;
  CitiesBloc({
    required this.screensCubit,
    required this.cityRepository,
  }) : super(CitiesLoadingState()) {
    _currentCircleStreamSubscription =
        screensCubit.cityCircleStream.listen((circleDetails) {
      currentCircle.circle = circleDetails.circle;
      add(LoadCities(circleID: circleDetails.circle.id));
      observeCities();
    });
    on<CreateNewCity>(_onCreateNewCity);
    on<LoadCities>(_onLoadCities);
  }

  _onCreateNewCity(CreateNewCity event, Emitter<CitiesState> emit) async {
    try {
      await cityRepository.addNewCity(
        name: event.name,
        circleID: currentCircle.circle!.id,
      );
    } catch (e) {
      emit(CitiesErrorState(message: e.toString()));
    }
  }

  _onLoadCities(LoadCities event, Emitter<CitiesState> emit) async {
    try {
      final cities = await cityRepository.getCities(circleID: event.circleID);
      //* temporary code to make city details from cities list
      // final cityDetails = cities.map((city) {
      //   return CityDetails(
      //     id: city.id,
      //     name: city.name,
      //     circleID: event.circleID,
      //   );
      // }).toList();
      // print('cityDetails: $cityDetails');
      // Future.delayed(Duration(seconds: 1));
      // emit(CitiesLoadedState(cities: cityDetails));
      emit(CitiesLoadedState(cities: cities));
      // //
    } catch (e) {
      emit(CitiesErrorState(message: e.toString()));
    }
  }

  void observeCities() {
    final cityStream = cityRepository.observeCities();
    _cityStreamSubscription = cityStream.listen((event) {
      add(LoadCities(circleID: currentCircle.circle!.id));
    });
  }

  @override
  Future<void> close() {
    _currentCircleStreamSubscription?.cancel();
    _cityStreamSubscription?.cancel();
    return super.close();
  }
}
