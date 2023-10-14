import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../0_repositories/auth_repository.dart';
import '../../config/routes/route_constants.dart';
import '../../widgets/page_heading.dart';
import '../auth_helper_cubit/auth_cubit.dart';
import 'signin_bloc/signin_bloc.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SigninBloc(
              authRepo: context.read<AuthRepository>(),
              authCubit: context.read<AuthCubit>(),
            ),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: _logInForm()));
  }

  Widget _logInForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30.0),
              PageHeading(heading: AppLocalizations.of(context)!.welcome),
              const SizedBox(height: 32.0),
              MultiBlocListener(
                listeners: [
                  BlocListener<SigninBloc, SigninState>(
                    listener: (context, state) {
                      if (state is SigninStateSubmissionFailed) {
                        final String exception = state.exception.toString();
                        int startIndex = exception.indexOf('"message": "') +
                            '"message": "'.length;
                        int endIndex = exception.indexOf('"', startIndex);
                        String errorMessage =
                            exception.substring(startIndex, endIndex);
                        _showSnackBar(context, errorMessage);
                      } else if (state is SigninStateSignInSuccess) {
                        GoRouter.of(context).go(RouteConstants.gettingData);
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
                  child: Column(
                    children: [
                      _phoneNumberField(),
                      const SizedBox(height: 16.0),
                      _passwordField(),
                      const SizedBox(height: 32.0),
                      _submitButton(),
                      const SizedBox(height: 16.0),
                      _forgetPassword(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final phoneNumberController = TextEditingController();
  Widget _phoneNumberField() {
    return BlocConsumer<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninStateSubmissionFailed) {
          phoneNumberController.clear();
        }
      },
      builder: (context, state) {
        return TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              icon: const Icon(Icons.email),
              // prefix: const Text('+91'),
              labelText: AppLocalizations.of(context)!.email,
              hintText: AppLocalizations.of(context)!.emailHint,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.emailHint;
              } else if (value.contains('@') == false) {
                return AppLocalizations.of(context)!.emailError;
              }
              return null;
            });
      },
    );
  }

  // final phoneNumberController = TextEditingController();
  // Widget _phoneNumberField() {
  //   return BlocConsumer<SigninBloc, SigninState>(
  //     listener: (context, state) {
  //       if (state is SigninStateSubmissionFailed) {
  //         phoneNumberController.clear();
  //       }
  //     },
  //     builder: (context, state) {
  //       return TextFormField(
  //           controller: phoneNumberController,
  //           keyboardType: TextInputType.phone,
  //           decoration: const InputDecoration(
  //             icon: Icon(Icons.phone_android),
  //             prefix: Text('+91'),
  //             labelText: 'MobileNumber',
  //             hintText: 'Enter your mobile number',
  //           ),
  //           validator: (value) {
  //             if (value == null || value.isEmpty) {
  //               return 'Please enter your mobile number';
  //             } else if (value.length < 10) {
  //               return 'MobileNumber must be at least 10 characters long';
  //             }
  //             return null;
  //           });
  //     },
  //   );
  // }

  bool obscureText = true;
  final passwordController = TextEditingController();
  Widget _passwordField() {
    return BlocConsumer<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninStateSubmissionFailed) {
          passwordController.clear();
        }
      },
      builder: (context, state) {
        return TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            icon: const Icon(Icons.security),
            labelText: AppLocalizations.of(context)!.password,
            hintText: AppLocalizations.of(context)!.passwordHint,
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
          ),
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.passwordHint;
            } else if (value.length < 8) {
              return AppLocalizations.of(context)!.passwordError;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SigninBloc, SigninState>(
      builder: (context, state) {
        return state is SigninStateLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    context.read<SigninBloc>().add(
                          SigninEventSubmitted(
                            phoneNumber: phoneNumberController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                  }
                },
                child: Text(AppLocalizations.of(context)!.signin,
                    style: const TextStyle(fontSize: 16.0)),
              );
      },
    );
  }

  Widget _forgetPassword() {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).replaceNamed(RouteConstants.forgetPassword);
      },
      child: Text(AppLocalizations.of(context)!.forgotPassword,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.primary,
          )),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
