import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'cashflow_lifecycle_event.dart';
part 'cashflow_lifecycle_state.dart';

class CashflowLifecycleBloc
    extends Bloc<CashflowLifecycleEvent, CashflowLifecycleState> {
  List<AppLifecycleState> appLifecycleStateList = [];
  CashflowLifecycleBloc() : super(CashflowLifecycleInitial()) {
    on<NewAppLifecycleEvent>((event, emit) {
      appLifecycleStateList.add(event.appLifecycleState);
      emit(
        CashflowLifecycleChangeState(appLifecycleState: appLifecycleStateList),
      );
    });
  }
}
