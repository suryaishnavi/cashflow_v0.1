part of 'sync_data_cubit.dart';

sealed class SyncDataState extends Equatable {
  const SyncDataState();

  @override
  List<Object> get props => [];
}

final class SyncDataInitial extends SyncDataState {}

final class SyncDataStarted extends SyncDataState {
  final String message;
  const SyncDataStarted(this.message);
}

final class SyncDataSuccess extends SyncDataState {
  final String message;
  const SyncDataSuccess(this.message);
}

final class NetworkStatus extends SyncDataState {
  final bool isOnline;

  const NetworkStatus(this.isOnline);

  @override
  List<Object> get props => [isOnline];
}

final class SyncDataFailure extends SyncDataState {
  final String message;

  const SyncDataFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class TotalPersentCompleted extends SyncDataState {
  final int percent;

  const TotalPersentCompleted(this.percent);

  @override
  List<Object> get props => [percent];
}
