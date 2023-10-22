import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../0_repositories/amplify_hub_events/data_store_event_handler.dart';
import '../../0_repositories/flutter_lifecycle_changes/app_lifecycle_states.dart';
import '../../1_session/session_cubit/session_cubit.dart';
import '../../3_circle_screen/circle_view.dart';
import '../../6_reports_gen_screen/report_view.dart';
import '../../7_profile_screen/profile_view.dart';
// import '../../creatingTestCustomer/test_customers.dart';
import 'amplify_exceptions/amplify_exceptions_bloc.dart';
import 'cashflow_lifecycle_bloc/cashflow_lifecycle_bloc.dart';
import 'data_and_network_status_bloc/status_bloc.dart';
import 'overall_view_bloc/overall_view_bloc.dart';

class OverallView extends StatelessWidget {
  const OverallView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<OverallViewBloc, OverallViewState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              // flexibleSpace: Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         Colors.blueAccent.shade400,
              //         Colors.blueAccent.shade700,
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //   ),
              // ),
              backgroundColor: Colors.lightBlueAccent.shade700,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [UserName(), AppNotification()],
              ),
              bottom: TabBar(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                overlayColor: MaterialStateProperty.all(Colors.white12),
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        const Icon(Icons.supervised_user_circle),
                        const SizedBox(width: 5),
                        Text(AppLocalizations.of(context)!.circle),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long),
                        const SizedBox(width: 5),
                        Text(AppLocalizations.of(context)!.reports),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5),
                        Text(AppLocalizations.of(context)!.profile('name')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: const Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      CircleView(),
                      ReportView(),
                      ProfileView(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final userName = AppLocalizations.of(context)!.greet(state.user.name);
          return Text(
            userName.length > 25
                ? '${userName[0].toUpperCase()}${userName.substring(1, 25)}...'
                : '${userName[0].toUpperCase()}${userName.substring(1)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.wait,
        );
      },
    );
  }
}

///! AppNotification
class AppNotification extends StatefulWidget {
  const AppNotification({super.key});

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> {
  late StreamSubscription<DataStoreHubEvent> _dataStoreEvent;
  late StreamSubscription<NetworkStatusEvent> _networkStatusEvent;
  late StreamSubscription<OutboxStatusEvent> _outboxStatusEvent;
  late StreamSubscription<SyncQueriesStartedEvent> _syncQueriesStartedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationEnqueuedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationProcessedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationFaildEvent;
  late StreamSubscription<AppLifecycleState> _appLifecycleStateEvent;

  // TestCustomers testCustomers = TestCustomers();
  @override
  void initState() {
    super.initState();

    //! AmplifyPluginEvent
    _dataStoreEvent = DataStoreEventHandler().dataStoreEvent.handleError((e) {
      context
          .read<AmplifyExceptionsBloc>()
          .add(AmplifyPlugInExceptionsEvent(error: e));
    }).listen((event) {});

    //* networkStatusEvent
    _networkStatusEvent = DataStoreEventHandler().networkEvent.listen((event) {
      context.read<StatusBloc>().add(NetworkStatusChangeEvent(event.active));
    });

    //* outboxStatusEvent
    _outboxStatusEvent =
        DataStoreEventHandler().outboxStatusEvent.listen((event) {
      context.read<StatusBloc>().add(BackupStatusChangeEvent(event.isEmpty));
    });

    /// syncQueriesStartedEvent
    _syncQueriesStartedEvent =
        DataStoreEventHandler().syncQueriesEvent.listen((event) {});

    ///! outboxMutationEnqueuedEvent
    _outboxMutationEnqueuedEvent =
        DataStoreEventHandler().outboxMutationEnqueuedEvent.listen((event) {
      context
          .read<OverallViewBloc>()
          .add(DataStoreOutboxMutationEnqueuedEvent(event: event));
      // print('###outboxMutationEnqueuedEvent###');
      // print('event: $event');
      // print('event.modelName: ${event.modelName}');
      // print('event.eventType: ${event.element.model}');
    });

    /// outboxMutation processed event
    _outboxMutationProcessedEvent =
        DataStoreEventHandler().outboxMutationProcessedEvent.listen((event) {
      context
          .read<OverallViewBloc>()
          .add(DataStoreOutboxMutationProcessedEvent(event: event));
      // print('###outboxMutation processed event###');
      // print('event: $event');
      // print('event.modelName: ${event.modelName}');
      // print('event.eventType: ${event.element.model}');
    });

    /// outboxMutation failed event
    _outboxMutationFaildEvent =
        DataStoreEventHandler().outboxMutationFailedEvent.listen((event) {
      context
          .read<OverallViewBloc>()
          .add(DataStoreOutboxMutationFailedEvent(event: event));
      // print('###outboxMutation failed event###');
      // print('event: $event');
      // print('event.modelName: ${event.modelName}');
      // print('event.model: ${event.element.model}');
    });
    _appLifecycleStateEvent = AppLifecycleStates().appLifeCycleEvents.listen(
      (event) {
        context
            .read<CashflowLifecycleBloc>()
            .add(NewAppLifecycleEvent(appLifecycleState: event));
        // print('***###appLifecycleStateEvent: $event ###***');
      },
    );
  }

  @override
  void dispose() {
    _dataStoreEvent.cancel();
    _networkStatusEvent.cancel();
    _outboxStatusEvent.cancel();
    _syncQueriesStartedEvent.cancel();
    _outboxMutationEnqueuedEvent.cancel();
    _outboxMutationProcessedEvent.cancel();
    _outboxMutationFaildEvent.cancel();
    _appLifecycleStateEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (context.watch<OverallViewBloc>().state
          is OutboxMutationProcessedState) {
        return Colors.green;
      } else if (context.watch<AmplifyExceptionsBloc>().state
          is AmplifyPlugInExceptionsState) {
        return Colors.red;
      } else if (context.watch<OverallViewBloc>().state
          is OutboxMutationEnqueuedState) {
        return Colors.orange;
      }
      return Colors.white70;
    }

    bool isLableVisible() {
      if (context.watch<OverallViewBloc>().state is OverallViewInitial) {
        return false;
      }
      return true;
    }

    return Badge(
      isLabelVisible: isLableVisible(),
      backgroundColor: getColor(),
      offset: const Offset(-10, 12),
      label: const Text('1'),
      child: IconButton(
        padding: const EdgeInsets.all(16),
        onPressed: () async {
          _showModalBottomSheet(context);
          // await Amplify.DataStore.start();
          // await testCustomers.runTestCustomers();
          // await testCustomers.createTestCities();
        },
        icon: const Icon(Icons.notifications),
        color: Colors.white70,
      ),
    );
  }

  // show modal bottom sheet
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      // isDismissible: false,
      enableDrag: false,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomModelHeading(),
              AmplifyPluginErrorPage(),
              SizedBox(height: 16),
              StatusPage(),
              OutboxStatusHubEvents(),
            ],
          ),
        );
      },
    );
  }
}

///! OutboxStatusPage & NetworkStatusPage
class StatusPage extends StatelessWidget {
  const StatusPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusBloc, DataAndNetworkStatusState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.down,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Network Status',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        state.networkStatus ? Icons.wifi : Icons.wifi_off,
                        color: state.networkStatus ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.networkStatus ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color:
                              state.networkStatus ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.down,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Backup Status',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        state.isAllDataBackup
                            ? Icons.cloud_done
                            : Icons.cloud_sync,
                        color: state.isAllDataBackup
                            ? Colors.green
                            : Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isAllDataBackup
                            ? 'Data is up-to-date'
                            : 'Waiting to sync',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: state.isAllDataBackup
                              ? Colors.green
                              : Colors.orange,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ! Listening to OutboxStatus on DataStoreHubEvents
class OutboxStatusHubEvents extends StatelessWidget {
  const OutboxStatusHubEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: BlocBuilder<OverallViewBloc, OverallViewState>(
        builder: (context, state) {
          switch (state) {
            case OverallViewInitial():
              return const OverallViewInitialState();
            case OutboxMutationEnqueuedState():
              return const OutboxMutationEnqueuedPage();
            case OutboxMutationProcessedState():
              return const OutboxMutationProcessedPage();
            case OutboxMutationFailedState():
              return OutboxMutationFailedPage(payload: state.payload);
            default: // OverallViewInitial
              return const OverallViewInitialState();
          }
        },
      ),
    );
  }
}

///! OutboxMutationEnqueuedPage
class OutboxMutationEnqueuedPage extends StatelessWidget {
  const OutboxMutationEnqueuedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverallViewBloc, OverallViewState>(
      builder: (context, state) {
        if (state is OutboxMutationEnqueuedState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, color: Colors.orange)),
                    const SizedBox(width: 10),
                    const Text(
                      'Waiting for syncing data to the cloud',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text('payload: ${state.payload.element.model}'),
              ],
            ),
          );
        }
        return const Text('OutboxMutationEnqueuedPage');
      },
    );
  }
}

///! OutboxMutationProcessedPage
class OutboxMutationProcessedPage extends StatelessWidget {
  const OutboxMutationProcessedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text(
            'All changes are synced to the cloud',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

///! OutboxMutationFailedPage
class OutboxMutationFailedPage extends StatelessWidget {
  final OutboxMutationEvent payload;
  const OutboxMutationFailedPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 10),
          const Text(
            'Failed to sync data to the cloud',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text('payload: ${payload.element.model}'),
        ],
      ),
    );
  }
}

///! OverallViewInitialState
class OverallViewInitialState extends StatelessWidget {
  const OverallViewInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 10),
          Text(
            'App is running smoothly',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

///! ShowAppLifeCycles
// class ShowAppLifeCycles extends StatelessWidget {
//   const ShowAppLifeCycles({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // add appLifeCycleStates to list and show it in a listview
//     return BlocBuilder<CashflowLifecycleBloc, CashflowLifecycleState>(
//       builder: (context, state) {
//         if (state is CashflowLifecycleChangeState) {
//           return SingleChildScrollView(
//             child: Text('${state.appLifecycleState}'),
//           );
//         }
//         return const Text('ShowAppLifeCycles');
//       },
//     );
//   }
// }

///! DataStorePluginErrorState
class AmplifyPluginErrorPage extends StatelessWidget {
  const AmplifyPluginErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmplifyExceptionsBloc, AmplifyExceptionsState>(
      builder: (context, state) {
        if (state is AmplifyPlugInExceptionsState) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(state.error.toString(),
                style: const TextStyle(color: Colors.red, fontSize: 16)),
          );
        }
        return const Text(
            'Your app is running smoothly'); // AmplifyPluginErrorPage
      },
    );
  }
}

/// ! Heading
class BottomModelHeading extends StatelessWidget {
  const BottomModelHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sync Status',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        // IconButton(
        //     onPressed: () async {
        //       await Amplify.API.reset();
        //       await Future.delayed(const Duration(seconds: 1));
        //       await Amplify.DataStore.start();
        //     },
        //     icon: const Icon(Icons.refresh)),
        IconButton(
            padding: const EdgeInsets.all(16),
            onPressed:
                context.watch<OverallViewBloc>().state is OverallViewInitial
                    ? null
                    : () => context
                        .read<OverallViewBloc>()
                        .add(const OverallViewResetEvent()),
            icon: const Icon(Icons.clear_all)),
      ],
    );
  }
}
