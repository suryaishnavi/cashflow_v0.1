import 'package:cashflow/1_session/session_cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../1_session/onboarding_screens/onboarding_view.dart';
import '../../1_session/sync_data_screen/sync_data.dart';
import '../../2_auth/authentication_view.dart';
import '../../2_auth/confirmation/confirmation_view.dart';
import '../../2_auth/password_reset/reset_password_view.dart';
import '../../3_circle_screen/circles_bloc/circle_bloc.dart';
import '../../3_circle_screen/cities/cities_view.dart';
import '../../4_customer_screen/create_customer_tab_view.dart';
import '../../4_customer_screen/customers_view.dart';
import '../../4_customer_screen/loan_creation_bloc/create_loan_view.dart';
import '../../5_customer_profile_screen/create_loan_tab_view.dart';
import '../../5_customer_profile_screen/customer_profile_view.dart';
import '../../common/overall_view/overall_view.dart';
import '../../info_helper/loading_view.dart';
import 'route_constants.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    // * initial route
    // if the user is not authenticated, go to the onboarding screen
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouteConstants.loading,
        builder: (context, state) {
          return BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state is Authenticated) {
                context
                    .read<CircleBloc>()
                    .add(LoadCirclesEvent(appUser: state.user));
                return const OverallView();
              } else if (state is Unauthenticated) {
                return const AuthenticationView();
              } else if (state is OnboardingState) {
                return const OnboardingView();
              }
              return const LoadingView();
            },
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteConstants.onboarding,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage(child: OnboardingView()),
      ),
      GoRoute(
        path: '/gettingData',
        name: RouteConstants.gettingData,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage(child: SyncData()),
      ),
      // * auth routes
      GoRoute(
        path: '/authentication',
        name: RouteConstants.auth,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage(
          child: AuthenticationView(),
        ),
        routes: [
          GoRoute(
            path: 'confirmation',
            name: RouteConstants.confirmation,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(
              child: ConfirmationView(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/forgetPassword',
        name: RouteConstants.forgetPassword,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage(
          child: ResetPasswordView(),
        ),
      ),

      // * session routes
      GoRoute(
        path: '/overallview',
        name: RouteConstants.overallview,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const MaterialPage(
          child: OverallView(),
        ),
        routes: [
          GoRoute(
            path: 'citiesView',
            name: RouteConstants.citiesView,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(
              child: CitiesView(),
            ),
          ),
          GoRoute(
            path: 'customersView',
            name: RouteConstants.customers,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const MaterialPage(
              child: CustomersView(),
            ),
            routes: [
              GoRoute(
                path: 'customerCreation',
                name: RouteConstants.customerCreation,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    const MaterialPage(
                  child: CreateNewCustomerTabView(),
                ),
              ),
              GoRoute(
                path: 'loanCreation',
                name: RouteConstants.loanCreation,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    MaterialPage(
                  child: CreateLoanView(
                    isAdditionalLoan: false,
                    isNewLoan: state.extra! as bool,
                  ),
                ),
              ),
              GoRoute(
                path: 'customerProfileView',
                name: RouteConstants.customerProfileView,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    const MaterialPage(
                  child: CustomerProfileView(),
                ),
                routes: [
                  GoRoute(
                    path: 'additionalLoanView',
                    name: RouteConstants.additionalLoanView,
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        const MaterialPage(
                      child: CreateLoanTabView(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
