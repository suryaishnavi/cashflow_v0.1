import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/screen_helper_cubit/common_cubit.dart';
import '../../info_helper/current_customer_details.dart';
import '../../info_helper/from_customer_profile.dart';
import '../2_loan_details/loan_data_cubit.dart';

part 'customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  late FromCustomerProfile fromCustomerProfile = FromCustomerProfile();
  final LoanDataCubit loanDataCubit;
  StreamSubscription<CurrentCustomerDetails>?
      _currentCustomerDetailsSubscription;
  final ScreensCubit screensCubit;
  CustomerProfileCubit({
    required this.screensCubit,
    required this.loanDataCubit,
  }) : super(CustomerProfileInitial()) {
    _currentCustomerDetailsSubscription = screensCubit
        .currentCustomerDetailsStream
        .listen((customerDetailsInstance) {
      fromCustomerProfile.customer = customerDetailsInstance.customer;

      getCustomerData();
      getLoans();
    });
  }

  void getLoans() {
    loanDataCubit.getLoans(
      customerId: fromCustomerProfile.customer!.id,
    );
  }

  void getCustomerData() async {
    try {
      emit(CustomerProfileLoadedState(
        name: fromCustomerProfile.customer!.customerName,
        phone: fromCustomerProfile.customer!.phone,
        address: fromCustomerProfile.customer!.address,
      ));
    } on Exception catch (e) {
      emit(CustomerProfileError(message: e));
    }
  }

  @override
  Future<void> close() {
    _currentCustomerDetailsSubscription?.cancel();
    return super.close();
  }
}
