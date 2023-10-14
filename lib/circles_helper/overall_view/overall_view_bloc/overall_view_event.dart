part of 'overall_view_bloc.dart';

sealed class OverallViewEvent extends Equatable {
  const OverallViewEvent();

  @override
  List<Object> get props => [];
}

///* outboxStatus event
// class DataStoreOutboxStatusEvent extends OverallViewEvent {
//   final bool isEmpty;

//   const DataStoreOutboxStatusEvent({required this.isEmpty});

//   @override
//   List<Object> get props => [isEmpty];
// }

///* outboxMutationEnqueuedEvent
class DataStoreOutboxMutationEnqueuedEvent extends OverallViewEvent {
  final OutboxMutationEvent event;

  const DataStoreOutboxMutationEnqueuedEvent({required this.event});

  @override
  List<Object> get props => [event];
}

///* syncQueries event
class DataStoreOutboxMutationProcessedEvent extends OverallViewEvent {
  final OutboxMutationEvent event;

  const DataStoreOutboxMutationProcessedEvent({required this.event});

  @override
  List<Object> get props => [event];
}

///* syncQueries failed event
class DataStoreOutboxMutationFailedEvent extends OverallViewEvent {
  final OutboxMutationEvent event;

  const DataStoreOutboxMutationFailedEvent({required this.event});

  @override
  List<Object> get props => [event];
}

///* overallView bloc reset event
class OverallViewResetEvent extends OverallViewEvent {
  const OverallViewResetEvent();

  @override
  List<Object> get props => [];
}
