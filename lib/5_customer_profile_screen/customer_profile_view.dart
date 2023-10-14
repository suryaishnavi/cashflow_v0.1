import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../4_customer_screen/loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
import '../config/routes/route_constants.dart';
import '../models/LoanStatus.dart';
import '../widgets/page_heading.dart';
import '../widgets/tonal_filled_button.dart';
import '1_customer_data/customer_profile_cubit.dart';
import 'loan_tabs/loans.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanCreationBloc, LoanCreationState>(
      listener: (context, state) {
        if (state is LoanCreationSuccessState) {
          BlocProvider.of<CustomerProfileCubit>(context).getLoans();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.showCustomerProfile),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
                builder: (context, state) {
                  if (state is CustomerProfileInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CustomerProfileError) {
                    return Center(
                        child: Text(AppLocalizations.of(context)!.errorMsg));
                  }
                  if (state is CustomerProfileLoadedState) {
                    return Column(
                      children: [
                        ListTile(
                          isThreeLine: true,
                          leading: const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person, size: 24),
                          ),
                          title: Text(
                              state.name.length > 20
                                  ? '${state.name[0].toUpperCase() + state.name.substring(1, 20)}...'
                                  : state.name[0].toUpperCase() +
                                      state.name.substring(1),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.phone.substring(0, 3)}-${state.phone.substring(3, 6)} ${state.phone.substring(6, 9)} ${state.phone.substring(9, 13)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                state.address[0].toUpperCase() +
                                    state.address.substring(1),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        // -----------------Additional Loans button-----------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PageHeading(
                              heading:
                                  AppLocalizations.of(context)!.loanDetails,
                            ),
                            TonalFilledButton(
                                onPressed: () {
                                  // call loan creation bloc to reset event
                                  BlocProvider.of<LoanCreationBloc>(context)
                                      .add(LoanCreationResetEvent());
                                  GoRouter.of(context).pushNamed(
                                      RouteConstants.additionalLoanView);
                                },
                                text: AppLocalizations.of(context)!
                                    .createLoan('additional'),
                                icon: const Icon(Icons.add, size: 20))
                          ],
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            // -----------------Loans TabBar-----------------
            const Expanded(child: LoansTabBar()),
          ],
        ),
      ),
    );
  }
}

class LoansTabBar extends StatefulWidget {
  const LoansTabBar({super.key});

  @override
  State<LoansTabBar> createState() => _LoansTabBarState();
}

class _LoansTabBarState extends State<LoansTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: AppLocalizations.of(context)!.activeLoans),
          Tab(text: AppLocalizations.of(context)!.closedLoans),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          // Contents of tab 1
          Loans(loanStatus: LoanStatus.ACTIVE),
          // Contents of tab 2
          Loans(loanStatus: LoanStatus.CLOSED),
        ],
      ),
    );
  }
}
