import 'package:amplify_flutter/amplify_flutter.dart';

import '../../models/ModelProvider.dart';


class GetCustomerData {
  Future<List<Customer>> getCustomers({required String circleId}) async {
    try {
      final customers = await Amplify.DataStore.query(Customer.classType,
          where: Customer.CIRCLEID.eq(circleId));

      return customers;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Loan>> getLoan({required String customerId}) async {
    try {
      final List<Loan> loans = await Amplify.DataStore.query(Loan.classType,
          where: Loan.CUSTOMERID.eq(customerId));

      return loans;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Emi>> getEmi({required String loanId}) async {
    try {
      final List<Emi> emis = await Amplify.DataStore.query(Emi.classType,
          where: Emi.LOANID.eq(loanId)&Emi.PAIDDATE.ne(null));

      return emis;
    } catch (e) {
      rethrow;
    }
  }
}
