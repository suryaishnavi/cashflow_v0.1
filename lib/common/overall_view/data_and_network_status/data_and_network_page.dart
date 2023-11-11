import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../0_repositories/amplify_hub_events/data_store_event_handler.dart';
import 'data_and_network_bloc/data_and_network_status_bloc.dart';

///! DataAndNetworkPageBlocProvider
class DataAndNetworkPage extends StatelessWidget {
  const DataAndNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataAndNetworkStatusBloc(
        dataStoreEventHandler: context.read<DataStoreEventHandler>(),
      ),
      child: const DataAndNetworkStatus(),
    );
  }
}

///! OutboxStatusView & NetworkStatusView
class DataAndNetworkStatus extends StatelessWidget {
  const DataAndNetworkStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataAndNetworkStatusBloc, DataAndNetworkStatusState>(
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
