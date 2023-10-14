import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/city_repository.dart';
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
  CreateCustomerBloc({
    required this.cityRepository,
    required this.screensCubit,
    required this.customerBloc,
  }) : super(LoadingCircleCitiesState()) {
    on<LoadCitiesEvent>(_onLoadCities);
  }

  void _onLoadCities(
      LoadCitiesEvent event, Emitter<CreateCustomerState> emit) async {
    List<Customer> existingCustomers = [];
    emit(LoadingCircleCitiesState());
    List<City> cities = await cityRepository.getCities(
        circleID: screensCubit.currentCircle.circle!.id);
    if (customerBloc.state is CustomerLoadedState) {
      existingCustomers =
          (customerBloc.state as CustomerLoadedState).customers;
    }
    emit(LoadedCircleCitiesState(cities: cities, existingCustomers: [...existingCustomers]));
  }
}