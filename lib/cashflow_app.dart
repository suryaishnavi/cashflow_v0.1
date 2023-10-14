import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '1_session/onboarding_screens/language_bloc/language_bloc.dart';
import 'config/routes/app_router.dart';
import 'config/theme/theme.dart';

class CashflowApp extends StatelessWidget {
  const CashflowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: context.watch<LanguageBloc>().state.selectedLanguage.value,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'cashflow',
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: theme,
      restorationScopeId: 'app',
      routerConfig: AppRouter().router,
    );
  }
}
