import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/amplify_hub_events/data_store_event_handler.dart';

part 'sync_data_state.dart';

class SyncDataCubit extends Cubit<SyncDataState> {
  late StreamSubscription<NetworkStatusEvent> network;
  late StreamSubscription<DataStoreHubEvent> dataStore;
  late StreamSubscription<SyncQueriesStartedEvent> syncQueries;
  late StreamSubscription<ModelSyncedEvent> modelSync;
  int totalModels = 0;
  int currentModel = 0;
  static const int percentage = 100;
  SyncDataCubit() : super(SyncDataInitial()) {
    network = DataStoreEventHandler().networkEvent.listen((event) {
      syncData(event);
    });
    dataStore = DataStoreEventHandler().dataStoreEvent.listen((event) {
      if (event.type == DataStoreHubEventType.subscriptionsEstablished) {
        emit(const SyncDataStarted(
            'Syncing data, please wait this may take a few minutes...'));
      } else if (event.type == DataStoreHubEventType.syncQueriesReady) {
        emit(const SyncDataSuccess(
            'Syncing data completed successfully, you can now use the app'));
      } else if (event.type == DataStoreHubEventType.ready) {
        currentModel = 0;
        totalModels = 0;
      }
    });
    syncQueries = DataStoreEventHandler().syncQueriesEvent.listen((event) {
      totalModels = event.models.length;
      emit(const TotalPersentCompleted(0));
    });
    modelSync = DataStoreEventHandler().modelSyncEvent.listen((event) {
      modelSyncEvent(event);
    });
  }

  void modelSyncEvent(event) {
    currentModel++;
    final percent = (currentModel * percentage) / totalModels;
    emit(TotalPersentCompleted(percent.toInt()));
  }

  void syncData(event) async {
    if (event.active) {
      emit(NetworkStatus(event.active));
    } else {
      emit(NetworkStatus(event.active));
    }
  }

  void dispose() {
    network.cancel();
    dataStore.cancel();
    syncQueries.cancel();
    modelSync.cancel();
    super.close();
  }
}
