import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../0_repositories/city_repository.dart';
import '../../0_repositories/customer_data_repository.dart';
import '../../0_repositories/customers_and_loan_data_repository.dart';
import '../../0_repositories/emis_data_repository.dart';
import '../../0_repositories/loans_data_repository.dart';
import '../../common/screen_helper_cubit/common_cubit.dart';
import '../../info_helper/current_circle_id.dart';
import '../../info_helper/current_circle.dart';
import '../../models/ModelProvider.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  bool isCustomersFiltered = false;
  final ScreensCubit screensCubit;
  final CurrentCircle currentCircle = CurrentCircle();
  final CustomerAndLoanDataRepository customersRepo =
      CustomerAndLoanDataRepository();
  final CustomerDataRepository customerDataRepository =
      CustomerDataRepository();
  final LoansDataRepository loansRepo = LoansDataRepository();
  final EmisDataRepository emisRepo = EmisDataRepository();
  final CityRepository cityRepository = CityRepository();
  StreamSubscription<CurrentCircleId>? _currentCircleIdSubscription;
  StreamSubscription? _customerStreamSubscription;
  CustomerBloc({required this.screensCubit}) : super(CustomerLoadingState()) {
    on<LoadCustomersEvent>(_onLoadCustomerEvent);
    on<ShowCustomerProfileEvent>(_onShowCustomerProfileEvent);
    on<SelectedCityCustomersEvent>(_onSelectedCityCustomers);
    on<DeleteCustomerEvent>(_onDeleteCustomerEvent);

    // * initialise the customerStreamSubscription
    _currentCircleIdSubscription =
        screensCubit.currentCircleIdStream.listen((circleDetails) {
      currentCircle.circle = circleDetails.circle;
      add(const LoadCustomersEvent());
      isCustomersFiltered = false;
    });
    observeCustomers();
  }

  void _onLoadCustomerEvent(
      LoadCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoadingState());
    try {
      final List<City> cities = await getCities();
      final List<Customer> allCustomers = await customerDataRepository
          .getCustomers(circleID: currentCircle.circle!.id);
      await Future.delayed(const Duration(milliseconds: 200));
      allCustomers.sort(sortCustomers);
      await Future.delayed(const Duration(milliseconds: 300));
      List<Customer> customers = [
        ...allCustomers.where(
            (customer) => customer.customerStatus == CustomerStatus.ACTIVE)
      ];
      emit(CustomerLoadedState(
        customers: allCustomers,
        cities: cities,
        selectedCity: cities[0],
        filteredCustomers: customers,
      ));
    } on Exception catch (e) {
      emit(CustomerErrorState(error: e));
    }
  }

  int sortCustomers(Customer a, Customer b) {
    // if (a.loanIdentity != '-' && b.loanIdentity != '-') {
    //   return a.loanIdentity.compareTo(b.loanIdentity);
    // } else if (a.loanIdentity != '-' && b.loanIdentity == '-') {
    //   return -1;
    // } else if (a.loanIdentity == '-' && b.loanIdentity != '-') {
    //   return 1;
    // } else {
    //   return 0;
    // }

    // sort if loan identity is not empty
    if (a.loanIdentity.isNotEmpty && b.loanIdentity.isNotEmpty) {
      return int.parse(a.loanIdentity[0])
          .compareTo(int.parse(b.loanIdentity[0]));
    } else if (a.loanIdentity.isNotEmpty && b.loanIdentity.isEmpty) {
      return -1;
    } else if (a.loanIdentity.isEmpty && b.loanIdentity.isNotEmpty) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<List<City>> getCities() async {
    final List<City> cities =
        await cityRepository.getCities(circleID: currentCircle.circle!.id);
    List<City> filteredCities = [
      City(
        id: '',
        name: 'All Customers',
        circleID: '',
      ),
      ...cities.map((e) => e.copyWith(name: e.name.toUpperCase()))
    ];
    return filteredCities;
  }

  void _onSelectedCityCustomers(
      SelectedCityCustomersEvent event, Emitter<CustomerState> emit) async {
    isCustomersFiltered = true;
    // reset the scroll position
    // emit(CustomerLoadingState());
    final List<City> cities = await getCities();

    final List<Customer> allCustomers = await customerDataRepository
        .getCustomers(circleID: currentCircle.circle!.id);

    allCustomers.sort(sortCustomers);

    List<Customer> customers = [
      ...allCustomers
          .where((customer) => customer.customerStatus == CustomerStatus.ACTIVE)
    ];

    List<Customer> selectedCityCustomers = [];
    if (event.city.id.isNotEmpty) {
      selectedCityCustomers = [
        ...customers.where((customer) => customer.city.id == event.city.id)
      ];
    } else {
      selectedCityCustomers = [...customers];
    }
    emit(CustomerLoadedState(
      customers: customers,
      cities: cities,
      selectedCity: event.city,
      filteredCustomers: selectedCityCustomers,
    ));
  }

  void _onDeleteCustomerEvent(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoadingState());
    try {
      // From customer get all loans first and then delete all emis of that loan and then delete the loan and then delete the customer
      final List<Loan> loans =
          await loansRepo.getAllLoans(customerID: event.customer.id);
      for (final loan in loans) {
        // delete all emis of that loan
        final List<Emi> emis = await emisRepo.getAllEmis(loanId: loan.id);
        for (final emi in emis) {
          await emisRepo.deleteEmi(emi: emi);
        }
        await loansRepo.deleteLoan(loan: loan); // delete the loan
      }
      await customerDataRepository.deleteCustomer(customer: event.customer);
      add(const LoadCustomersEvent());
    } on Exception catch (e) {
      emit(CustomerErrorState(error: e));
    }
  }

  void _onShowCustomerProfileEvent(
      ShowCustomerProfileEvent event, Emitter<CustomerState> emit) {
    screensCubit.showCustomerProfileView(customer: event.customer);
  }

  void observeCustomers() {
    final customerStream = customersRepo.observeCustomers();
    _customerStreamSubscription = customerStream.listen((_) {
      isCustomersFiltered
          ? add(SelectedCityCustomersEvent(
              city: (state as CustomerLoadedState).selectedCity))
          : add(const LoadCustomersEvent());
    });
  }

  @override
  Future<void> close() {
    isCustomersFiltered = false;
    _currentCircleIdSubscription
        ?.cancel(); // cancel the subscription when the cubit is closed
    _customerStreamSubscription?.cancel();
    // reset the scroll position
    return super.close();
  }
}
