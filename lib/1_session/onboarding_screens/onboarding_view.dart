import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../l10n/l10n.dart';
import '../session_cubit/session_cubit.dart';
import 'language_bloc/language_bloc.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
int _value = 0;

  void onLanguageSelection({required int index, required bool selected}) {
    setState(() {
      _value = index;
    });
    BlocProvider.of<LanguageBloc>(context).add(
      ChangeLanguageEvent(
        value: index,
        selectedLanguage: Language.values[index],
      ),
    );
  }

  // ignore: invalid_use_of_internal_member
  final storage = AmplifySecureStorage(
    config: AmplifySecureStorageConfig(
      scope: 'userDetails',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final items = {'english': 'English', 'telugu': 'తెలుగు', 'hindi': 'हिंदी'};

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.welcomeScreen('welcome'),
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.welcomeScreen('appSubtitle'),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Text(
                AppLocalizations.of(context)!.welcomeScreen('language'),
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: List<Widget>.generate(
                  2,
                  (int index) {
                    return ChoiceChip(
                      autofocus: true,
                      elevation: 2.0,
                      label: Text(items.values.elementAt(index)),
                      labelPadding: const EdgeInsets.all(8.0),
                      labelStyle: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      selected:
                          BlocProvider.of<LanguageBloc>(context).state.value ==
                              index,
                      onSelected: (bool selected) {
                        onLanguageSelection(index: index, selected: selected);
                      },
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 32),
              !loading
                  ? ElevatedButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        if(_value == 0){
                              storage.write(
                            key: 'isLanguageSelected',
                            value: 'en',
                          );
                        }
                        BlocProvider.of<SessionCubit>(context)
                            .attemptAutoLogin();
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;
}
