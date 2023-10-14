part of 'cities_bloc.dart';

abstract class CitiesState extends Equatable {
  const CitiesState();
  
  @override
  List<Object> get props => [];
}

class CitiesLoadingState extends CitiesState {}

class CitiesLoadedState extends CitiesState {
  final List<City> cities;
  // final List<CityDetails> cities;

  const CitiesLoadedState({
    required this.cities,
  });

  @override
  List<Object> get props => [cities];
}

class CitiesErrorState extends CitiesState {
  final String message;

  const CitiesErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}


