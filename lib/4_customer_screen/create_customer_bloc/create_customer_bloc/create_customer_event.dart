part of 'create_customer_bloc.dart';

abstract class CreateCustomerEvent extends Equatable {
  const CreateCustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCitiesEvent extends CreateCustomerEvent {}
