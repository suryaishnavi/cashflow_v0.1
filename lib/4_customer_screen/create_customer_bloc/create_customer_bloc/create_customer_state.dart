part of 'create_customer_bloc.dart';

abstract class CreateCustomerState extends Equatable {
  const CreateCustomerState();

  @override
  List<Object> get props => [];
}

class LoadingCircleCitiesState extends CreateCustomerState {}

class LoadedCircleCitiesState extends CreateCustomerState {
  final List<City> cities;
  final List<Customer> existingCustomers;
  final String loanIdentity;
  const LoadedCircleCitiesState({
    required this.cities,
    this.existingCustomers = const [],
    required this.loanIdentity,
  });

  LoadedCircleCitiesState copyWith({
    List<City>? cities,
    List<Customer>? existingCustomers,
    String? loanIdentity,
  }) {
    return LoadedCircleCitiesState(
      cities: cities ?? this.cities,
      existingCustomers: existingCustomers ?? this.existingCustomers,
      loanIdentity: loanIdentity ?? this.loanIdentity,
    );
  }

  @override
  List<Object> get props => [cities, existingCustomers, loanIdentity];
}
