import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class EmisDataRepository {
  final DateTime expireDate = DateTime.now().add(const Duration(days: 90));
  String today = '${DateTime.now()}'.split(' ')[0];

  Future<List<Emi>> getAllEmis({required loanId}) async {
    List<Emi> emis = [];
    try {
      emis = await Amplify.DataStore.query(
        Emi.classType,
        where: Emi.LOANID.eq(loanId),
      );
      return emis;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Emi>> getEmiByStatus(
      {required String loanId, required EmiStatus status}) async {
    final List<Emi> emi = await Amplify.DataStore.query(Emi.classType,
        where: Emi.LOANID.eq(loanId) & Emi.STATUS.eq(status));
    return emi;
  }

  Future<List<Emi>> getCurrentEmi(
      {required loanId, required int emiNumber}) async {
    List<Emi> emis = [];
    try {
      emis = await Amplify.DataStore.query(
        Emi.classType,
        where: Emi.LOANID.eq(loanId) & Emi.EMINUMBER.eq(emiNumber),
      );
      return emis;
    } on DataStoreException catch (e) {
      safePrint('Something went wrong model: ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteEmi({required Emi emi}) async {
    try {
      await Amplify.DataStore.delete(emi);
    } on DataStoreException catch (e) {
      safePrint('Something went wrong deleting model: ${e.message}');
      rethrow;
    }
  }

  Future<void> createNewEMi({
    required int emiNumber,
    required String appUserId,
    required String customerName,
    required String loanIdentity,
    required String city,
    required int emiAmount,
    required int paidAmount,
    required String loanId,
    required String dueDate,
    required bool isExtraEmi,
  }) async {
    try {
      final newEmi = Emi(
        emiNumber: emiNumber,
        sub: appUserId,
        emiAmount: emiAmount,
        paidAmount: paidAmount,
        paidDate: TemporalDate.fromString(today),
        dueDate: TemporalDate.fromString(dueDate),
        loanID: loanId,
        isExtraEmi: isExtraEmi,
        customerName: customerName,
        loanIdentity: loanIdentity,
        city: city,
        status: EmiStatus.PAID,
      );
      await Amplify.DataStore.save(newEmi);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePaidEmi({
    required Emi emi,
    required int newAmount,
    required String updatedDate,
  }) async {
    try {
      final updatedEmi = emi.copyWith(
        updatedDate: TemporalDate.fromString(today),
        initialAmount: emi.initialAmount ?? emi.paidAmount,
        paidDate: TemporalDate.fromString(updatedDate),
        paidAmount: newAmount,
        status: EmiStatus.PAID,
      );
      await Amplify.DataStore.save(updatedEmi);
    } on Exception {
      rethrow;
    }
  }

  Future deleteAllEmis({required String loanId}) async {
    List<Emi> emis = await getAllEmis(loanId: loanId);
    try {
      for (var emi in emis) {
        await Amplify.DataStore.delete(emi);
      }
    } on Exception {
      rethrow;
    }
  }

  Stream<SubscriptionEvent<Emi>> observeEmi() {
    try {
      return Amplify.DataStore.observe(Emi.classType);
    } on Exception {
      rethrow;
    }
  }
}

// Depreciated code
/**
 *  
 // Future scheduleDeleteAllEmis({required String loanId}) async {
  //   List<Emi> emis = await getAllEmis(loanId: loanId);
  //   try {
  //     for (var emi in emis) {
  //       final updatedEmi = emi.copyWith(ttl: TemporalTimestamp(expireDate));
  //       await Amplify.DataStore.save(updatedEmi);
  //     }
  //   } on Exception {
  //     rethrow;
  //   }
  // }
  // emi subscription

  Stream<SubscriptionEvent<Emi>> listenToEmiSubscription() {
    try {
      return Amplify.DataStore.observe(Emi.classType);
    } on Exception {
      rethrow;
    }
  }

  Future<void> addExtraEmiWithPaidAmount({
    required int emiNumber,
    required String appUserId,
    required String customerName,
    required String loanIdentity,
    required int emiAmount,
    required String loanId,
    required TemporalDate dueDate,
    required paidAmount,
  }) async {
    try {
      final extraEmi = Emi(
        emiNumber: emiNumber,
        sub: appUserId,
        emiAmount: emiAmount,
        paidAmount: paidAmount,
        paidDate: TemporalDate.now(),
        dueDate: TemporalDate.fromString(dueDate.toString().split(' ')[0]),
        loanID: loanId,
        customerName: customerName,
        loanIdentity: loanIdentity,
        status: EmiStatus.PAID,
      );
      await Amplify.DataStore.save(extraEmi);
    } catch (e) {
      rethrow;
    }
  }

    // Future<void> updateEmi({
  //   required Emi emi,
  //   required int paidAmount,
  // }) async {
  //   try {
  //     final updatedEmi = emi.copyWith(
  //       paidDate: TemporalDate.fromString(today),
  //       paidAmount: paidAmount,
  //       status: EmiStatus.PAID,
  //     );
  //     await Amplify.DataStore.save(updatedEmi);
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  // Future<void> onDemandUpdateEmi({
  //   required Emi emi,
  // }) async {
  //   try {
  //     final updatedEmi = emi.copyWith(
  //       ttl: TemporalTimestamp(expireDate),
  //     );
  //     await Amplify.DataStore.save(updatedEmi);
  //   } on Exception {
  //     rethrow;
  //   }
  // }
 */