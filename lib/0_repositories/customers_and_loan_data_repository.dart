import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';
import 'dependency_injection.dart';
import 'emi_date_calculator.dart';

class CustomerAndLoanDataRepository {
  // installment duration for loans
  // GetEmiDuration getEmiDuration = GetEmiDuration();

  // initialize getEmiDuration
  final EmiDateCalculator emiCalc = getIt<EmiDateCalculator>();

  //! --- initialize
  Future<void> initialize() async {
    await Amplify.DataStore.start();
  }

  //! --- get circle current serial no.
  Future<LoanSerialNumber> getCircleCurrentSerialNo(
      {required String circleId}) async {
    try {
      final List<LoanSerialNumber> loanSerialNumbers =
          await Amplify.DataStore.query(LoanSerialNumber.classType,
              where: LoanSerialNumber.CIRCLEID.eq(circleId));
      return loanSerialNumbers.first;
    } catch (e) {
      rethrow;
    }
  }

  //! --- create customer
  Future<Customer> createCustomer({
    String? loanIdentity,
    required CityDetails city,
    required String appUser,
    required String uId,
    required String name,
    required String mobileNumber,
    required String address,
    required String circleID,
    required String date,
  }) async {
    final newCustomer = Customer(
      sub: appUser,
      uId: uId,
      customerName: name,
      phone: '+91$mobileNumber',
      address: address,
      dateOfCreation: TemporalDate.fromString(date),
      city: city,
      loanIdentity: loanIdentity ?? '-',
      customerStatus: CustomerStatus.ACTIVE,
      circleID: circleID,
    );
    try {
      await Amplify.DataStore.save(newCustomer);
      return newCustomer;
    } catch (e) {
      rethrow;
    }
  }

  //! --- update customer loanidentity on additional loan

  Future<Customer> updateCustomer({
    required Customer customer,
    required String loanIdentity,
    required String newLoanAddedDate,
  }) async {
    final updatedCustomer = customer.copyWith(
      loanIdentity: loanIdentity,
      newLoanAddedDate: TemporalDate.fromString(newLoanAddedDate),
      customerStatus: CustomerStatus.ACTIVE,
    );

    try {
      await Amplify.DataStore.save(updatedCustomer);
      return updatedCustomer;
    } catch (e) {
      rethrow;
    }
  }

  //! --- loan

  Future<Loan> createNewLoan({
    required String appUser,
    required int totalLoanAmount,
    required int loanEmiAmount,
    required int loanTotalEmis,
    required String loanIssuedDate,
    required Customer customer,
    required EmiType emiType,
    required bool isAddtionalLoan,
    required bool isNewLoan,
    required int paidEmis,
  }) async {
    // If it is not a new loan then paid amount will be paid emis * emi amount
    final paidAmount = !isNewLoan ? (paidEmis * loanEmiAmount) : 0;
    // For consistency we increment the paid emis by 1 and will decrease it by 1 at ui.
    int paidInstallments = (paidEmis == 0) ? 0 : paidEmis;
    if (customer.id.isEmpty) {
      throw Exception('Customer is not created');
    }
    final int collectibleAmount = (loanEmiAmount * loanTotalEmis);
    final newLoan = Loan(
      sub: appUser,
      givenAmount: totalLoanAmount,
      collectibleAmount: collectibleAmount,
      paidAmount: paidAmount,
      emiType: emiType,
      nextDueDate: TemporalDate(emiCalc
          .getEmiDuration(emiType)), //getEmiDuration.getEmiDuration(emiType)
      emiAmount: loanEmiAmount,
      totalEmis: loanTotalEmis,
      paidEmis: paidInstallments,
      dateOfCreation: TemporalDate.fromString(loanIssuedDate),
      status: LoanStatus.ACTIVE,
      customerID: customer.id,
      loanIdentity: customer.loanIdentity,
      endDate: TemporalDate.fromString(
        emiCalc.calculateLoanEndDate(
          loanTakenDate: DateTime.parse(loanIssuedDate),
          totalEmis: loanTotalEmis,
          emiFrequency: emiType,
        ),
      ),
    );
    try {
      await Amplify.DataStore.save(newLoan);
      return newLoan;
    } catch (e) {
      if (!isAddtionalLoan) {
        await Amplify.DataStore.delete<Customer>(customer);
      }
      rethrow;
    }
  }

//! --- emi

  Future<bool> createEmis({
    required String appUser,
    required String loanID,
    required int singleEmiAmount,
    required DateTime loanTakenDate,
    required int totalEmis,
    required Customer customer,
    required Loan loan,
    required WeekDay emiFrequency,
    required bool isAddtionalLoan,
    required int paidEmis,
  }) async {
    bool allEmisCreated = true;

    if (emiFrequency == WeekDay.DAILY) {
      const emiFrequency = 1;

      for (int i = 0; i < totalEmis; i++) {
        int daysToAdd = i * emiFrequency + emiFrequency;
        final dueDate = loanTakenDate.add(Duration(days: daysToAdd));

        if (i < paidEmis) {
          // Paid weeks
          try {
            createEmi(
              number: i,
              appUser: appUser,
              singleEmiAmount: singleEmiAmount,
              dueDate: dueDate,
              loanID: loanID,
              customer: customer,
              loan: loan,
              isAddtionalLoan: isAddtionalLoan,
              paidDate: dueDate,
              paidAmount: singleEmiAmount,
              status: EmiStatus.PAID,
            );
          } catch (e) {
            allEmisCreated = false;
            rethrow;
          }
        }
      }
    } else if (emiFrequency == WeekDay.MONTHLY) {
      const emiFrequency = 1;

      for (int i = 0; i < totalEmis; i++) {
        int monthsToAdd = i * emiFrequency + emiFrequency;
        final dueDate = DateTime(loanTakenDate.year,
            loanTakenDate.month + monthsToAdd, loanTakenDate.day);
        if (i < paidEmis) {
          // Paid weeks
          try {
            createEmi(
              number: i,
              appUser: appUser,
              singleEmiAmount: singleEmiAmount,
              dueDate: dueDate,
              loanID: loanID,
              customer: customer,
              loan: loan,
              isAddtionalLoan: isAddtionalLoan,
              paidDate: dueDate,
              paidAmount: singleEmiAmount,
              status: EmiStatus.PAID,
            );
          } catch (e) {
            allEmisCreated = false;
            rethrow;
          }
        }
      }
    } else {
      const emiFrequency = 7;
      for (int i = 0; i < totalEmis; i++) {
        int daysToAdd = i * emiFrequency + emiFrequency;
        final dueDate = loanTakenDate.add(Duration(days: daysToAdd));
        if (i < paidEmis) {
          // Paid weeks
          try {
            createEmi(
              number: i,
              appUser: appUser,
              singleEmiAmount: singleEmiAmount,
              dueDate: dueDate,
              loanID: loanID,
              customer: customer,
              loan: loan,
              isAddtionalLoan: isAddtionalLoan,
              paidDate: dueDate,
              paidAmount: singleEmiAmount,
              status: EmiStatus.PAID,
            );
          } catch (e) {
            allEmisCreated = false;
            rethrow;
          }
        }
      }
    }
    return allEmisCreated;
  }

  Future<void> createEmi({
    required int number,
    required String appUser,
    required int singleEmiAmount,
    required DateTime dueDate,
    required String loanID,
    required Customer customer,
    required Loan loan,
    required bool isAddtionalLoan,
    required EmiStatus status,
    DateTime? paidDate,
    int? paidAmount,
  }) async {
    final Emi newEmi = Emi(
      emiNumber: (number + 1),
      sub: appUser,
      emiAmount: singleEmiAmount,
      dueDate: TemporalDate.fromString(dueDate.toString().split(' ')[0]),
      loanID: loanID,
      customerName: customer.customerName,
      isExtraEmi: false,
      loanIdentity: customer.loanIdentity,
      paidDate: paidDate != null
          ? TemporalDate.fromString(paidDate.toString().split(' ')[0])
          : null,
      paidAmount: paidAmount,
      status: status,
    );
    try {
      await Amplify.DataStore.save(newEmi);
    } catch (e) {
      if (!isAddtionalLoan) {
        await Amplify.DataStore.delete<Customer>(customer);
      }
      await Amplify.DataStore.delete<Loan>(loan);
      rethrow;
    }
  }

  Future<String> updateLoanSerialNumber({
    required LoanSerialNumber loanSerialNumber,
    required String serialNo,
  }) async {
    try {
      final LoanSerialNumber updatedLoanSerialNumber =
          loanSerialNumber.copyWith(
        serialNumber: serialNo,
      );
      await Amplify.DataStore.save(updatedLoanSerialNumber);
      return updatedLoanSerialNumber.serialNumber;
    } catch (e) {
      rethrow;
    }
  }

  Stream<SubscriptionEvent<Customer>> observeCustomers() {
    return Amplify.DataStore.observe(Customer.classType);
  }

// loan subscription
  Stream<SubscriptionEvent<Loan>> observeLoans() {
    return Amplify.DataStore.observe(Loan.classType);
  }
}

//! code for emi creation if there are any paid emis
/**
 * 
enum WeekDay{
  DAILY,
  MONTHLY,
  WEEKLY
}

void main() {
final loanTakenDate = DateTime.now();
  final emiFrequency = WeekDay.WEEKLY;
  int totalEmis = 12;
    int paidEmis = 5;

    if (emiFrequency == WeekDay.DAILY) {
      const emiFrequency = 1;

      for (int i = 0; i < totalEmis; i++) {
        int daysToAdd = i * emiFrequency + emiFrequency;
        final dueDate = loanTakenDate.add(Duration(days: daysToAdd));

        if (i < paidEmis) {
          // Paid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} paidEmi');
        } else {
          // Unpaid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} UnpaidEmi');
        }
      }
    } else if (emiFrequency == WeekDay.MONTHLY) {
      const emiFrequency = 1;

      for (int i = 0; i < totalEmis; i++) {
        int monthsToAdd = i * emiFrequency + emiFrequency;
        final dueDate = DateTime(loanTakenDate.year,
            loanTakenDate.month + monthsToAdd, loanTakenDate.day);
        if (i < paidEmis) {
          // Paid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} paidEmi');
        } else {
          // Unpaid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} UnpaidEmi');
        }
      }
    } else {
      const emiFrequency = 7;

      for (int i = 0; i < totalEmis; i++) {
        int daysToAdd = i * emiFrequency + emiFrequency;
        final dueDate = loanTakenDate.add(Duration(days: daysToAdd));
        if (i < paidEmis) {
          // Paid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} paidEmi');
        } else {
          // Unpaid weeks
          print('$i ${dueDate.toLocal().toString().split(' ')[0]} UnpaidEmi');
        }
      }
    }
}
 */

//? code for emi creation if there are no paid emis

/**
 * Future<bool> createEmis({
    required String appUser,
    required String loanID,
    required int singleEmiAmount,
    required DateTime loanTakenDate,
    required int totalEmis,
    required Customer customer,
    required Loan loan,
    required String customerName,
    required WeekDay emiFrequency,
    required bool isAddtionalLoan,
  }) async {
    // if loan is not created then delete the customer
    if (loan is EmptyState) {
      throw Exception('Loan is not created');
    }
    late int daysToAdd;
    bool allEmisCreated = true;

    if (emiFrequency == WeekDay.DAILY) {
      // ! Daily Finance
      const int emiFrequency = 1;

      for (int i = 0; i < totalEmis; i++) {
        if (i == 0) {
          daysToAdd = i + emiFrequency;
        } else {
          daysToAdd = i * emiFrequency + emiFrequency;
        }
        DateTime dueDate = loanTakenDate.add(Duration(days: daysToAdd));
        final Emi newEmi = Emi(
          emiNumber: (i + 1),
          sub: appUser,
          emiAmount: singleEmiAmount,
          dueDate: TemporalDate.fromString(dueDate.toString().split(' ')[0]),
          loanID: loanID,
          customerName: customerName,
          status: EmiStatus.NOTPAID,
        );
        try {
          await Amplify.DataStore.save(newEmi);
        } catch (e) {
          await Amplify.DataStore.delete<Customer>(customer);
          await Amplify.DataStore.delete<Loan>(loan);
          allEmisCreated = false;
          break;
        }
      }
    } else if (emiFrequency == WeekDay.MONTHLY) {
      // ! Monthly Finance
      const int emiFrequency = 1;
      late int monthsToAdd;
      for (int i = 0; i < totalEmis; i++) {
        if (i == 0) {
          monthsToAdd = i + emiFrequency;
        } else {
          monthsToAdd = i * emiFrequency + emiFrequency;
        }
        DateTime dueDate = DateTime(loanTakenDate.year,
            loanTakenDate.month + monthsToAdd, loanTakenDate.day);
        final Emi newEmi = Emi(
            emiNumber: (i + 1),
            sub: appUser,
            emiAmount: singleEmiAmount,
            dueDate: TemporalDate.fromString(dueDate.toString().split(' ')[0]),
            loanID: loanID,
            customerName: customerName,
            status: EmiStatus.NOTPAID);
        try {
          await Amplify.DataStore.save(newEmi);
        } catch (e) {
          await Amplify.DataStore.delete<Customer>(customer);
          await Amplify.DataStore.delete<Loan>(loan);
          allEmisCreated = false;
          break;
        }
      }
    } else {
      // ! Weekly Finance
      const int emiFrequency = 7;
      for (int i = 0; i < totalEmis; i++) {
        if (i == 0) {
          daysToAdd = i + emiFrequency;
        } else {
          daysToAdd = i * emiFrequency + emiFrequency;
        }
        DateTime dueDate = loanTakenDate.add(Duration(days: daysToAdd));
        final Emi newEmi = Emi(
            emiNumber: (i + 1),
            sub: appUser,
            emiAmount: singleEmiAmount,
            dueDate: TemporalDate.fromString(dueDate.toString().split(' ')[0]),
            loanID: loanID,
            customerName: customerName,
            status: EmiStatus.NOTPAID);
        try {
          await Amplify.DataStore.save(newEmi);
        } catch (e) {
          if (!isAddtionalLoan) {
            await Amplify.DataStore.delete<Customer>(customer);
          }
          await Amplify.DataStore.delete<Loan>(loan);
          allEmisCreated = false;
          break;
        }
      }
    }
    return allEmisCreated;
  }
 */
