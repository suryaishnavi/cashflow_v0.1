import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'overall_view_event.dart';
part 'overall_view_state.dart';

class OverallViewBloc extends Bloc<OverallViewEvent, OverallViewState> {
  List models = [];
  OverallViewBloc() : super(OverallViewInitial()) {
    // on<DataStoreOutboxStatusEvent>(_onOutboxStatusEvent);
    on<DataStoreOutboxMutationEnqueuedEvent>(_onOutboxMutationEnqueuedEvent);
    on<DataStoreOutboxMutationProcessedEvent>(_onOutboxMutationProcessedEvent);
    on<DataStoreOutboxMutationFailedEvent>(_onOutboxMutationFailedEvent);
    on<OverallViewResetEvent>(_onResetEvent);
  }
  // _onOutboxStatusEvent(
  //   DataStoreOutboxStatusEvent event,
  //   Emitter<OverallViewState> emit,
  // ) {
  //   emit(OutboxStatusState(isEmpty: event.isEmpty));
  // }

  _onOutboxMutationEnqueuedEvent(
    DataStoreOutboxMutationEnqueuedEvent event,
    Emitter<OverallViewState> emit,
  ) {
    /// add the model to the list of models that are being synced
    models.add(event.event.element.model);
    emit(OutboxMutationEnqueuedState(payload: event.event));
  }

  _onOutboxMutationProcessedEvent(
    DataStoreOutboxMutationProcessedEvent event,
    Emitter<OverallViewState> emit,
  ) {
    /// remove the model from the list of models that are being synced
    models.remove(event.event.element.model);
    emit(OutboxMutationProcessedState(payload: event.event));
  }

  _onOutboxMutationFailedEvent(
    DataStoreOutboxMutationFailedEvent event,
    Emitter<OverallViewState> emit,
  ) {
    emit(OutboxMutationFailedState(payload: event.event));
  }

  _onResetEvent(
    OverallViewResetEvent event,
    Emitter<OverallViewState> emit,
  ) {
    emit(OverallViewInitial());
  }
}
