import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/city_repository.dart';
import '../../../0_repositories/customers_and_loan_data_repository.dart';
import '../../../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../../../models/ModelProvider.dart';
import '../../customer_bloc/customer_bloc.dart';

part 'create_customer_event.dart';
part 'create_customer_state.dart';

class CreateCustomerBloc
    extends Bloc<CreateCustomerEvent, CreateCustomerState> {
  final CityRepository cityRepository;
  final CustomerBloc customerBloc;
  final ScreensCubit screensCubit;
  final CustomerAndLoanDataRepository customerAndLoanDataRepository;
  CreateCustomerBloc({
    required this.cityRepository,
    required this.screensCubit,
    required this.customerBloc,
    required this.customerAndLoanDataRepository,
  }) : super(LoadingCircleCitiesState()) {
    on<LoadCitiesEvent>(_onLoadCities);
    on<LoanIdentityChangingEvent>(_onLoanIdentityChangingState);
  }

  void _onLoadCities(
      LoadCitiesEvent event, Emitter<CreateCustomerState> emit) async {
    List<Customer> existingCustomers = [];
    String circleID = screensCubit.currentCircle.circle!.id;
    final LoanSerialNumber loanIdentity = await customerAndLoanDataRepository
        .getCircleCurrentSerialNo(circleId: circleID);
    // int loanIdentity = screensCubit.currentCircle.circle!.serialNumber;
    emit(LoadingCircleCitiesState());
    List<City> cities = await cityRepository.getCities(
        circleID: screensCubit.currentCircle.circle!.id);
    if (customerBloc.state is CustomerLoadedState) {
      existingCustomers = (customerBloc.state as CustomerLoadedState).customers;
    }
    emit(LoadedCircleCitiesState(
        cities: cities, existingCustomers: [...existingCustomers], loanIdentity: loanIdentity.serialNumber));
  }

  void _onLoanIdentityChangingState(
      LoanIdentityChangingEvent event, Emitter<CreateCustomerState> emit) async {
    
    emit((state as LoadedCircleCitiesState).copyWith(loanIdentity: event.loanIdentity));
  }
}
