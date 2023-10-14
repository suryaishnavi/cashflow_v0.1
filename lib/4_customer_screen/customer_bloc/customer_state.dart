part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

// class CustomerInitial extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final List<Customer> customers;
  final List<Customer> filteredCustomers;
  final List<City> cities;
  final City selectedCity;
  final double scrollPosition;

  const CustomerLoadedState({
    required this.filteredCustomers,
    required this.selectedCity,
    required this.cities,
    required this.scrollPosition,
    required this.customers,
  });

  @override
  List<Object> get props => [
        customers,
        cities,
        selectedCity,
        filteredCustomers,
        scrollPosition,
      ];
}

class CustomerErrorState extends CustomerState {
  final Exception error;

  const CustomerErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class CustomerEmptyState extends CustomerState {}

class CustomerProfileState extends CustomerState {
  final Customer customer;

  const CustomerProfileState({required this.customer});

  @override
  List<Object> get props => [customer];
}
