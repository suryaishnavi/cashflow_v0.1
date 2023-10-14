import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../4_customer_screen/loan_creation_bloc/create_loan_view.dart';

class CreateLoanTabView extends StatelessWidget {
  const CreateLoanTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createLoan('name')),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: AppLocalizations.of(context)!.createLoan('new')),
              Tab(text: AppLocalizations.of(context)!.createLoan('old')),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            CreateLoanView(
              isAdditionalLoan: true,
              isNewLoan: true,
            ),
            CreateLoanView(
              isAdditionalLoan: true,
              isNewLoan: false,
            ),
          ],
        ),
      ),
    );
  }
}
