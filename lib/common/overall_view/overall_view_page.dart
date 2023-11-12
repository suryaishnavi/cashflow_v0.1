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
import 'cashflow_lifecycle_bloc/cashflow_lifecycle_bloc.dart';
import 'data_sync_status_page.dart';
import 'overall_view_bloc/overall_view_bloc.dart';

class OverallViewPage extends StatelessWidget {
  const OverallViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverallViewBloc(),
      child: const OverAllView(),
    );
  }
}

class OverAllView extends StatelessWidget {
  const OverAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<OverallViewBloc, OverallViewState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
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

  late StreamSubscription<SyncQueriesStartedEvent> _syncQueriesStartedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationEnqueuedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationProcessedEvent;
  late StreamSubscription<OutboxMutationEvent> _outboxMutationFaildEvent;
  late StreamSubscription<AppLifecycleState> _appLifecycleStateEvent;

  // TestCustomers testCustomers = TestCustomers();
  @override
  void initState() {
    super.initState();


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
      } else if (context.watch<OverallViewBloc>().state
          is OutboxMutationFailedState) {
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
        return const DataSyncStatusPage();
      },
    );
  }
}
