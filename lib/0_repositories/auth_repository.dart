import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthRepository {
  Future<Map<String, dynamic>> getUserIdFromAttributes() async {
    late Map<String, dynamic> currentSignInUserDetails;

    try {
      List<AuthUserAttribute> currentSignInUserAttributes =
          await Amplify.Auth.fetchUserAttributes();

      currentSignInUserDetails = {
        for (AuthUserAttribute attribute in currentSignInUserAttributes)
          attribute.userAttributeKey.key: attribute.value
      };
      return currentSignInUserDetails;
    } catch (e) {
      rethrow;
    }
  }

  // ignore: invalid_use_of_internal_member
  final storage = AmplifySecureStorage(
    config: AmplifySecureStorageConfig(
      scope: 'userDetails',
    ),
  );

  Future<Map<String, dynamic>> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.getPlugin(
        AmplifyAuthCognito.pluginKey,
      ).fetchAuthSession();
      final String? appUserID = await storage.read(key: 'sub');
      return session.isSignedIn ? {'sub': '$appUserID'} : {};
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInResult> logIn({
    // required phoneNumber,
    required email,
    required password,
  }) async {
    // late String userId;
    try {
      final result = await Amplify.Auth.signIn(
        // username: '+91$phoneNumber',
        username: email,
        password: password,
      );
      if (result.isSignedIn) {
        final Map<String, dynamic> userDetails =
            await getUserIdFromAttributes();
        await storage.write(key: 'sub', value: '${userDetails['sub']}');
        await storage.write(
            key: 'phoneNumber', value: '${userDetails['phone_number']}');
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp({
    required name,
    required email,
    required phoneNumber,
    required password,
  }) async {
    late bool isConfirmationSent;
    try {
      final userAttributes = <AuthUserAttributeKey, String>{
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.phoneNumber: '+91$phoneNumber',
        AuthUserAttributeKey.name: name,
      };

      final result = await Amplify.Auth.signUp(
        // username: '+91$phoneNumber',
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: userAttributes),
      );
      isConfirmationSent = await _handleSignUpResult(result);
    } on AuthException {
      rethrow;
    }

    return isConfirmationSent;
  }

  Future<bool> _handleSignUpResult(SignUpResult result) async {
    late bool isConfirmationSent;
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        isConfirmationSent = true;
        break;
      case AuthSignUpStep.done:
        // safePrint('Sign up is complete');
        break;
    }
    return isConfirmationSent;
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  Future<bool> confirmSignUp({
    // required phoneNumber,
    required email,
    required confirmationCode,
  }) async {
    late bool isSignUpComplete;
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        // username: '+91$phoneNumber',
        confirmationCode: confirmationCode,
      );
      isSignUpComplete = result.isSignUpComplete;
    } on AuthException {
      rethrow;
    }
    return isSignUpComplete;
  }

  Future<void> resendConfirmationCode({required username}) async {
    final resendResult = await Amplify.Auth.resendSignUpCode(
      username: username,
    );
    _handleCodeDelivery(resendResult.codeDeliveryDetails);
  }

  Future<bool> resetPassword(String username) async {
    bool verficationCodeSent = false;
    try {
      final result = await Amplify.Auth.resetPassword(
        username: username,
      );
      verficationCodeSent = await _handleResetPasswordResult(result);
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
    }
    return verficationCodeSent;
  }

  Future<bool> _handleResetPasswordResult(ResetPasswordResult result) async {
    bool isPasswordReset = false;
    switch (result.nextStep.updateStep) {
      case AuthResetPasswordStep.confirmResetPasswordWithCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        isPasswordReset = true;
        break;
      case AuthResetPasswordStep.done:
        safePrint('Successfully reset password');
        break;
    }
    return isPasswordReset;
  }

  Future<bool> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
  }) async {
    bool isPasswordReset = false;
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      isPasswordReset = result.isPasswordReset;
      safePrint('Password reset complete: ${result.isPasswordReset}');
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
    }
    return isPasswordReset;
  }

  Future<void> signOutCurrentUser() async {
    await storage.delete(key: 'sub');
    safePrint('successfully deleted key "sub" from storage');
    final result = await Amplify.Auth.signOut(
      options: const SignOutOptions(globalSignOut: true),
    );
    if (result is CognitoCompleteSignOut) {
      await clearStore();
      safePrint('Sign out completed successfully');
    } else if (result is CognitoPartialSignOut) {
      final globalSignOutException = result.globalSignOutException!;
      // final accessToken = globalSignOutException.accessToken;
      safePrint('Error signing user out: ${globalSignOutException.message}');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> clearStore() async {
    try {
      await Amplify.DataStore.clear();
      safePrint('DataStore is cleared.');
      // await stopStore();
    } on DataStoreException catch (e) {
      safePrint('Failed to clear DataStore: $e');
    }
  }

  // Future<void> stopStore() async {
  //   try {
  //     await Amplify.DataStore.stop();
  //     safePrint('DataStore is stopped.');
  //   } on DataStoreException catch (e) {
  //     safePrint('Failed to stop DataStore: $e');
  //   }
  // }
}

// ! This is the code for the new login flow

  // Future<void> _handleSignInResult(SignInResult result, String username) async {
  //   switch (result.nextStep.signInStep) {
  //     case AuthSignInStep.confirmSignInWithSmsMfaCode:
  //       final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
  //       _handleCodeDelivery(codeDeliveryDetails);
  //       break;
  //     case AuthSignInStep.confirmSignInWithNewPassword:
  //       safePrint('Enter a new password to continue signing in');
  //       break;
  //     case AuthSignInStep.confirmSignInWithCustomChallenge:
  //       final parameters = result.nextStep.additionalInfo;
  //       final prompt = parameters['prompt']!;
  //       safePrint(prompt);
  //       break;
  //     case AuthSignInStep.resetPassword:
  //       final resetResult = await Amplify.Auth.resetPassword(
  //         username: username,
  //       );
  //       await _handleResetPasswordResult(resetResult);
  //       break;
  //     case AuthSignInStep.confirmSignUp:
        // Resend the sign up code to the registered device.
  //       final resendResult = await Amplify.Auth.resendSignUpCode(
  //         username: username,
  //       );
  //       _handleCodeDelivery(resendResult.codeDeliveryDetails);
  //       break;
  //     case AuthSignInStep.done:
  //       safePrint('Sign in is complete');
  //       break;
  //   }
  // }

  // void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  //   safePrint(
  //     'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
  //     'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  //   );
  // }

  // Future<void> _handleResetPasswordResult(ResetPasswordResult result) async {
  //   switch (result.nextStep.updateStep) {
  //     case AuthResetPasswordStep.confirmResetPasswordWithCode:
  //       final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
  //       _handleCodeDelivery(codeDeliveryDetails);
  //       break;
  //     case AuthResetPasswordStep.done:
  //       safePrint('Successfully reset password');
  //       break;
  //   }
  // }

  // Future<void> confirmResetPassword({
  //   required String username,
  //   required String newPassword,
  //   required String confirmationCode,
  // }) async {
  //   try {
  //     final result = await Amplify.Auth.confirmResetPassword(
  //       username: username,
  //       newPassword: newPassword,
  //       confirmationCode: confirmationCode,
  //     );
  //     safePrint('Password reset complete: ${result.isPasswordReset}');
  //   } on AuthException catch (e) {
  //     safePrint('Error resetting password: ${e.message}');
  //   }
  // }