import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../session_cubit/session_cubit.dart';
import '../../3_circle_screen/circles_bloc/circle_bloc.dart';
import 'cubit/sync_data_cubit.dart';

class SyncData extends StatelessWidget {
  const SyncData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncDataCubit>(
      create: (context) => SyncDataCubit(),
      child: const SyncDataScreen(),
    );
  }
}

class SyncDataScreen extends StatelessWidget {
  const SyncDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SessionCubit, SessionState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  BlocProvider.of<CircleBloc>(context).add(
                    LoadCirclesEvent(appUser: state.user),
                  );
                  GoRouter.of(context).go('/overallview');
                }
              },
            ),
            BlocListener<SyncDataCubit, SyncDataState>(
              listener: (context, state) {
                if (state is NetworkStatus) {
                  showSnackBar(
                    context: context,
                    message: state.isOnline
                        ? AppLocalizations.of(context)!.connected
                        : AppLocalizations.of(context)!.noInternet,
                    color: state.isOnline ? Colors.green : Colors.red,
                  );
                }
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.gettingData,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 10),
              Center(
                child: BlocBuilder<SyncDataCubit, SyncDataState>(
                  builder: (context, state) {
                    if (state is SyncDataStarted) {
                      return Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    } else if (state is SyncDataSuccess) {
                      return Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    } else if (state is NetworkStatus) {
                      return Text(
                        state.isOnline
                            ? AppLocalizations.of(context)!.connected
                            : AppLocalizations.of(context)!.noInternet,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    } else if (state is TotalPersentCompleted) {
                      return Text(
                        'Data Synchronized: ${state.percent}%',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900]),
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text(
                      AppLocalizations.of(context)!.wait,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
    Widget? child,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            child ?? const SizedBox.shrink(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
