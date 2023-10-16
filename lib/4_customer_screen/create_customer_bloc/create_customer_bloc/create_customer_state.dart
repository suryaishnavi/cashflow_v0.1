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
}