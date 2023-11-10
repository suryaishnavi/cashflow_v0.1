import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/city_repository.dart';
import '../../../0_repositories/customers_and_loan_data_repository.dart';
import '../../../common/screen_helper_cubit/common_cubit.dart';
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
    on<CityChangingEvent>(_onCityChangingState);
  }

  void _onLoadCities(
      LoadCitiesEvent event, Emitter<CreateCustomerState> emit) async {
    List<Customer> existingCustomers = [];
    String circleId = screensCubit.currentCircle.circle!.id;
    final LoanSerialNumber loanIdentity = await customerAndLoanDataRepository
        .getCircleCurrentSerialNo(circleId: circleId);
    emit(LoadingCircleCitiesState());
    List<City> cities = await cityRepository.getCities(circleID: circleId);
    if (customerBloc.state is CustomerLoadedState) {
      existingCustomers = (customerBloc.state as CustomerLoadedState).customers;
    }
    // final City city = City(
    //     id: cities.first.id,
    //     name: cities.first.name,
    //     circleID: cities.first.circleID);
    emit(LoadedCircleCitiesState(
      cities: cities,
      existingCustomers: [...existingCustomers],
      loanIdentity: loanIdentity.serialNumber,
      selectedCity: cities.first,
    ));
  }

  void _onLoanIdentityChangingState(LoanIdentityChangingEvent event,
      Emitter<CreateCustomerState> emit) async {
    emit((state as LoadedCircleCitiesState)
        .copyWith(loanIdentity: event.loanIdentity));
  }

  void _onCityChangingState(
      CityChangingEvent event, Emitter<CreateCustomerState> emit) async {
    // final City city = City(
    // id: event.city.id,
    // name: event.city.name,
    // circleID: event.city.circleID);
    emit((state as LoadedCircleCitiesState).copyWith(selectedCity: event.city));
  }
}
