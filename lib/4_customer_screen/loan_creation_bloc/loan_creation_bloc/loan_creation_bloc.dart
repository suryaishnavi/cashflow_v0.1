import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/customer_data_repository.dart';
import '../../../0_repositories/customers_and_loan_data_repository.dart';
import '../../../common/screen_helper_cubit/common_cubit.dart';
import '../../../models/ModelProvider.dart';

part 'loan_creation_event.dart';
part 'loan_creation_state.dart';

class LoanCreationBloc extends Bloc<LoanCreationEvent, LoanCreationState> {
  final CustomerAndLoanDataRepository customerAndLoanDataRepository;
  final CustomerDataRepository customerDataRepository;
  final ScreensCubit screensCubit;
  LoanCreationBloc({
    required this.screensCubit,
    required this.customerAndLoanDataRepository,
    required this.customerDataRepository,
  }) : super(LoanCreationLoadingState()) {
    on<LoanCreationInitialEvent>(_onLoanCreationInitialEvent);
    on<LoanSubmissionEvent>(_onLoanSubmissionEvent);
    on<AdditionalLoanCreationEvent>(_onAdditionalLoanCreationEvent);
  }

  _onLoanCreationInitialEvent(
      LoanCreationInitialEvent event, Emitter<LoanCreationState> emit) async {
    final frequency = screensCubit.currentCircle.circle!.day;
    final loanIdentity =
        await customerAndLoanDataRepository.getCircleCurrentSerialNo(
      circleId: screensCubit.currentCircle.circle!.id,
    );
    emit(
      LoanCreationInitial(
        emiType: frequency == WeekDay.DAILY
            ? EmiType.DAILY
            : frequency == WeekDay.MONTHLY
                ? EmiType.MONTHLY
                : EmiType.WEEKLY,
        loanIdentity: loanIdentity.serialNumber,
      ),
    );
  }

  _onLoanSubmissionEvent(
    LoanSubmissionEvent event,
    Emitter<LoanCreationState> emit,
  ) async {
    emit(LoanCreationLoadingState());
    final customerDetails = screensCubit.onCreationCustomerData;
    final isNewloan = event.isNewLoan;
    LoanSerialNumber loanSerialNumber;
    try {
      loanSerialNumber = await customerAndLoanDataRepository
          .getCircleCurrentSerialNo(circleId: customerDetails.circleID);
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
      selectedCity: customerDetails.city,
      date: event.date,
      circleID: customerDetails.circleID,
      loanIdentity: customerDetails.loanIdentity,
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
      loanIdentity: customerDetails.loanIdentity,
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
            loanIdentity: customerDetails.loanIdentity,
          );

    if (result) {
      await customerAndLoanDataRepository.updateLoanSerialNumber(
        loanSerialNumber: loanSerialNumber,
        serialNo: (int.parse(customerDetails.loanIdentity) + 1).toString(),
      );
      emit(LoanCreationSuccessState(
        message: 'Loan created successfully',
        loanIdentity: customerDetails.loanIdentity,
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
    // update customer
    final updatedCustomer = await customerDataRepository.getCustomerById(
        customerID: currentCustomer!.id);
    emit(LoanCreationLoadingState());
    LoanSerialNumber loanSerialNumber;
    final isNewloan = event.isNewLoan;
    try {
      loanSerialNumber = await customerAndLoanDataRepository
          .getCircleCurrentSerialNo(circleId: currentCustomer.circleID);
    } catch (e) {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
      return;
    }


    // *on submission first try to update Customer
    final customer = await customerAndLoanDataRepository.updateCustomer(
      customer: updatedCustomer,
      newLoanAddedDate: event.date,
      loanIdentity: event.loanIdentity,
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
      loanIdentity: event.loanIdentity,
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
            loanIdentity: event.loanIdentity,
          );

    if (result) {
      final int number = int.parse(event.loanIdentity) + 1;
      await customerAndLoanDataRepository.updateLoanSerialNumber(
        loanSerialNumber: loanSerialNumber,
        serialNo: '$number',
      );
      emit(LoanCreationSuccessState(
        message: 'Loan created successfully',
        loanIdentity: event.loanIdentity,
      ));
    } else {
      emit(const LoanCreationErrorState(message: 'Loan creation failed'));
    }
  }
}
