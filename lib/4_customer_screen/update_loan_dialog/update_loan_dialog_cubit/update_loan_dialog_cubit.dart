import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/ModelProvider.dart';
import '../../../0_repositories/customer_data_repository.dart';
import '../../../0_repositories/dependency_injection.dart';
import '../../../0_repositories/emis_data_repository.dart';
import '../../../0_repositories/emi_date_calculator.dart';
import '../../../0_repositories/loans_data_repository.dart';
import '../../../info_helper/customer_for_extra_emi.dart';

part 'update_loan_dialog_state.dart';

class UpdateLoanDialogCubit extends Cubit<UpdateLoanDialogState> {
  CustomerForExtraEmi customerForExtraEmi = CustomerForExtraEmi();
  // GetEmiDuration getEmiDuration = GetEmiDuration();
  final EmiDateCalculator emiCalc = getIt<EmiDateCalculator>();
  LoansDataRepository loansDataRepo;
  EmisDataRepository emisDataRepo;
  CustomerDataRepository customerDataRepo;
  UpdateLoanDialogCubit({
    required this.customerDataRepo,
    required this.loansDataRepo,
    required this.emisDataRepo,
  }) : super(UpdateLoanDialogInitial());

  // ! load loans
  void loadLoans({required Customer customer}) async {
    customerForExtraEmi.setCustomer = customer;
    try {
      emit(UpdateLoanDialogInitial());
      final List<Loan> allLoans =
          await loansDataRepo.getAllLoans(customerID: customer.id);
      final List<Loan> loans =
          allLoans.where((loan) => loan.status == LoanStatus.ACTIVE).toList();
      emit(LoansLoadedState(loans: loans));
    } on Exception catch (e) {
      emit(ErrorState(message: e));
    }
  }

  // ! mark as inactive
  void markAsInactive({required Customer customer}) async {
    try {
      bool responce = await customerDataRepo.markAsInactive(customer: customer);
      if (responce) {
        emit(CustomerMarkedAsInactiveState());
      }
    } on Exception catch (e) {
      emit(ErrorState(message: e));
    }
  }

  // ! update loan amount on popup
  Future<void> updateLoan({
    required String emiValue,
    required Loan loan,
    required Customer customer,
  }) async {
    if (emiValue.isNotEmpty) {
      final int emiAmount = double.parse(emiValue).roundToDouble().toInt();
      final int totalPaidAmount = loan.paidAmount + emiAmount;
      final LoanStatus loanStatus = (totalPaidAmount < loan.collectibleAmount)
          ? LoanStatus.ACTIVE
          : LoanStatus.CLOSED;

      await newEmiAndUpdateLoan(
        paidAmount: emiAmount,
        emiAmount: loan.emiAmount,
        loan: loan,
        loanStatus: loanStatus,
        customer: customer,
      );
    }
  }

  // ! creating new emi and update loan
  Future<void> newEmiAndUpdateLoan({
    required int emiAmount,
    required Loan loan,
    required LoanStatus loanStatus,
    required Customer customer,
    required int paidAmount,
  }) async {
    try {
      final DateTime today =
          DateTime.parse(DateTime.now().toString().split(' ')[0]);
      final DateTime endDate = loan.endDate.getDateTime();
      // is endDate before today

      int currentEmi = loan.paidEmis + 1;
      // Check if there are extra EMIs due and it's before the end date
      bool isExtraEmi =
          (loan.totalEmis < currentEmi) && (today.isBefore(endDate));
      // * create new emi
      await emisDataRepo.createNewEMi(
        emiNumber: loan.paidEmis + 1,
        appUserId: loan.sub,
        customerName: customer.customerName,
        loanIdentity: customer.loanIdentity,
        emiAmount: emiAmount,
        loanId: loan.id,
        paidAmount: paidAmount,
        dueDate: emiCalc.calculateLoanEndDate(
            loanTakenDate: loan.dateOfCreation.getDateTime(),
            totalEmis: loan.paidEmis + 1,
            emiFrequency: loan.emiType),
        isExtraEmi: isExtraEmi,
      );
      // * update loan
      await loansDataRepo.updateLoans(
        loan: loan,
        paidAmount: loan.paidAmount + paidAmount,
        currentEmi: loan.paidEmis + 1,
        loanStatus: loanStatus,
        nextDueDate: emiCalc.calculateLoanEndDate(
            loanTakenDate: loan.dateOfCreation.getDateTime(),
            totalEmis: loan.paidEmis + 2,
            emiFrequency: loan.emiType),
        endDate: loan.endDate,
      );
      // * update customer
      await customerDataRepo.updateCustomerLoanUpdatedDate(
        customer: customer,
        paidAmount: paidAmount,
        emiAmount: emiAmount,
      );
      emit(LoanUpdatedState(customer: customer));
    } catch (e) {
      emit(LoanUpdatedErrorState(message: e.toString()));
    }
  }
}

/**
 * 
      // if (loan.paidEmis < loan.totalEmis) {
      //   if (totalPaidAmount < loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.ACTIVE,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   } else if (totalPaidAmount == loan.collectibleAmount ||
      //       totalPaidAmount > loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.CLOSED,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   }
      // } else if (loan.paidEmis == loan.totalEmis) {
      //   if (totalPaidAmount < loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.ACTIVE,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   } else if (totalPaidAmount > loan.collectibleAmount ||
      //       totalPaidAmount == loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.CLOSED,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   }
      // } else if (loan.paidEmis > loan.totalEmis) {
      //   if (totalPaidAmount < loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.ACTIVE,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   } else if (totalPaidAmount > loan.collectibleAmount ||
      //       totalPaidAmount == loan.collectibleAmount) {
      //     await newEmiAndUpdateLoan(
      //       emiAmount: emiAmount,
      //       loan: loan,
      //       loanStatus: LoanStatus.CLOSED,
      //       customer: customer,
      //       dueDate: duration,
      //     );
      //   }
      // }
 */

/**
 *   Future<void> newEmiAndUpdateLoan(
    double emiAmount,
    Loan loan,
    LoanStatus loanStatus,
    Customer customer,
  ) async {
    final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
      emiNumber: loan.paidEmis,
      loanId: loan.id,
    );

    try {
      await emisDataRepo.updateEmi(
        emi: currentEmi.first,
        paidAmount: emiAmount.toInt(),
      );

      await loansDataRepo.updateLoans(
        loan: loan,
        paidAmount: loan.paidAmount + emiAmount.toInt(),
        currentEmi: loan.paidEmis + 1,
        loanStatus: loanStatus,
        nextDueDate: getEmiDuration.getEmiDuration(loan.emiType),
      );

      await customerDataRepo.updateCustomerLoanUpdatedDate(customer: customer);

      emit(LoanUpdatedState());
    } catch (e) {
      emit(LoanUpdatedErrorState(message: e.toString()));
    }
  }
 */

/**
 * void updateLoan({
    required String value,
    required Loan loan,
  }) async {
    final String loanId = loan.id;
    final int emiNumber = loan.currentEmi;
    final int totalEmis = loan.totalEmis;
    final int currentEmi = loan.currentEmi;
    final int collectibleAmount = loan.collectibleAmount;
    final int paidAmount = loan.paidAmount;
    final EmiType emiType = loan.emiType;

    if (value.isNotEmpty) {
      // int number = double.parse(numberString).round();
      final int emiAmount = double.parse(value).round();
      final int totalPaidAmount = paidAmount + emiAmount;
      final duration = emiType == EmiType.WEEKLY
          ? DateTime.now().add(const Duration(days: 7))
          : emiType == EmiType.DAILY
              ? DateTime.now().add(const Duration(days: 1))
              : DateTime(
                  DateTime.now().year,
                  DateTime.now().month + 1,
                  DateTime.now().day,
                );
      if (currentEmi < totalEmis) {
        if (totalPaidAmount < collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update loan +1
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber + 1,
              loanStatus: LoanStatus.ACTIVE, //? Loan is in Active State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount == collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount > collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        }
      } else if (currentEmi == totalEmis) {
        if (totalPaidAmount < collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update loan +1
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber + 1,
              loanStatus: LoanStatus.ACTIVE, //? Loan is in Active State
            );
            // * create new emi for next 7 days
            await emisDataRepo.addExtraEmi(
              emiNumber: emiNumber + 1,
              loanId: loanId,
              appUserId: loan.sub,
              emiAmount: emiAmount,
              date: duration,
              customerName: customerNameForExtraEmi.getName,
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount == collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount > collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        }
      } else if (currentEmi > totalEmis) {
        if (totalPaidAmount < collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update loan +1
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber + 1,
              loanStatus: LoanStatus.ACTIVE, //? Loan is in Active State
            );
            // * create new emi for next 7 days
            await emisDataRepo.addExtraEmi(
              emiNumber: emiNumber + 1,
              loanId: loanId,
              appUserId: loan.sub,
              emiAmount: emiAmount,
              date: duration,
              customerName: customerNameForExtraEmi.getName,
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount == collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        } else if (totalPaidAmount > collectibleAmount) {
          // * get current emi
          final List<Emi> currentEmi = await emisDataRepo.getCurrentEmi(
            emiNumber: emiNumber,
            loanId: loanId,
          );
          try {
            // * update current emi
            await emisDataRepo.updateEmi(
              emi: currentEmi.first,
              paidAmount: emiAmount,
            );
            // * update and schedule delete all emis
            await emisDataRepo.scheduleDeleteAllEmis(loanId: loanId);
            // * update and schedule delete loan
            await loansDataRepo.updateLoans(
              loan: loan,
              paidAmount: totalPaidAmount,
              currentEmi: emiNumber,
              loanStatus: LoanStatus.CLOSED, //! Loan is in Closed State
            );
            emit(LoanUpdatedState());
          } catch (e) {
            emit(LoanUpdatedErrorState(message: e.toString()));
          }
        }
      }
    } else {
      // print('nothing to do');
      // nothing to with empty emi
    }
  }
 */

