part of 'customer_profile_cubit.dart';

abstract class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object> get props => [];
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoadedState extends CustomerProfileState {
  final String name;
  final String phone;
  final String address;

  const CustomerProfileLoadedState({
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object> get props => [name, phone, address];
}
 class CustomerProfileError extends CustomerProfileState {
  final Exception message;

  const CustomerProfileError({required this.message});

  @override
  List<Object> get props => [message];
 }