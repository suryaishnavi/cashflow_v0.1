import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'data_and_network_status/data_and_network_page.dart';
import 'overall_view_bloc/overall_view_bloc.dart';

class DataSyncStatusPage extends StatelessWidget {
  const DataSyncStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverallViewBloc(),
      child: const DataSyncStatusView(),
    );
  }
}

class DataSyncStatusView extends StatelessWidget {
  const DataSyncStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomModelHeading(),
          SizedBox(height: 16),
          DataAndNetworkPage(),
          OutboxStatusHubEvents(),
        ],
      ),
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
              return OutboxMutationEnqueuedPage(state: state);
            case OutboxMutationProcessedState():
              return OutboxMutationProcessedPage(state: state);
            case OutboxMutationFailedState():
              return OutboxMutationFailedPage(state: state);
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
  final OutboxMutationEnqueuedState state;
  const OutboxMutationEnqueuedPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              const Text(
                'Data is waiting to sync at Outbox Mutation enqueued',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text('payload: ${state.models}'),
        ],
      ),
    );
  }
}

///! OutboxMutationProcessedPage
class OutboxMutationProcessedPage extends StatelessWidget {
  final OutboxMutationProcessedState state;
  const OutboxMutationProcessedPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: state.models.isEmpty
            ? const Row(
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
              )
            : Text('${state.models}'),
      ),
    );
  }
}

///! OutboxMutationFailedPage
class OutboxMutationFailedPage extends StatelessWidget {
  final OutboxMutationFailedState state;
  const OutboxMutationFailedPage({super.key, required this.state});

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
          Text('payload: ${state.payload}'),
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
