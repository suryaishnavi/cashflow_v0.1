import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class CircleDataRepository {
  Future<List<Circle>> getCircles({required String id}) async {
    try {
      final circles = await Amplify.DataStore.query(Circle.classType,
          where: Circle.APPUSERID.eq(id));

      return circles;
    } catch (e) {
      rethrow;
    }
  }

  Future<Circle> createCircle({
    required sub,
    required circleName,
    required day,
    required appuserID,
  }) async {
    final newCircle = Circle(
      sub: sub,
      circleName: circleName,
      day: day,
      appuserID: appuserID,
    );

    try {
      await Amplify.DataStore.save(newCircle);
      return newCircle;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createNewSerialNo({required String circleID}) async {
    final newSerialNo = LoanSerialNumber(
      circleID: circleID,
      serialNumber: '0',
    );
    try {
      await Amplify.DataStore.save(newSerialNo);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSerialNo({required LoanSerialNumber serialNo}) async {
    try {
      await Amplify.DataStore.delete(serialNo);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCircle(
      Circle circle, String circleName, WeekDay weekDay) async {
    final updatedCircle = circle.copyWith(
      circleName: circleName,
      day: weekDay,
    );
    try {
      await Amplify.DataStore.save(updatedCircle);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCircle(Circle circle) async {
    try {
      await Amplify.DataStore.delete(circle);
    } catch (e) {
      rethrow;
    }
  }

  Stream<SubscriptionEvent<Circle>> observeCircles() {
    return Amplify.DataStore.observe(Circle.classType);
  }
}
