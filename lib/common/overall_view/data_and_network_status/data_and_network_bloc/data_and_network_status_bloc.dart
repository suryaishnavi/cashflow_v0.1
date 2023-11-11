import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../0_repositories/amplify_hub_events/data_store_event_handler.dart';


part 'data_and_network_status_event.dart';
part 'data_and_network_status_state.dart';

class DataAndNetworkStatusBloc
    extends Bloc<DataAndNetworkStatusEvent, DataAndNetworkStatusState> {
  final DataStoreEventHandler dataStoreEventHandler;
  DataAndNetworkStatusBloc({required this.dataStoreEventHandler})
      : super(DataAndNetworkStatusState(
          networkStatus: dataStoreEventHandler.networkStatus,
          isAllDataBackup: dataStoreEventHandler.outboxStatus,
        )) {
    on<NetworkStatusChangeEvent>(_onNetworkStatusChangeEvent);
    on<BackupStatusChangeEvent>(_onBackupStatusChangeEvent);
  }

  _onNetworkStatusChangeEvent(
    NetworkStatusChangeEvent event,
    Emitter<DataAndNetworkStatusState> emit,
  ) {
    emit(state.copyWith(networkStatus: event.networkStatus));
  }

  _onBackupStatusChangeEvent(
    BackupStatusChangeEvent event,
    Emitter<DataAndNetworkStatusState> emit,
  ) {
    emit(state.copyWith(isAllDataBackup: event.isAllDataBackup));
  }
}
