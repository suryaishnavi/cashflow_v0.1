part of 'cashflow_lifecycle_bloc.dart';

sealed class CashflowLifecycleEvent extends Equatable {
  const CashflowLifecycleEvent();

  @override
  List<Object> get props => [];
}

class NewAppLifecycleEvent extends CashflowLifecycleEvent {
  final AppLifecycleState appLifecycleState;

  const NewAppLifecycleEvent({required this.appLifecycleState});

  @override
  List<Object> get props => [appLifecycleState];
}
