import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';

class DataStoreEventHandler {
  StreamSubscription<DataStoreHubEvent>? _subscription;
  static final DataStoreEventHandler _instance =
      DataStoreEventHandler._internal();

  factory DataStoreEventHandler() => _instance;

  DataStoreEventHandler._internal();

  //? network status
  bool networkStatus = true; // networkStatusEvent.active
  bool get getNetworkStatus => networkStatus;

  //? outbox status
  bool outboxStatus = true; // outboxStatusEvent.isEmpty
  bool get getOutboxStatus => outboxStatus;

  // ? dataStore State
  late DataStoreHubEvent dataStoreState;
  DataStoreHubEvent get getDataStoreState => dataStoreState;

  ///* dataStoreEvent
  final _dataStoreEvent = StreamController<DataStoreHubEvent>.broadcast();

  ///* networkEvent
  final _networkEvent = StreamController<NetworkStatusEvent>.broadcast();

  ///* syncQueriesEvent
  final _syncQueriesEvent =
      StreamController<SyncQueriesStartedEvent>.broadcast();

  ///* modelSyncEvent
  final _modelSyncEvent = StreamController<ModelSyncedEvent>.broadcast();

  ///! outboxMutationEnqueuedEvent
  final _outboxMutationEnqueuedEvent =
      StreamController<OutboxMutationEvent>.broadcast();

  ///! outbox status
  final _outboxStatusEvent = StreamController<OutboxStatusEvent>.broadcast();

  ///! outboxMutation processed
  final _outboxMutationProcessedEvent =
      StreamController<OutboxMutationEvent>.broadcast();

  ///! outboxMutation failed
  final _outboxMutationFailedEvent =
      StreamController<OutboxMutationEvent>.broadcast();

  void initialize() {
    _subscription = Amplify.Hub.listen(
      HubChannel.DataStore,
      (DataStoreHubEvent hubEvent) {
        _dataStoreEvent.add(hubEvent);
        dataStoreState = hubEvent;
        switch (hubEvent.type) {
          case DataStoreHubEventType.networkStatus:
            final networkStatusEvent = hubEvent.payload as NetworkStatusEvent;
            _networkEvent.add(networkStatusEvent);
            networkStatus = networkStatusEvent.active;
            safePrint('Network status changed');
            break;
          case DataStoreHubEventType.subscriptionsEstablished:
            safePrint('**** Subscriptions established ****');
            break;
          case DataStoreHubEventType.syncQueriesStarted:
            final payload = hubEvent.payload as SyncQueriesStartedEvent;
            _syncQueriesEvent.add(payload);
            // final List<String> models = payload.models;
            // print('Sync queries started for models: $models');
            safePrint('Sync queries started');
            break;
          case DataStoreHubEventType.modelSynced:
            final payload = hubEvent.payload as ModelSyncedEvent;
            _modelSyncEvent.add(payload);
            // final String modelName = payload.modelName;
            // final bool isFullSync = payload.isFullSync;
            // final bool isDeltaSync = payload.isDeltaSync;
            // final int modelInstanceAdded = payload.added;
            // print('Model synced: ** $modelName **');
            // print('Is full sync: ** $isFullSync **');
            // print('Is delta sync: ** $isDeltaSync **');
            // print('Model instances added: ** $modelInstanceAdded **');
            safePrint('Model synced');
            break;
          case DataStoreHubEventType.syncQueriesReady:
            safePrint('Sync queries ready');
            break;
          case DataStoreHubEventType.ready:
            safePrint('DataStore is ready');
            break;
          case DataStoreHubEventType.outboxMutationEnqueued:
            final payload = hubEvent.payload as OutboxMutationEvent;
            _outboxMutationEnqueuedEvent.add(payload);
            safePrint('Outbox mutation enqueued');
            break;
          case DataStoreHubEventType.outboxMutationProcessed:
            final payload = hubEvent.payload as OutboxMutationEvent;
            _outboxMutationProcessedEvent.add(payload);
            safePrint('Outbox mutation processed');
            break;
          case DataStoreHubEventType.outboxMutationFailed:
            final payload = hubEvent.payload as OutboxMutationEvent;
            _outboxMutationFailedEvent.add(payload);
            safePrint('Outbox mutation failed');
            break;
          case DataStoreHubEventType.outboxStatus:
            final payload = hubEvent.payload as OutboxStatusEvent;
            _outboxStatusEvent.add(payload);
            outboxStatus = payload.isEmpty;
            safePrint('** Outbox status **');
            break;
          case DataStoreHubEventType.subscriptionDataProcessed:
            safePrint('Subscription data processed');
            break;
        }
      },
    );
  }

  dataStorePlugInError({required AmplifyException e}) {
    _dataStoreEvent.addError(e);
  }

  Stream<NetworkStatusEvent> get networkEvent => _networkEvent.stream;
  Stream<DataStoreHubEvent> get dataStoreEvent => _dataStoreEvent.stream;
  Stream<SyncQueriesStartedEvent> get syncQueriesEvent =>
      _syncQueriesEvent.stream;
  Stream<ModelSyncedEvent> get modelSyncEvent => _modelSyncEvent.stream;
  Stream<OutboxMutationEvent> get outboxMutationEnqueuedEvent =>
      _outboxMutationEnqueuedEvent.stream;
  Stream<OutboxStatusEvent> get outboxStatusEvent => _outboxStatusEvent.stream;
  Stream<OutboxMutationEvent> get outboxMutationProcessedEvent =>
      _outboxMutationProcessedEvent.stream;
  Stream<OutboxMutationEvent> get outboxMutationFailedEvent =>
      _outboxMutationFailedEvent.stream;

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _networkEvent.close();
    _dataStoreEvent.close();
    _syncQueriesEvent.close();
    _modelSyncEvent.close();
    _outboxMutationEnqueuedEvent.close();
    _outboxStatusEvent.close();
    _outboxMutationProcessedEvent.close();
    _outboxMutationFailedEvent.close();
  }
}
