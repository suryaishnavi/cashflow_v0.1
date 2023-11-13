import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cashflow/0_repositories/customer_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/ModelProvider.dart';
import '../../0_repositories/dependency_injection.dart';
import '../../0_repositories/emis_data_repository.dart';
import '../../0_repositories/emi_date_calculator.dart';
import '../../0_repositories/loans_data_repository.dart';
import '../2_loan_details/loan_data_cubit.dart';

part 'emi_state.dart';

class EmiCubit extends Cubit<EmiState> {
  final LoanDataCubit loanDataCubit;
  final EmisDataRepository emisDataRepo;
  final LoansDataRepository loansDataRepo;
  final CustomerDataRepository customerDataRepo;
  EmiCubit({
    required this.loansDataRepo,
    required this.emisDataRepo,
    required this.loanDataCubit,
    required this.customerDataRepo,
  }) : super(EmiLoading());

  // GetEmiDuration getEmiDuration = GetEmiDuration();
  final EmiDateCalculator emiCalc = getIt<EmiDateCalculator>();

  void getEmis({required Loan loan}) async {
    emit(EmiLoading());
    int totalEmis = loan.totalEmis; // 12
    int totalPaidEmis = loan.paidEmis; //0
    int totalUnpaidEmis() {
      if (loan.status == LoanStatus.CLOSED) {
        return 0;
      } else if (loan.status == LoanStatus.ACTIVE) {
        if (totalEmis == totalPaidEmis || totalEmis < totalPaidEmis) {
          return 1;
        } else if (totalEmis > totalPaidEmis) {
          return totalEmis - totalPaidEmis;
        }
      }
      // Handle other statuses if necessary
      return 0; // Default case
    }

    try {
      List<Emi> emis = await emisDataRepo.getAllEmis(loanId: loan.id);
      emis.sort((a, b) => a.emiNumber.compareTo(b.emiNumber));
      int emiNumber = emis.isEmpty ? 1 : emis.last.emiNumber + 1; // 12
      final dueDate = emis.isEmpty
          ? loan.dateOfCreation.getDateTime()
          : emis.last.dueDate.getDateTime();
      for (int i = 0; i < totalUnpaidEmis(); i++) {
        final dummyEmi = Emi(
          emiNumber: emiNumber,
          sub: loan.sub,
          customerName: '',
          loanIdentity: '',
          city: '',
          emiAmount: loan.emiAmount,
          status: EmiStatus.NOTPAID,
          dueDate: TemporalDate.fromString(
            emiCalc.calculateLoanEndDate(
              loanTakenDate: dueDate,
              totalEmis: i + 1,
              emiFrequency: loan.emiType,
            ),
          ),
          loanID: loan.id,
        );
        emiNumber++;
        // add emi to emi list
        emis.add(dummyEmi);
      }
      emit(EmiLoaded(emiList: emis));
    } on Exception catch (e) {
      emit(EmiError(e));
      rethrow;
    }
  }

  void updateEmiPaidAmount({
    required Emi emi,
    required int newAmount,
    required DateTime newDate,
  }) async {
    emit(EmiLoading());
    int totalPaidAmount = 0;
    String updatedDate = newDate.toString().split(' ')[0];
    String today = DateTime.now().toString().split(' ')[0];
    // Update emi
    await emisDataRepo.updatePaidEmi(
      emi: emi,
      newAmount: newAmount,
      updatedDate: updatedDate,
    );
    // Fetch loan
    final loan = await loansDataRepo.getLoanById(loanId: emi.loanID);
    // Fetch Customer

    // Again fetch all emi's and calculate all emis
    final List<Emi> paidEmiList = await emisDataRepo.getEmiByStatus(
        loanId: loan.id, status: EmiStatus.PAID);
    for (var element in paidEmiList) {
      totalPaidAmount += element.paidAmount!;
    }
    // Update loan
    await loansDataRepo.updateLoans(
      loan: loan,
      paidAmount: totalPaidAmount,
      currentEmi: loan.paidEmis,
      loanStatus: (totalPaidAmount >= loan.collectibleAmount)
          ? LoanStatus.CLOSED
          : LoanStatus.ACTIVE,
      endDate: loan.endDate,
      nextDueDate: loan.nextDueDate.toString(),
    );
    if (updatedDate == today) {
      // Update customer LoanUpdatedDate
      final customer =
          await customerDataRepo.getCustomerById(customerID: loan.customerID);
      await customerDataRepo.updateCustomerLoanUpdatedDate(
        customer: customer,
        emiAmount: loan.emiAmount,
        paidAmount: newAmount,
        paidDate: newDate,
        loanIdentity: loan.loanIdentity,
        loanStatus: loan.status
      );
    }
    getEmis(loan: loan);
    loanDataCubit.getLoans(customerId: loan.customerID);
  }
}

// ! This code will be used in future
/**
 *   int getDuration(
      {required EmiType emiType,
      required DateTime startDate,
      required DateTime endDate}) {
    const int weekly = 7;
    const int daily = 1;

    int getMonthlyDifference() {
      int yearsDifference = endDate.year - startDate.year;
      int monthsDifference = endDate.month - startDate.month;

      return yearsDifference * 12 + monthsDifference;
    }

    switch (emiType) {
      case EmiType.WEEKLY:
        return weekly;
      case EmiType.DAILY:
        return daily;
      default:
        return getMonthlyDifference();
    }
  }

  datesErrorHandling({
    required DateTime startDate,
    required DateTime endDate,
    required int totalEmis,
    required EmiType emiFrequency,
  }) {
    //
  }

  List<DateTime> getInBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
    required EmiType emiFrequency,
  }) {
    List<DateTime> emiDates = [];

    final duration = getDuration(
        emiType: emiFrequency, startDate: startDate, endDate: endDate);
    // calculate difference between start and end date
    int totalEmis = ((endDate.difference(startDate).inDays) / duration).ceil();
    for (int i = 0; i < totalEmis; i++) {
      String date = getEmiDuration.calculateLoanEndDate(
        loanTakenDate: startDate,
        totalEmis: i + 1,
        emiFrequency: emiFrequency,
      );
      emiDates.add(DateTime.parse(date));
    }
    return emiDates;
  }

  DateTime getMostRecentDate({
    required DateTime first,
    required DateTime second,
  }) {
    return first.isAfter(second) ? first : second;
  }

  void getAllEmis({required Loan loan}) async {
    emit(EmiLoading());
    List<Emi> emis = await emisDataRepo.getAllEmis(
        loanId: loan.id); // Actual customer paid emis
    List<Emi> allEmis = []; //All emis with dummy emis for place holders
    int totalEmis = loan.totalEmis; // 12
    DateTime loanCreatedDate = loan.dateOfCreation.getDateTime(); // start date
    DateTime loanEndDate = loan.endDate.getDateTime(); // end date
    DateTime loanNextDueDate = loan.nextDueDate.getDateTime(); // next due date
    DateTime mostRecentDate = getMostRecentDate(
      first: loanEndDate,
      second: loanNextDueDate,
    );
    List<DateTime> emiDates = []; // All emi dates
  }
 */