import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cashflow/models/ModelProvider.dart';

class CustomerDataRepository {
  String today = '${DateTime.now()}'.split(' ')[0];

  Future<List<Customer>> getCustomers({required circleID}) async {
    try {
      final customers = await Amplify.DataStore.query(Customer.classType,
          where: Customer.CIRCLEID.eq(circleID));

      return customers;
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> getCustomerById({required String customerID}) async {
    try {
      final customer = await Amplify.DataStore.query(Customer.classType,
          where: Customer.ID.eq(customerID));
      return customer.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markAsInactive({required Customer customer}) async {
    bool isSuccessful = false;
    try {
      final updatedCustomers = customer.copyWith(
        customerStatus: CustomerStatus.CLOSED,
      );
      await Amplify.DataStore.save(updatedCustomers);
      isSuccessful = true;
    } catch (e) {
      rethrow;
    }
    return isSuccessful;
  }

  updateCustomerLoanUpdatedDate({
    required Customer customer,
    required int emiAmount,
    required int paidAmount,
    DateTime? paidDate,
  }) async {
    TemporalDate newpaidDate({required DateTime date}) {
      return TemporalDate.fromString('$paidDate'.split(' ')[0]);
    }

    final updatedCustomer = customer.copyWith(
      paymentInfo: PaymentDetails(
        customerID: customer.id,
        emiAmount: emiAmount,
        paidAmount: paidAmount,
        loanIdentity: customer.loanIdentity,
        paidDate: paidDate != null
            ? newpaidDate(date: paidDate)
            : TemporalDate.fromString(today),
      ),
    );
    try {
      await Amplify.DataStore.save(updatedCustomer);
    } on Exception {
      rethrow;
    }
  }

  deleteCustomer({required Customer customer}) async {
    try {
      await Amplify.DataStore.delete(customer);
    } on Exception {
      rethrow;
    }
  }
}
