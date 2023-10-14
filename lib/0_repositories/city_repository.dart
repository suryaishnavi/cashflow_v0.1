import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class CityRepository {
  Future<List<City>> getCities({required String circleID}) async {
    try {
      final cities = await Amplify.DataStore.query(City.classType,
          where: City.CIRCLEID.eq(circleID));

      return cities;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNewCity(
      {required String name, required String circleID}) async {
    final city = City(name: name, circleID: circleID);
    try {
      await Amplify.DataStore.save(city);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCity(City city, String name) async {
    final updatedCity = city.copyWith(name: name);
    try {
      await Amplify.DataStore.save(updatedCity);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCity(City city) async {
    try {
      await Amplify.DataStore.delete(city);
    } catch (e) {
      rethrow;
    }
  }

  Stream observeCities() {
    return Amplify.DataStore.observe(City.classType);
  }
}