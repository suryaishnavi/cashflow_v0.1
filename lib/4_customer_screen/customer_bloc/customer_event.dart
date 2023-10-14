part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomersEvent extends CustomerEvent {
  final List<Customer> customers;

  const LoadCustomersEvent({this.customers = const <Customer>[]});

  @override
  List<Object> get props => [customers];
}

class ShowCustomerProfileEvent extends CustomerEvent {
  final Customer customer;

  const ShowCustomerProfileEvent({required this.customer});

  @override
  List<Object> get props => [customer];
}

class SelectedCityCustomersEvent extends CustomerEvent {
  final City city;

  const SelectedCityCustomersEvent({required this.city});

  @override
  List<Object> get props => [city];
}

class ScrollPositionEvent extends CustomerEvent {
  final double scrollPosition;

  const ScrollPositionEvent({required this.scrollPosition});

  @override
  List<Object> get props => [scrollPosition];
}

class DeleteCustomerEvent extends CustomerEvent {
  final Customer customer;

  const DeleteCustomerEvent({required this.customer});

  @override
  List<Object> get props => [customer];
}
