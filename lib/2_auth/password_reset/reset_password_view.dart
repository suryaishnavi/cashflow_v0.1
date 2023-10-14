import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/routes/route_constants.dart';
import '../../widgets/page_heading.dart';
import '../../widgets/tonal_filled_button.dart';
import 'bloc/password_reset_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageHeading(
                        heading: AppLocalizations.of(context)!
                            .resetPasswordPageTxt('heading')),
                    TonalFilledButton(
                      onPressed: () {
                        GoRouter.of(context).go(RouteConstants.auth);
                      },
                      text: AppLocalizations.of(context)!.signin,
                      icon: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              const ResetPasswordStepper(),
            ],
          ),
        ),
      ),
    );
  }
}

// implementing stepper widget for password reset

class ResetPasswordStepper extends StatefulWidget {
  const ResetPasswordStepper({super.key});

  @override
  State<ResetPasswordStepper> createState() => _ResetPasswordStepperState();
}

class _ResetPasswordStepperState extends State<ResetPasswordStepper> {
  int index = 0;
  final userNameController = TextEditingController();
  final pwController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    pwController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          _snakebar(context, state.error, Colors.red);
        }
      },
      builder: (context, state) {
        return Stepper(
          currentStep: state.index,
          onStepContinue: () {
            if (state.index == 0) {
              final value = userNameController.text.trim();
              if (!value.contains('@')) {
                _snakebar(
                    context,
                    AppLocalizations.of(context)!.resetPasswordPageTxt('valid'),
                    Colors.red);
                return;
              }
              context.read<PasswordResetBloc>().add(
                    ResetPasswordEvent(
                      email: userNameController.text.trim(),
                    ),
                  );
            } else if (state.index == 1) {
              context.read<PasswordResetBloc>().add(
                    ConfirmResetPasswordEvent(
                      code: otpController.text.trim(),
                      password: pwController.text.trim(),
                    ),
                  );
            } else if (state.index == 2) {
              GoRouter.of(context).go(RouteConstants.auth);
            }
          },
          onStepCancel: () {
            if (index <= 0) {
              return;
              // GoRouter.of(context).replaceNamed(RouteConstants.auth);
            } else {
              setState(() {
                index--;
              });
            }
          },
          steps: <Step>[
            Step(
              title: Text(
                  AppLocalizations.of(context)!.resetPasswordPageTxt('title')),
              content: Column(
                children: [
                  TextField(
                    controller: userNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      // prefix: const Text('+91'),
                      labelText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('label'),
                      hintText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('hint'),
                    ),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(
                  AppLocalizations.of(context)!.resetPasswordPageTxt('title2')),
              content: Column(
                children: [
                  Text(
                      '${AppLocalizations.of(context)!.resetPasswordPageTxt('otpField')} ${state.email}'),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: pwController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('label2'),
                      hintText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('hint2'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.key),
                      labelText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('label3'),
                      hintText: AppLocalizations.of(context)!
                          .resetPasswordPageTxt('hint3'),
                    ),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(AppLocalizations.of(context)!.confirm),
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    Text(
                      AppLocalizations.of(context)!
                          .resetPasswordPageTxt('passwordBtnTxt'),
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _snakebar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/*
  1. Enter email address
  2. Enter OTP
  3. Enter new password
  4. Confirm new password
  5. Submit
*/