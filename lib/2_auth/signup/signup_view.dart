import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../0_repositories/auth_repository.dart';
import '../../config/routes/route_constants.dart';
import '../../info_helper/form_submission_status.dart';
import '../../widgets/custom_eleveted_button.dart';
import '../../widgets/page_heading.dart';
import '../auth_helper_cubit/auth_cubit.dart';
import 'signup_bloc/signup_bloc.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  // dispose
  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(
        authRepo: context.read<AuthRepository>(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _signupForm()),
    );
  }

  Widget _signupForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30.0),
              PageHeading(heading: AppLocalizations.of(context)!.create),
              MultiBlocListener(
                listeners: [
                  BlocListener<SignupBloc, SignupState>(
                    listener: (context, state) {
                      final formStatus = state.formStatus;
                      if (formStatus is SubmissionFailed) {
                        final String exception =
                            formStatus.exception.toString();
                        int startIndex = exception.indexOf('"message": "') +
                            '"message": "'.length;
                        int endIndex = exception.indexOf('"', startIndex);
                        String errorMessage =
                            exception.substring(startIndex, endIndex);
                        _showSnackBar(context, errorMessage);
                      }
                    },
                  ),
                  BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state == AuthState.confirmSignUp) {
                        GoRouter.of(context)
                            .replaceNamed(RouteConstants.confirmation);
                      }
                    },
                  ),
                ],
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      children: [
                        _userNameField(),
                        const SizedBox(height: 16.0),
                        _userEmailField(),
                        const SizedBox(height: 16.0),
                        _userPhoneNumberField(),
                        const SizedBox(height: 16.0),
                        _passwordField(),
                        const SizedBox(height: 32.0),
                        _submitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userNameField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: const Icon(Icons.person),
            labelText: AppLocalizations.of(context)!.name,
            hintText: AppLocalizations.of(context)!.nameHint,
          ),
          onChanged: (value) => context
              .read<SignupBloc>()
              .add(SignupUserNameChange(userName: value.trim())),
          validator: (value) => state.isValidUsername
              ? null
              : AppLocalizations.of(context)!.nameError,
        );
      },
    );
  }

  Widget _userEmailField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: AppLocalizations.of(context)!.email,
            hintText: AppLocalizations.of(context)!.emailHint,
          ),
          onChanged: (value) => context
              .read<SignupBloc>()
              .add(SignupEmailChange(email: value.trim())),
          validator: (value) => state.isValidEmail
              ? null
              : AppLocalizations.of(context)!.emailError,
        );
      },
    );
  }

  Widget _userPhoneNumberField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: const Text('+91'),
            icon: const Icon(Icons.phone_android),
            labelText: AppLocalizations.of(context)!.mobile,
            hintText: AppLocalizations.of(context)!.mobileHint,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (value) => context
              .read<SignupBloc>()
              .add(SignupPhoneChange(phone: value.trim())),
          validator: (value) => state.isValidPhone
              ? null
              : AppLocalizations.of(context)!.mobileError,
        );
      },
    );
  }

  bool obscureText = false;
  Widget _passwordField() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          enableSuggestions: false,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: obscureText
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
            icon: const Icon(Icons.security),
            labelText: AppLocalizations.of(context)!.password,
            hintText: AppLocalizations.of(context)!.passwordHint,
          ),
          onChanged: (value) => context
              .read<SignupBloc>()
              .add(SignupPasswordChange(password: value.trim())),
          validator: (value) => state.isValidPassword
              ? null
              : AppLocalizations.of(context)!.passwordError,
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupBloc>().add(SignupSubmitted());
                  }
                },
                child: Text(AppLocalizations.of(context)!.signup,
                    style: const TextStyle(fontSize: 16.0)),
              );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
