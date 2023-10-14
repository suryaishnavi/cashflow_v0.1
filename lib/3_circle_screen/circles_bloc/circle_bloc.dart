import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../0_repositories/circle_data_repository.dart';
import '../../0_repositories/city_repository.dart';
import '../../0_repositories/customer_data_repository.dart';
import '../../0_repositories/customers_and_loan_data_repository.dart';
import '../../0_repositories/emis_data_repository.dart';
import '../../0_repositories/loans_data_repository.dart';
import '../../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../../models/ModelProvider.dart';

part 'circle_event.dart';
part 'circle_state.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  StreamSubscription? _circleStreamSubscription;
  CircleDataRepository circleRepo;
  CustomerDataRepository customerRepo = CustomerDataRepository();
  LoansDataRepository loansRepo = LoansDataRepository();
  EmisDataRepository emiRepo = EmisDataRepository();
  CityRepository cityRepo = CityRepository();
  CustomerAndLoanDataRepository customerAndLoanRepo =
      CustomerAndLoanDataRepository();

  ScreensCubit screensCubit;
  bool observing = false;

  CircleBloc({
    required this.circleRepo,
    required this.screensCubit,
  }) : super(CirclesLoadingState()) {
    on<LoadCirclesEvent>(_onLoadCircles);
    on<ShowCustomersEvent>(_onShowCustomers);
    // on<NewCircleEvent>(_onNewCircle);
    on<ObserveCircles>(_onObserverCircles);
    on<ShowCities>(_onShowCities);
    on<DeleteCircle>(_onDeleteCircle);
  }

  void _onLoadCircles(LoadCirclesEvent event, Emitter<CircleState> emit) async {
    emit(CirclesLoadingState());
    try {
      if (!observing) {
        add(ObserveCircles(appUser: event.appUser));
        observing = true;
      }
      List<Circle> circles = await circleRepo.getCircles(id: event.appUser.id);
      circles.isEmpty
          ? emit(CircleEmptyState())
          : emit(CirclesLoadedState(circles: circles));
    } on DataStoreException catch (e) {
      emit(DatastoreErrorState(error: e, appUser: event.appUser));
    } on Exception catch (e) {
      emit(CircleErrorState(error: e));
    }
  }

  // void _onNewCircle(NewCircleEvent event, Emitter<CircleState> emit) async {
  //   try {
  //     List<Circle> circles = [];
  //     if (state is CirclesLoadedState) {
  //       circles = (state as CirclesLoadedState).circles;
  //     }
  //     circles.add(event.circle);
  //     emit(CirclesLoadedState(circles: circles));
  //   } on Exception catch (e) {
  //     emit(CircleErrorState(error: e));
  //   }
  // }

  void _onShowCustomers(ShowCustomersEvent event, Emitter<CircleState> emit) {
    if (state is CirclesLoadedState) {
      screensCubit.showCustomers(circle: event.circle);
    }
  }

  void _onShowCities(ShowCities event, Emitter<CircleState> emit) {
    if (state is CirclesLoadedState) {
      screensCubit.showCities(circle: event.circle);
    }
  }

  void _onDeleteCircle(DeleteCircle event, Emitter<CircleState> emit) async {
    try {
      // Step 1: Get all circles except the one to be deleted
      List<Circle> circles = [];
      if (state is CirclesLoadedState) {
        circles = (state as CirclesLoadedState)
            .circles
            .where((circle) => circle.id != event.circle.id)
            .toList();
      }
      emit(CirclesLoadingState());
      // Step 2: Fetch customers associated with the circle
      List<Customer> customers = await customerRepo.getCustomers(
        circleID: event.circle.id,
      );

      // Step 3: Fetch loans held by these customers
      List<Loan> loans = [];
      for (Customer customer in customers) {
        loans.addAll(await loansRepo.getAllLoans(customerID: customer.id));
      }

      // Step 4: Fetch and delete EMIs for these loans
      for (Loan loan in loans) {
        List<Emi> emis = await emiRepo.getAllEmis(loanId: loan.id);
        for (Emi emi in emis) {
          await emiRepo.deleteEmi(emi: emi);
        }
      }

      // Step 5: Delete the loans, customers, and the circle
      for (Loan loan in loans) {
        await loansRepo.deleteLoan(loan: loan);
      }
      for (Customer customer in customers) {
        await customerRepo.deleteCustomer(customer: customer);
      }
      await circleRepo.deleteCircle(event.circle);

      // Step 6: Get the serial number and delete it
      LoanSerialNumber serialNo =
          await customerAndLoanRepo.getCircleCurrentSerialNo(
        circleId: event.circle.id,
      );
      await circleRepo.deleteSerialNo(serialNo: serialNo);

      // Step 7: Get the city associated with the circle and delete it
      List<City> cities = await cityRepo.getCities(circleID: event.circle.id);
      for (City city in cities) {
        await cityRepo.deleteCity(city);
      }

      // Step 8: Emit the updated state
      circles.isEmpty
          ? emit(CircleEmptyState())
          : emit(CirclesLoadedState(circles: circles));
    } on Exception catch (e) {
      // Handle exceptions by emitting an error state and potentially logging the error
      emit(CircleErrorState(error: e));
      // You can also log the error for debugging purposes
      // print('Error in _onDeleteCircle: $e');
    }
  }

  void _onObserverCircles(ObserveCircles event, Emitter<CircleState> emit) {
    final circleStream = circleRepo.observeCircles();
    _circleStreamSubscription = circleStream.listen((streamEvent) {
      add(LoadCirclesEvent(appUser: event.appUser));
    });
  }

  @override
  Future<void> close() {
    _circleStreamSubscription?.cancel();
    _circleStreamSubscription = null;
    return super.close();
  }
}
