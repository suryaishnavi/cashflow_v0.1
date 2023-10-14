part of 'cities_bloc.dart';

abstract class CitiesEvent extends Equatable {
  const CitiesEvent();

  @override
  List<Object> get props => [];
}

class CreateNewCity extends CitiesEvent {
  final String name;

  const CreateNewCity({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class UpdateCity extends CitiesEvent {
  final City city;
  final String name;

  const UpdateCity({
    required this.city,
    required this.name,
  });

  @override
  List<Object> get props => [city, name];
}

class DeleteCity extends CitiesEvent {
  final City city;

  const DeleteCity({
    required this.city,
  });

  @override
  List<Object> get props => [city];
}

class LoadCities extends CitiesEvent {
  final String circleID;

  const LoadCities({required this.circleID});

  @override
  List<Object> get props => [circleID];
}
