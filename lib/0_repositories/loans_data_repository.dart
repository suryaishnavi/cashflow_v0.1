import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class LoansDataRepository {
  String today = '${DateTime.now()}'.split(' ')[0];

  Future<List<Loan>> getAllLoans(
      {required String customerID, LoanStatus? loanStatus}) async {
    List<Loan> customerLoans = [];
    if(loanStatus != null) {
      try {
        customerLoans = await Amplify.DataStore.query(
          Loan.classType,
          where: Loan.CUSTOMERID.eq(customerID).and(Loan.STATUS.eq(loanStatus)),
        );
        return customerLoans;
      } on Exception {
        rethrow;
      }
    }
    try {
      customerLoans = await Amplify.DataStore.query(
        Loan.classType,
        where: Loan.CUSTOMERID.eq(customerID),
      );
      return customerLoans;
    } on Exception {
      rethrow;
    }
  }

  Future<Loan> getLoanById({required String loanId}) async {
    final List<Loan> loan = await Amplify.DataStore.query(Loan.classType,
        where: Loan.ID.eq(loanId));
    return loan.first;
  }

  Future<void> updateLoans({
    required Loan loan,
    required int paidAmount,
    required currentEmi,
    required LoanStatus loanStatus,
    required TemporalDate endDate,
    String? nextDueDate,
  }) async {
    if (loanStatus == LoanStatus.CLOSED) {
      final updatedLoan = loan.copyWith(
        paidAmount: paidAmount,
        paidEmis: currentEmi,
        status: loanStatus,
        endDate: endDate,
      );
      try {
        await Amplify.DataStore.save(updatedLoan);
      } on Exception {
        rethrow;
      }
    } else {
      final updatedLoan = loan.copyWith(
        paidAmount: paidAmount,
        paidEmis: currentEmi,
        status: loanStatus,
        nextDueDate: TemporalDate.fromString((nextDueDate as String)),
      );
      try {
        await Amplify.DataStore.save(updatedLoan);
      } on Exception {
        rethrow;
      }
    }
  }

  Future<void> onCloseLoan({
    required Loan loan,
    required String reasonForLoanTermination,
  }) async {
    final updatedLoan = loan.copyWith(
      collectibleAmount: loan.paidAmount,
      totalEmis: loan.paidEmis - 1,
      endDate: TemporalDate.fromString(today),
      status: LoanStatus.CLOSED,
      reasonForLoanTermination: reasonForLoanTermination,
      // ttl: TemporalTimestamp(expireDate),
    );
    try {
      await Amplify.DataStore.save(updatedLoan);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateLoanWhenUpdateEmiPaidAmount({
    required Loan loan,
    required int totalPaidAmount,
  }) async {
    final updatedLoan = loan.copyWith(
      paidAmount: totalPaidAmount,
    );
    try {
      await Amplify.DataStore.save(updatedLoan);
    } on DataStoreException catch (e) {
      safePrint('Something went wrong updating loan: ${e.message}');
      rethrow;
    }
  }

  // update loan with new collectble loan amount
  Future<bool> updateLoanWithNewCollectibleAmount({
    required Loan loan,
    required int newCollectibleAmount,
  }) async {
    bool isUpdated = false;
    final updatedLoan = loan.copyWith(
      collectibleAmount: newCollectibleAmount,
    );
    try {
      await Amplify.DataStore.save(updatedLoan);
      return isUpdated = true;
    } on Exception {
      return isUpdated;
    }
  }

  // delete loan
  Future<void> deleteLoan({
    required Loan loan,
  }) async {
    try {
      await Amplify.DataStore.delete(loan);
    } on Exception {
      rethrow;
    }
  }
}
