part of 'overall_view_bloc.dart';

sealed class OverallViewState extends Equatable {
  const OverallViewState();

  @override
  List<Object> get props => [];
}

final class OverallViewInitial extends OverallViewState {}

/// outboxMutationEnqueuedState
/// outboxStatus state
// final class OutboxStatusState extends OverallViewState {
//   final bool isEmpty;

//   const OutboxStatusState({required this.isEmpty});

//   @override
//   List<Object> get props => [isEmpty];
// }
final class OutboxMutationEnqueuedState extends OverallViewState {
  final OutboxMutationEvent payload;

  const OutboxMutationEnqueuedState({required this.payload});

  @override
  List<Object> get props => [payload];
}

/// syncQueries state
final class OutboxMutationProcessedState extends OverallViewState {
  final OutboxMutationEvent payload;

  const OutboxMutationProcessedState({required this.payload});

  @override
  List<Object> get props => [payload];
}

/// syncQueries failed state
final class OutboxMutationFailedState extends OverallViewState {
  final OutboxMutationEvent payload;

  const OutboxMutationFailedState({required this.payload});

  @override
  List<Object> get props => [payload];
}
