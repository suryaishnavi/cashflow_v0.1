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

  Future<void> updateCustomerLoanUpdatedDate({
    required Customer customer,
    required int emiAmount,
    required int paidAmount,
    required String loanIdentity,
    required LoanStatus loanStatus,
    DateTime? paidDate,
  }) async {
    TemporalDate newpaidDate({required DateTime date}) =>
        TemporalDate.fromString('$date'.split(' ')[0]);

    List<String> getLoanIdentity() {
      List<String> listOfLoanId = customer.loanIdentity;

      // remove the loanIdentity from oldLoanIdentity
      if (loanStatus != LoanStatus.ACTIVE) {
        listOfLoanId = listOfLoanId.where((id) => id != loanIdentity).toList();
      }

      // return updatedLoanIdentity;
      return listOfLoanId;
    }

    //  if one or more loans paid then update the loan paid amount
    ({int paidAmount, int emiAmount}) getPaymentInfo() {
      int totalPaidAmount = paidAmount;
      int totalEmiAmount = emiAmount;

      if (customer.paymentInfo != null) {
        if (customer.paymentInfo?.paidDate.getDateTime() ==
            DateTime.parse(today)) {
          totalEmiAmount += customer.paymentInfo!.emiAmount;
          totalPaidAmount += customer.paymentInfo!.paidAmount;
        }
      }

      if (loanStatus != LoanStatus.ACTIVE) {
        totalEmiAmount = totalPaidAmount;
      }

      return (emiAmount: totalEmiAmount, paidAmount: totalPaidAmount);
    }

    final updatedCustomer = customer.copyWith(
      loanIdentity: getLoanIdentity(),
      paymentInfo: PaymentDetails(
        customerID: customer.id,
        emiAmount: getPaymentInfo().emiAmount,
        paidAmount: getPaymentInfo().paidAmount,
        loanIdentity: loanIdentity,
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

  Future<void> deleteCustomer({required Customer customer}) async {
    try {
      await Amplify.DataStore.delete(customer);
    } on Exception {
      rethrow;
    }
  }
}
