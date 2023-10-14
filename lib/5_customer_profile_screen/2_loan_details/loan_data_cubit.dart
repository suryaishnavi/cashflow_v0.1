import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../0_repositories/emis_data_repository.dart';
import '../../0_repositories/loans_data_repository.dart';
import '../../models/ModelProvider.dart';

part 'loan_data_state.dart';

class LoanDataCubit extends Cubit<LoanDataState> {
  final LoansDataRepository loansDataRepo;
  final EmisDataRepository emisDataRepo;
  LoanDataCubit({
    required this.emisDataRepo,
    required this.loansDataRepo,
  }) : super(LoanLoadingState());

  void getLoans({required String customerId}) async {
    try {
      final List<Loan> loansData =
          await loansDataRepo.getAllLoans(customerID: customerId);
      emit(LoanLoadedState(loansData: loansData));
    } on Exception catch (e) {
      emit(LoanDataErrorState(e));
    }
  }

  void updateLoanAmount({required Loan loan, required updatedAmount}) async {
    try {
      final result = await loansDataRepo.updateLoanWithNewCollectibleAmount(
        loan: loan,
        newCollectibleAmount: updatedAmount,
      );
      if (result) {
        emit(LoanUpdatedState());
        getLoans(customerId: loan.customerID);
      } else {
        emit(LoanFailedToUpdate());
        getLoans(customerId: loan.customerID);
      }
    } on Exception catch (e) {
      emit(LoanDataErrorState(e));
    }
  }

  void closeLoan({
    required Loan loan,
    required String reasonForLoanTermination,
  }) async {
    try {
      await loansDataRepo.onCloseLoan(
        loan: loan,
        reasonForLoanTermination: reasonForLoanTermination,
      );
      getLoans(customerId: loan.customerID);
    } on Exception catch (e) {
      emit(LoanDataErrorState(e));
    }
  }

  void deleteLoan({required Loan loan}) async {
    emit(LoanLoadingState());
    try {
      await emisDataRepo.deleteAllEmis(loanId: loan.id);
      await loansDataRepo.deleteLoan(loan: loan);
      getLoans(customerId: loan.customerID);
    } on Exception catch (e) {
      emit(LoanDataErrorState(e));
    }
  }
}
