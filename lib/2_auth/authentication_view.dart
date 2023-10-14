import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'signin/signin_view.dart';
import 'signup/signup_view.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              TabBar(
                onTap: (value) {},
                tabs: [
                  Tab(
                      icon: const Icon(Icons.login),
                      text: AppLocalizations.of(context)!.signin),
                  Tab(
                      icon: const Icon(Icons.person),
                      text: AppLocalizations.of(context)!.create),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    SigninView(),
                    SignupView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
