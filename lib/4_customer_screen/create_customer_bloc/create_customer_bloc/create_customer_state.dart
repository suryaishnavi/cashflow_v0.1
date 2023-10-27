part of 'create_customer_bloc.dart';

abstract class CreateCustomerState extends Equatable {
  const CreateCustomerState();

  @override
  List<Object> get props => [];
}

class LoadingCircleCitiesState extends CreateCustomerState {}

class LoadedCircleCitiesState extends CreateCustomerState {
  final List<City> cities;
  final City selectedCity;
  final List<Customer> existingCustomers;
  final String loanIdentity;
  const LoadedCircleCitiesState({
    required this.selectedCity,
    required this.cities,
    this.existingCustomers = const [],
    required this.loanIdentity,
  });

  LoadedCircleCitiesState copyWith({
    List<City>? cities,
    City? selectedCity,
    List<Customer>? existingCustomers,
    String? loanIdentity,
  }) {
    return LoadedCircleCitiesState(
      cities: cities ?? this.cities,
      selectedCity: selectedCity ?? this.selectedCity,
      existingCustomers: existingCustomers ?? this.existingCustomers,
      loanIdentity: loanIdentity ?? this.loanIdentity,
    );
  }

  @override
  List<Object> get props =>
      [cities, existingCustomers, loanIdentity, selectedCity];
}
