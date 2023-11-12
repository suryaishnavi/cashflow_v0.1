import 'package:amplify_flutter/amplify_flutter.dart';

import '../../models/ModelProvider.dart';

class GetCustomerData {
  Future<List<Customer>> getCustomers({required String circleId}) async {
    try {
      final List<Customer> customers = await Amplify.DataStore.query(
        Customer.classType,
        where: Customer.CIRCLEID.eq(circleId),
      );
      return customers;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Loan>> getLoan({required String customerId}) async {
    try {
      final List<Loan> loans = await Amplify.DataStore.query(
        Loan.classType,
        where: Loan.CUSTOMERID.eq(customerId),
      );

      return loans;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Emi>> getEmi(
      {required String loanId, required TemporalDate date}) async {
    try {
      final List<Emi> emis = await Amplify.DataStore.query(
        Emi.classType,
        where: Emi.LOANID.eq(loanId) & Emi.PAIDDATE.eq(date),
      );
      return emis;
    } catch (e) {
      rethrow;
    }
  }
}
