part of 'data_and_network_status_bloc.dart';

sealed class DataAndNetworkStatusEvent extends Equatable {
  const DataAndNetworkStatusEvent();

  @override
  List<Object> get props => [];
}

class NetworkStatusChangeEvent extends DataAndNetworkStatusEvent {
  const NetworkStatusChangeEvent(this.networkStatus);

  final bool networkStatus;

  @override
  List<Object> get props => [networkStatus];
}

class BackupStatusChangeEvent extends DataAndNetworkStatusEvent {
  const BackupStatusChangeEvent(this.isAllDataBackup);

  final bool isAllDataBackup;

  @override
  List<Object> get props => [isAllDataBackup];
}
