import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/customers_and_loan_data_repository.dart';
import '../../../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../../../models/ModelProvider.dart';

part 'loan_creation_event.dart';
part 'loan_creation_state.dart';

class LoanCreationBloc extends Bloc<LoanCreationEvent, LoanCreationState> {
  CustomerAndLoanDataRepository customerAndLoanDataRepository;
  ScreensCubit screensCubit;
  LoanCreationBloc({
    required this.screensCubit,
    required this.customerAndLoanDataRepository,
  }) : super(
          LoanCreationInitial(
            (screensCubit.currentCircle.circle!.day == WeekDay.DAILY)
                ? EmiType.DAILY
                : (screensCubit.currentCircle.circle!.day == WeekDay.MONTHLY)
                    ? EmiType.MONTHLY
                    : EmiType.WEEKLY,
          ),
        ) {
    on<LoanSubmissionEvent>(_onLoanSubmissionEvent);
    on<AdditionalLoanCreationEvent>(_onAdditionalLoanCreationEvent);
    on<LoanCreationResetEvent>(_onLoanCreationResetEvent);
  }

  _onLoanSubmissionEvent(
    LoanSubmissionEvent event,
    Emitter<LoanCreationState> emit,
  ) async {
    emit(LoanCreationLoadingState());
    final customerDetails = screensCubit.onCreationCustomerData;
    final isNewloan = event.isNewLoan;
    LoanSerialNumber? loanSerialNumber;
    int serialNo;
    try {
      loanSerialNumber = await customerAndLoanDataRepository
          .getCircleCurrentSerialNo(circleId: customerDetails.circleID);
      serialNo = int.parse(loanSerialNumber.serialNumber) + 1;
    } catch (e) {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
      return;
    }
    // *on submission first try to save Customer
    final customer = await customerAndLoanDataRepository.createCustomer(
      appUser: customerDetails.sub,
      uId: customerDetails.uId,
      name: customerDetails.name,
      mobileNumber: customerDetails.phone,
      address: customerDetails.address,
      city: customerDetails.city as CityDetails,
      date: event.date,
      circleID: customerDetails.circleID,
      loanIdentity: isNewloan
          ? '$serialNo'
          : customerDetails.loanIdentity!.isNotEmpty
              ? customerDetails.loanIdentity
              : '-',
    );

    // *on success of save customer then save loan
    final loan = await customerAndLoanDataRepository.createNewLoan(
      appUser: customerDetails.sub,
      totalLoanAmount: int.parse(event.givenAmount),
      loanEmiAmount: int.parse(event.emiAmount),
      loanTotalEmis: int.parse(event.totalEmis),
      loanIssuedDate: event.date,
      customer: customer,
      emiType: customerDetails.frequency == WeekDay.DAILY
          ? EmiType.DAILY
          : customerDetails.frequency == WeekDay.MONTHLY
              ? EmiType.MONTHLY
              : EmiType.WEEKLY,
      isAddtionalLoan: false,
      isNewLoan: isNewloan,
      paidEmis: event.paidEmis.isEmpty ? 0 : int.parse(event.paidEmis),
    );

    // *on success of save loan then save emi if paid emis are not empty
    bool result = event.paidEmis.isEmpty || int.parse(event.paidEmis) == 0
        ? true
        : await customerAndLoanDataRepository.createEmis(
            appUser: customerDetails.sub,
            loanID: loan.id,
            singleEmiAmount: int.parse(event.emiAmount),
            totalEmis: int.parse(event.totalEmis),
            loanTakenDate: loan.dateOfCreation.getDateTime(),
            customer: customer,
            loan: loan,
            emiFrequency: customerDetails.frequency,
            paidEmis: int.parse(event.paidEmis),
            isAddtionalLoan: false,
          );

    if (result) {
      if (!isNewloan) {
        emit(LoanCreationSuccessState(
          message: 'Loan created successfully',
          loanIdentity: customer.loanIdentity,
        ));
        return;
      }
      String updatedLoanSerialNo =
          await customerAndLoanDataRepository.updateLoanSerialNumber(
        loanSerialNumber: loanSerialNumber,
        serialNo: '$serialNo',
      );
      emit(LoanCreationSuccessState(
        message: 'Loan created successfully',
        loanIdentity: updatedLoanSerialNo,
      ));
    } else {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
    }
  }

  // ! on additional loan creation
  _onAdditionalLoanCreationEvent(
    AdditionalLoanCreationEvent event,
    Emitter<LoanCreationState> emit,
  ) async {
    final frequency = screensCubit.currentCircle.circle!.day;
    final currentCustomer = screensCubit.currentCustomer.customer;
    emit(LoanCreationLoadingState());
    LoanSerialNumber? loanSerialNumber;
    int serialNo;
    final isNewloan = event.isNewLoan;
    try {
      loanSerialNumber = await customerAndLoanDataRepository
          .getCircleCurrentSerialNo(circleId: currentCustomer!.circleID);
      serialNo = int.parse(loanSerialNumber.serialNumber) + 1;
    } catch (e) {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
      return;
    }
    final customer = await customerAndLoanDataRepository.updateCustomer(
      customer: currentCustomer,
      newLoanAddedDate: event.date,
      loanIdentity: isNewloan
          ? '$serialNo'
          : event.loanIdentity!.isNotEmpty
              ? event.loanIdentity as String
              : '-',
    );

    // *on success of customer updation then save add new loan to the existing customer
    final loan = await customerAndLoanDataRepository.createNewLoan(
      appUser: customer.sub,
      totalLoanAmount: int.parse(event.givenAmount),
      loanEmiAmount: int.parse(event.emiAmount),
      loanTotalEmis: int.parse(event.totalEmis),
      loanIssuedDate: event.date,
      customer: customer,
      emiType: frequency == WeekDay.DAILY
          ? EmiType.DAILY
          : frequency == WeekDay.MONTHLY
              ? EmiType.MONTHLY
              : EmiType.WEEKLY,
      isAddtionalLoan: true,
      isNewLoan: isNewloan,
      paidEmis: event.paidEmis.isEmpty ? 0 : int.parse(event.paidEmis),
    );

    // *on success of save loan then save emi
    bool result = event.paidEmis.isEmpty || int.parse(event.paidEmis) == 0
        ? true
        : await customerAndLoanDataRepository.createEmis(
            appUser: customer.sub,
            loanID: loan.id,
            singleEmiAmount: int.parse(event.emiAmount),
            totalEmis: int.parse(event.totalEmis),
            loanTakenDate: loan.dateOfCreation.getDateTime(),
            customer: customer,
            loan: loan,
            emiFrequency: frequency,
            paidEmis: int.parse(event.paidEmis),
            isAddtionalLoan: true,
          );

    if (result) {
      if (!isNewloan) {
        emit(LoanCreationSuccessState(
          message: 'Loan created successfully',
          loanIdentity: customer.loanIdentity,
        ));
        return;
      }
      String updatedLoanSerialNo =
          await customerAndLoanDataRepository.updateLoanSerialNumber(
        loanSerialNumber: loanSerialNumber,
        serialNo: '$serialNo',
      );
      emit(LoanCreationSuccessState(
        message: 'Loan created successfully',
        loanIdentity: updatedLoanSerialNo,
      ));
    } else {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
    }
  }

  _onLoanCreationResetEvent(
      LoanCreationResetEvent event, Emitter<LoanCreationState> emit) {
    emit(
      LoanCreationInitial(
        screensCubit.currentCircle.circle!.day == WeekDay.DAILY
            ? EmiType.DAILY
            : screensCubit.currentCircle.circle!.day == WeekDay.MONTHLY
                ? EmiType.MONTHLY
                : EmiType.WEEKLY,
      ),
    );
  }
}
