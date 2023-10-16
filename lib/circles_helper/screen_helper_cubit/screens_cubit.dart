import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../1_session/session_cubit/session_cubit.dart';
import '../../info_helper/current_circle.dart';
import '../../info_helper/current_circle_id.dart';
import '../../info_helper/current_customer.dart';
import '../../info_helper/current_customer_details.dart';
import '../../info_helper/on_creation_customer_data.dart';
import '../../models/ModelProvider.dart';

enum ScreensState {
  overView,
  customers,
  customerProfileView,
  customerCreation,
  loanCreation,
  additionalLoan,
  resetState,
  citiesView,
}

class ScreensCubit extends Cubit<ScreensState> {
  // * Current Circle Id
  final _currentCircleIdController = StreamController<CurrentCircleId>();
  // * Current circle for new cities
  final _cityCircleStreamController = StreamController<CurrentCircleId>();
  // * On Creation Customer Data
  late OnCreationCustomerData onCreationCustomerData;
  // * Current Customer Details
  final _currentCustomerDetailsController =
      StreamController<CurrentCustomerDetails>();

  // * setting current circle
  CurrentCircle currentCircle = CurrentCircle();
  // * setting current customer
  CurrentCustomer currentCustomer = CurrentCustomer();

  // get user from session cubit state and assign it to user
  final SessionCubit sessionCubit;

  ScreensCubit({required this.sessionCubit}) : super(ScreensState.overView);
  //* Current Circle Id
  Stream<CurrentCircleId> get currentCircleIdStream =>
      _currentCircleIdController.stream.asBroadcastStream();
  //* Current Customer Details
  Stream<CurrentCustomerDetails> get currentCustomerDetailsStream =>
      _currentCustomerDetailsController.stream.asBroadcastStream();
  //* current circle for new cities
  Stream<CurrentCircleId> get cityCircleStream =>
      _cityCircleStreamController.stream.asBroadcastStream();

  void showCircles() {
    emit(ScreensState.overView);
  }

  void showCities({required Circle circle}) async {
    currentCircle.circle = circle;
    _cityCircleStreamController.sink.add(CurrentCircleId(circle: circle));
    emit(ScreensState.citiesView);
    emit(ScreensState.resetState);
  }

  void showCustomers({required Circle circle}) async {
    currentCircle.circle = circle;
    _currentCircleIdController.sink.add(CurrentCircleId(circle: circle));
    emit(ScreensState.customers);
    emit(ScreensState.resetState);
  }

  void showCustomerLoanCreation({
    required String uId,
    required String name,
    required String phone,
    required String address,
    required CityDetails city,
    required String loanIdentity,
  }) {
    onCreationCustomerData = OnCreationCustomerData(
      sub: sessionCubit.user.id,
      uId: uId,
      name: name,
      phone: phone,
      address: address,
      city: city,
      loanIdentity: loanIdentity,
      circleID: currentCircle.circle!.id,
      frequency: currentCircle.circle!.day,
    );
    emit(ScreensState.loanCreation);
    emit(ScreensState.resetState);
  }

  void showCustomerProfileView({
    required customer,
  }) {
    currentCustomer.customer = customer;
    _currentCustomerDetailsController.sink.add(CurrentCustomerDetails(
      customer: customer,
    ));
    emit(ScreensState.customerProfileView);
    emit(ScreensState.resetState);
  }

  void signOut() {
    close();
    sessionCubit.signOut();
  }

  @override
  Future<void> close() {
    _currentCircleIdController.close();
    _currentCustomerDetailsController.close();
    _cityCircleStreamController.close();
    currentCircle.circle = null;
    return super.close();
  }
}
