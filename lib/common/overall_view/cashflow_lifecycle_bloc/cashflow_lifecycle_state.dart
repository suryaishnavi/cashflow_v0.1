part of 'cashflow_lifecycle_bloc.dart';

sealed class CashflowLifecycleState extends Equatable {
  const CashflowLifecycleState();

  @override
  List<Object> get props => [];
}

final class CashflowLifecycleInitial extends CashflowLifecycleState {}

final class CashflowLifecycleChangeState extends CashflowLifecycleState {
  final List<AppLifecycleState> appLifecycleState;

  const CashflowLifecycleChangeState({required this.appLifecycleState});

  @override
  List<Object> get props => [appLifecycleState];
}
