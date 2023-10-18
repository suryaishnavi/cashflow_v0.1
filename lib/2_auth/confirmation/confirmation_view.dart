import 'package:cashflow/config/routes/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../0_repositories/auth_repository.dart';
import '../../1_session/session_cubit/session_cubit.dart';
import '../../3_circle_screen/circles_bloc/circle_bloc.dart';
import '../../info_helper/form_submission_status.dart';
import '../../widgets/custom_eleveted_button.dart';
import '../auth_helper_cubit/auth_cubit.dart';
import 'confirmation_bloc/confirmation_bloc.dart';

class ConfirmationView extends StatefulWidget {
  const ConfirmationView({super.key});

  @override
  State<ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmationCodeController =
      TextEditingController();

// dispose

  @override
  void dispose() {
    _confirmationCodeController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmationBloc(
        authRepo: context.read<AuthRepository>(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: _confirmationForm(),
    );
  }

  Widget _confirmationForm() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: MultiBlocListener(
              listeners: [
                BlocListener<ConfirmationBloc, ConfirmationState>(
                  listener: (context, state) {
                    final formStatus = state.formStatus;
                    if (formStatus is SubmissionFailed) {
                      final String exception = formStatus.exception.toString();
                      int startIndex = exception.indexOf('"message": "') +
                          '"message": "'.length;
                      int endIndex = exception.indexOf('"', startIndex);
                      String errorMessage =
                          exception.substring(startIndex, endIndex);
                      _showSnackBar(context, errorMessage, Colors.red);
                    }
                    if (formStatus is SubmissionSuccess) {
                      _showSnackBar(context,
                          AppLocalizations.of(context)!.confirm, Colors.green);
                    }
                  },
                ),
                BlocListener<SessionCubit, SessionState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      BlocProvider.of<CircleBloc>(context).add(
                        LoadCirclesEvent(appUser: state.user),
                      );
                      GoRouter.of(context).go('/overallview');
                    }
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // 'Verify Your mobile number',
                    AppLocalizations.of(context)!.confirmPageTxt('confirm'),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    // 'Enter the 6-digit verification code sent to',
                    AppLocalizations.of(context)!.confirmPageTxt('verfication'),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    // '${context.read<AuthCubit>().credentials.phoneNumber}',
                    context.read<AuthCubit>().credentials.signInId,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _confirmationField(),
                        const SizedBox(height: 16.0),
                        Row(
                          // space between
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .confirmPageTxt('resend'),
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            _resendConfirmationCodeButton(),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        _submitButton(),
                        const SizedBox(height: 16.0),
                        _backToLoginButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmationField() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      builder: (context, state) {
        return TextFormField(
          controller: _confirmationCodeController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            icon: const Icon(Icons.key),
            label: Text(AppLocalizations.of(context)!.confirmPageTxt('label')),
            hintText: AppLocalizations.of(context)!.confirmPageTxt('hint'),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the code';
            }
            if (value.length < 6) {
              return 'Please enter the 6-digit code';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    context.read<ConfirmationBloc>().add(
                          ConfirmationSubmitted(
                              code: _confirmationCodeController.text.trim()),
                        );
                  }
                },
                child: Text(AppLocalizations.of(context)!.confirm,
                    style: const TextStyle(fontSize: 16.0)),
              );
      },
    );
  }

  bool clicked = false;

  Widget _resendConfirmationCodeButton() {
    return (!clicked)
        ? BlocBuilder<ConfirmationBloc, ConfirmationState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  setState(() {
                    clicked = true;
                  });
                  context.read<ConfirmationBloc>().add(
                        ResendConfirmationCode(),
                      );
                  _showSnackBar(
                      context,
                      AppLocalizations.of(context)!
                          .confirmPageTxt('newCodeSent'),
                      Colors.green);
                },
                child: Text(
                  AppLocalizations.of(context)!.confirmPageTxt('resendTxt'),
                  style: const TextStyle(fontSize: 16.0),
                ),
              );
            },
          )
        : TextButton(
            onPressed: null,
            child: Text(
              AppLocalizations.of(context)!.confirmPageTxt('sentTxt'),
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Widget _backToLoginButton() {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go(RouteConstants.auth);
      },
      child: Text(
        AppLocalizations.of(context)!.confirmPageTxt('backToSignIn'),
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color,
      {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }
}
