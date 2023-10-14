import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'create_customer_bloc/create_customer_view.dart';

class CreateNewCustomerTabView extends StatelessWidget {
  const CreateNewCustomerTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createCustomer('name')),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.createCustomer('new')),
              Tab(text: AppLocalizations.of(context)!.createCustomer('old')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CreateCustomerView(isNewLoan: true),
            CreateCustomerView(isNewLoan: false),
          ],
        ),
      ),
    );
  }
}
