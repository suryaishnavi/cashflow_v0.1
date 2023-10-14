import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class AppUserDataRepository {
  Future<List<AppUser>> getUserbyId({required String id}) async {
    try {
      final List<AppUser> users = await Amplify.DataStore.query(
          AppUser.classType,
          where: AppUser.ID.eq(id));
      return users;
    } catch (e) {
      rethrow;
    }
  }

  // Future<AppUser> createNewAppUser({
  //   required String id,
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String password,
  // }) async {
  //   final newUser = AppUser(
  //     id: id,
  //     name: name,
  //     emailId: email,
  //     phoneNumber: phone,
  //     owner: '$id::$id',
  //     appUserSubscriptionDetails: AppUserSubscriptionDetails(
  //       startDate: TemporalDate(DateTime.now()),
  //       endDate: TemporalDate(DateTime.now().add(const Duration(days: 30))),
  //       isActive: true,
  //       subscribed: false,
  //     ),
  //   );

  //   try {
  //     await Amplify.DataStore.save(newUser);
  //     return newUser;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
