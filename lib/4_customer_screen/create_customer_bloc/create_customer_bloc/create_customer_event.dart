part of 'create_customer_bloc.dart';

abstract class CreateCustomerEvent extends Equatable {
  const CreateCustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCitiesEvent extends CreateCustomerEvent {}

class LoanIdentityChangingEvent extends CreateCustomerEvent {
  final String loanIdentity;
  const LoanIdentityChangingEvent({required this.loanIdentity});
}

class CityChangingEvent extends CreateCustomerEvent {
  final City city;
  const CityChangingEvent({required this.city});
}
