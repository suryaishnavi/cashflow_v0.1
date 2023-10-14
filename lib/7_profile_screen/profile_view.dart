import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import '../0_repositories/amplify_hub_events/data_store_event_handler.dart';
import '../1_session/onboarding_screens/language_bloc/language_bloc.dart';
import '../1_session/session_cubit/session_cubit.dart';
import '../config/routes/route_constants.dart';
import '../l10n/l10n.dart';
import '../widgets/elevated_tonal_button.dart';
import '../widgets/page_heading.dart';
import '../widgets/tonal_filled_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocConsumer<SessionCubit, SessionState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              GoRouter.of(context).go(RouteConstants.auth);
            }
          },
          builder: (context, state) {
            if (state is Authenticated) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ProfileDetails(state: state),
                    const Divider(),
                    const SizedBox(height: 8),
                    SubscriptionDetails(state: state),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    const AppSettings(),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}

//! profile details
class ProfileDetails extends StatefulWidget {
  final dynamic state;
  const ProfileDetails({super.key, required this.state});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  DataStoreEventHandler dataStoreEventHandler = DataStoreEventHandler();

  Future<bool> networkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return true;
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return true;
      // I am connected to a bluetooth.
    } else if (connectivityResult == ConnectivityResult.other) {
      return true;
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
      // I am not connected to any network.
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _heading(context),
        ListTile(
          trailing: CircleAvatar(
            radius: 25,
            child: Icon(Icons.person, size: 30, color: Colors.blue[900]),
          ),
          title: Text(
            widget.state.user.name.length > 20
                ? '${widget.state.user.name[0].toUpperCase() + widget.state.user.name.substring(1, 20)}...'
                : widget.state.user.name[0].toUpperCase() +
                    widget.state.user.name.substring(1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: RichText(
            text: TextSpan(
              text:
                  '${widget.state.user.phoneNumber.substring(0, 3)}-${widget.state.user.phoneNumber.substring(3, 13)}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text:
                      '\n${widget.state.user.emailId.length > 20 ? '${widget.state.user.emailId.substring(0, 20)}...' : widget.state.user.emailId}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _heading(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageHeading(heading: AppLocalizations.of(context)!.profile('name2')),
          // ! Sign Out Button
          TonalFilledButton(
              onPressed: () async {
                 if (await networkStatus() && DataStoreEventHandler().getOutboxStatus) {
                  BlocProvider.of<SessionCubit>(context).signOut();
                  showSnackBar(
                    context: context,
                    message: AppLocalizations.of(context)!.signout,
                    color: Colors.green,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  showSnackBar(
                    context: context,
                    message: AppLocalizations.of(context)!.noInternet,
                    color: Colors.red,
                  );
                }
              },
              text: AppLocalizations.of(context)!.signout,
              icon: const Icon(Icons.logout, size: 20)),
        ],
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

//! subscription details
class SubscriptionDetails extends StatelessWidget {
  final dynamic state;
  const SubscriptionDetails({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(heading: AppLocalizations.of(context)!.subscription),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: '\t\t ${AppLocalizations.of(context)!.status}: ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: (state.user.appUserSubscriptionDetails.subscribed)
                        ? 'Paid'
                        : 'Free',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: '\t\t ${AppLocalizations.of(context)!.endDate}: ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: intl.DateFormat.yMMMMd().format(
                      state.user.appUserSubscriptionDetails.endDate
                          .getDateTime(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            (state.user.appUserSubscriptionDetails.subscribed)
                ? const SizedBox.shrink()
                : ElevatedTonalButton(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[50]),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.green[800]),
                    shadowColor: MaterialStateProperty.all(Colors.green[400]),
                    onPressed: () {
                      _showSnackBar(context, 'working on it...');
                    },
                    text: AppLocalizations.of(context)!.upgrade,
                    icon: const Icon(Icons.upgrade),
                  ),
          ],
        ),
      ],
    );
  }

  void _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ! App Settings

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(heading: AppLocalizations.of(context)!.settings),
        const SizedBox(height: 16),
        const LanguageDropDown(),
      ],
    );
  }
}

class LanguageDropDown extends StatefulWidget {
  const LanguageDropDown({super.key});

  @override
  State<LanguageDropDown> createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<Language>> languageEntities =
        <DropdownMenuEntry<Language>>[];

    for (final Language language in Language.values) {
      languageEntities.add(
        DropdownMenuEntry<Language>(
          value: language,
          label: language.label,
        ),
      );
    }
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return DropdownMenu<Language>(
          label: Text(AppLocalizations.of(context)!.language),
          initialSelection: Language.english,
          dropdownMenuEntries: languageEntities,
          onSelected: (Language? language) {
            BlocProvider.of<LanguageBloc>(context).add(
              ChangeLanguageEvent(selectedLanguage: language!),
            );
          },
        );
      },
    );
  }
}
