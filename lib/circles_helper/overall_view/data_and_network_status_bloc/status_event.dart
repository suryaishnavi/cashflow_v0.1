part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class NetworkStatusChangeEvent extends StatusEvent {
  const NetworkStatusChangeEvent(this.networkStatus);

  final bool networkStatus;

  @override
  List<Object> get props => [networkStatus];
}

class BackupStatusChangeEvent extends StatusEvent {
  const BackupStatusChangeEvent(this.isAllDataBackup);

  final bool isAllDataBackup;

  @override
  List<Object> get props => [isAllDataBackup];
}
