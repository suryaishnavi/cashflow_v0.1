import 'dart:async';

import 'package:amplify_api/amplify_api.dart'; //! Api
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '0_repositories/amplify_hub_events/auth_event_handler.dart';
import '0_repositories/amplify_hub_events/data_store_event_handler.dart';
import '0_repositories/app_user_data_repository.dart';
import '0_repositories/auth_repository.dart';
import '0_repositories/circle_data_repository.dart';
import '0_repositories/city_repository.dart';
import '0_repositories/customer_data_repository.dart';
import '0_repositories/customers_and_loan_data_repository.dart';
import '0_repositories/dependency_injection.dart';
import '0_repositories/emis_data_repository.dart';
import '0_repositories/flutter_lifecycle_changes/app_lifecycle_states.dart';
import '0_repositories/for_reports_generation/get_customer_data.dart';
import '0_repositories/loans_data_repository.dart';
import '1_session/onboarding_screens/language_bloc/language_bloc.dart';
import '1_session/session_cubit/session_cubit.dart';
import '1_session/sync_data_screen/cubit/sync_data_cubit.dart';
import '2_auth/auth_helper_cubit/auth_cubit.dart';
import '2_auth/password_reset/bloc/password_reset_bloc.dart';
import '3_circle_screen/circles_bloc/circle_bloc.dart';
import '3_circle_screen/cities/bloc/cities_bloc.dart';
import '3_circle_screen/create_new_circle/create_circle_bloc.dart';
import '4_customer_screen/create_customer_bloc/create_customer_bloc/create_customer_bloc.dart';
import '4_customer_screen/customer_bloc/customer_bloc.dart';
import '4_customer_screen/loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
import '4_customer_screen/update_loan_dialog/update_loan_dialog_bloc/update_loan_dialog_bloc.dart';
import '5_customer_profile_screen/1_customer_data/customer_profile_cubit.dart';
import '5_customer_profile_screen/2_loan_details/loan_data_cubit.dart';
import '5_customer_profile_screen/3_emi_details/emi_cubit.dart';
import '5_customer_profile_screen/loan_tabs/loan_refinance_bloc/bloc/loan_refinance_bloc.dart';
import '6_reports_gen_screen/cubit/report_cubit.dart';
import 'amplifyconfiguration.dart';
import 'cashflow_app.dart';
import 'circles_helper/overall_view/amplify_exceptions/amplify_exceptions_bloc.dart';
import 'circles_helper/overall_view/cashflow_lifecycle_bloc/cashflow_lifecycle_bloc.dart';
import 'circles_helper/overall_view/data_and_network_status_bloc/status_bloc.dart';
import 'circles_helper/overall_view/overall_view_bloc/overall_view_bloc.dart';
import 'circles_helper/screen_helper_cubit/screens_cubit.dart';
import 'models/ModelProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLifecycleStates().initialize();
  AuthEventHandler().initialize();
  DataStoreEventHandler().initialize();
  setupDependencyInjection();
  unawaited(_configureAmplify());
  await Future.delayed(const Duration(milliseconds: 500));
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<AppUserDataRepository>(
          create: (context) => AppUserDataRepository(),
        ),
        RepositoryProvider<CircleDataRepository>(
          create: (context) => CircleDataRepository(),
        ),
        RepositoryProvider<CustomerAndLoanDataRepository>(
          create: (context) => CustomerAndLoanDataRepository(),
        ),
        RepositoryProvider<LoansDataRepository>(
          create: (context) => LoansDataRepository(),
        ),
        RepositoryProvider<EmisDataRepository>(
          create: (context) => EmisDataRepository(),
        ),
        RepositoryProvider<GetCustomerData>(
          create: (context) => GetCustomerData(),
        ),
        RepositoryProvider<CityRepository>(
          create: (context) => CityRepository(),
        ),
        RepositoryProvider<CustomerDataRepository>(
          create: (context) => CustomerDataRepository(),
        ),
        RepositoryProvider<DataStoreEventHandler>(
          create: (context) => DataStoreEventHandler(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc()..add(GetLanguage()),
          ),
          BlocProvider<SyncDataCubit>(
            create: (context) => SyncDataCubit(),
          ),
          BlocProvider<OverallViewBloc>(
            create: (context) => OverallViewBloc(),
          ),
          BlocProvider<SessionCubit>(
            create: (context) => SessionCubit(
              authRepo: context.read<AuthRepository>(),
              appUserDataRepo: context.read<AppUserDataRepository>(),
            ),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              sessionCubit: context.read<SessionCubit>(),
            ),
          ),
          BlocProvider<ScreensCubit>(
            create: (context) => ScreensCubit(
              sessionCubit: context.read<SessionCubit>(),
            ),
          ),
          BlocProvider<CircleBloc>(
            create: (context) => CircleBloc(
              circleRepo: context.read<CircleDataRepository>(),
              screensCubit: context.read<ScreensCubit>(),
            ),
          ),
          BlocProvider<CreateCircleBloc>(
            create: (context) => CreateCircleBloc(
              circleDataRepo: context.read<CircleDataRepository>(),
              circleBloc: context.read<CircleBloc>(),
              sessionCubit: context.read<SessionCubit>(),
              cityRepo: context.read<CityRepository>(),
            ),
          ),
          BlocProvider<CustomerBloc>(
            create: (context) => CustomerBloc(
              screensCubit: context.read<ScreensCubit>(),
            ),
          ),
          BlocProvider<CreateCustomerBloc>(
            create: (context) => CreateCustomerBloc(
              cityRepository: context.read<CityRepository>(),
              screensCubit: context.read<ScreensCubit>(),
              customerBloc: context.read<CustomerBloc>(),
              customerAndLoanDataRepository:
                  context.read<CustomerAndLoanDataRepository>(),
            ),
          ),
          BlocProvider<LoanCreationBloc>(
            create: (context) => LoanCreationBloc(
              customerAndLoanDataRepository:
                  context.read<CustomerAndLoanDataRepository>(),
              screensCubit: context.read<ScreensCubit>(),
            ),
          ),
          BlocProvider<LoanDataCubit>(
            create: (context) => LoanDataCubit(
              loansDataRepo: context.read<LoansDataRepository>(),
              emisDataRepo: context.read<EmisDataRepository>(),
            ),
          ),
          BlocProvider<CustomerProfileCubit>(
            create: (context) => CustomerProfileCubit(
              screensCubit: context.read<ScreensCubit>(),
              loanDataCubit: context.read<LoanDataCubit>(),
            ),
          ),
          BlocProvider<EmiCubit>(
            create: (context) => EmiCubit(
              emisDataRepo: context.read<EmisDataRepository>(),
              loansDataRepo: context.read<LoansDataRepository>(),
              loanDataCubit: context.read<LoanDataCubit>(),
              customerDataRepo: context.read<CustomerDataRepository>(),
            ),
          ),
          BlocProvider<ReportCubit>(
            create: (context) => ReportCubit(
              circleDataRepo: context.read<CircleDataRepository>(),
              getCustomerData: context.read<GetCustomerData>(),
              sessionCubit: context.read<SessionCubit>(),
            ),
          ),
          BlocProvider<PasswordResetBloc>(
            create: (context) => PasswordResetBloc(
              authRepo: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<CitiesBloc>(
            create: (context) => CitiesBloc(
              cityRepository: context.read<CityRepository>(),
              screensCubit: context.read<ScreensCubit>(),
            ),
          ),
          BlocProvider<UpdateLoanDialogBloc>(
            create: (context) => UpdateLoanDialogBloc(
              loansDataRepository: context.read<LoansDataRepository>(),
              emisDataRepository: context.read<EmisDataRepository>(),
              customerDataRepository: context.read<CustomerDataRepository>(),
            ),
          ),
          BlocProvider<LoanRefinanceBloc>(
            create: (context) => LoanRefinanceBloc(
              screensCubit: context.read<ScreensCubit>(),
              updateLoanDialogBloc: context.read<UpdateLoanDialogBloc>(),
              loanCreationBloc: context.read<LoanCreationBloc>(),
              customerAndLoanDataRepository:
                  context.read<CustomerAndLoanDataRepository>(),
            ),
          ),
          BlocProvider<OverallViewBloc>(
            create: (context) => OverallViewBloc(),
          ),
          BlocProvider<CashflowLifecycleBloc>(
            create: (context) => CashflowLifecycleBloc(),
          ),
          BlocProvider<AmplifyExceptionsBloc>(
            create: (context) => AmplifyExceptionsBloc(),
          ),
          BlocProvider<StatusBloc>(
            create: (context) => StatusBloc(
              dataStoreEventHandler: context.read<DataStoreEventHandler>(),
            ),
          ),
        ],
        child: const CashflowApp(),
      ),
    ),
  );
}

Future<void> _configureAmplify() async {
  final api = AmplifyAPI();
  final cognito = AmplifyAuthCognito();
  final dataStore = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
    authModeStrategy: AuthModeStrategy.multiAuth,
    errorHandler: ((error) async {
      DataStoreEventHandler().dataStorePlugInError(e: error);
      // await _reinitializeAmplify();
    }),
  );
  await Amplify.addPlugins([api, cognito, dataStore]);
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    safePrint(
        "Amplify was already configured. Looks like app restarted on android");
  } on Exception catch (e) {
    debugPrint('Error configuring Amplify: $e');
  }
}

// Future<void> _reinitializeAmplify() async {
//   // ignore: invalid_use_of_visible_for_testing_member
//   await Amplify.reset();
//   await Future.delayed(const Duration(milliseconds: 500));
//   final api = AmplifyAPI();
//   final cognito = AmplifyAuthCognito();
//   final dataStore = AmplifyDataStore(
//     modelProvider: ModelProvider.instance,
//     errorHandler: ((error) async {
//       await _reinitializeAmplify();
//     }),
//   );
//   await Amplify.addPlugins([api, cognito, dataStore]);
//   try {
//     await Amplify.configure(amplifyconfig);
//   } on AmplifyAlreadyConfiguredException {
//     safePrint(
//         "Amplify was already configured. Looks like app restarted on android");
//   } on Exception catch (e) {
//     debugPrint('Error configuring Amplify: $e');
//   }
// }
