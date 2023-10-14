part of 'emi_cubit.dart';

abstract class EmiState extends Equatable {
  const EmiState();

  @override
  List<Object> get props => [];
}

class EmiLoading extends EmiState {}

class EmiLoaded extends EmiState {
  final List<Emi> emiList;

  const EmiLoaded({required this.emiList});

  @override
  List<Object> get props => [emiList];
}

class EmiError extends EmiState {
  final Exception message;

  const EmiError(this.message);

  @override
  List<Object> get props => [message];
}