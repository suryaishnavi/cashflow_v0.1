part of 'status_bloc.dart';

class DataAndNetworkStatusState extends Equatable {
  const DataAndNetworkStatusState({
    required this.networkStatus,
    required this.isAllDataBackup,
  });

  final bool networkStatus;
  final bool isAllDataBackup;

  DataAndNetworkStatusState copyWith({
    bool? networkStatus,
    bool? isAllDataBackup,
  }) {
    return DataAndNetworkStatusState(
      networkStatus: networkStatus ?? this.networkStatus,
      isAllDataBackup: isAllDataBackup ?? this.isAllDataBackup,
    );
  }

  @override
  List<Object> get props => [networkStatus, isAllDataBackup];
}
