import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../0_repositories/amplify_hub_events/auth_event_handler.dart';
import '../../0_repositories/amplify_hub_events/data_store_event_handler.dart';
import '../../0_repositories/app_user_data_repository.dart';
import '../../0_repositories/auth_repository.dart';
import '../../models/AppUser.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final AppUserDataRepository appUserDataRepo;
  // auth events subscription
  late StreamSubscription<AuthHubEvent> _authEventSubscription;
  // DataStoreHubEvent event;
  late StreamSubscription<DataStoreHubEvent> _dataStoreEventSubscription;
  late List<AppUser> appUser = [];
  late Map<String, dynamic> userId;
  static const int maxRetryCount = 20;
  static const int initialRetryDelaySeconds = 3;
  AppUser get user => (state as Authenticated).user;

  SessionCubit({
    required this.authRepo,
    required this.appUserDataRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
    _authEventSubscription = AuthEventHandler().authEvents.listen(
      (event) async {
        if (event.eventName == 'SIGNED_IN') {
          await Amplify.DataStore.start();
        } else if (event.eventName == 'SIGNED_OUT' ||
            event.eventName == 'SESSION_EXPIRED') {
          emit(Unauthenticated());
        }
      },
    );
    _dataStoreEventSubscription = DataStoreEventHandler().dataStoreEvent.listen(
      (event) {
        if (event.eventName == 'ready') {
          subsequentLogin();
        }
      },
    );
  }

  // ignore: invalid_use_of_internal_member
  final storage = AmplifySecureStorage(
    config: AmplifySecureStorageConfig(
      scope: 'userDetails',
    ),
  );

// get authernticated user details from cognito
  Future<Map<String, dynamic>> getCognitoUserSub() async {
    return await authRepo.attemptAutoLogin();
  }

  // get AppUser from DataStore
  Future<List<AppUser>> getAppUser({required String id}) async {
    return await appUserDataRepo.getUserbyId(id: id);
  }

  void attemptAutoLogin() async {
    // print('attemptAutoLogin');
    try {
      userId = await getCognitoUserSub();
      if (userId.isEmpty) {
        throw Exception('User not logIn');
      } else {
        safePrint('User is already Authenticated with UserID: $userId');
      }

      await Amplify.DataStore.start();
      // print('Amplify DataStore called to start');
      appUser = await getAppUser(id: '${userId['sub']}');

      int retryCount = 0;
      int retryDelaySeconds = initialRetryDelaySeconds;

      while (appUser.isEmpty && retryCount < maxRetryCount) {
        await Future.delayed(Duration(seconds: retryDelaySeconds));
        appUser = await getAppUser(id: '${userId['sub']}');
        retryCount++;
        retryDelaySeconds *= retryCount;
        if (retryCount == 5) {
          // again check if user is logged in
          userId = await getCognitoUserSub();
          if (userId.isEmpty) {
            throw Exception('User not logged in');
          } else {
            // stop data store and wait for 5 seconds before starting again
            await Amplify.DataStore.stop();
            await Future.delayed(const Duration(seconds: 5), () async {
              await Amplify.DataStore.start();
            });
          }
        }
        if (appUser.isNotEmpty) {
          break;
        }
      }

      if (appUser.isEmpty && retryCount == maxRetryCount) {
        signOut();
      }

      if (appUser.isNotEmpty) {
        emit(Authenticated(user: appUser.first));
      }
    } on Exception {
      safePrint('Exception in attemptAutoLogin : $Exception');
      final isLanguageSelected = await storage.read(key: 'isLanguageSelected');
      if (isLanguageSelected == null) {
        emit(OnboardingState());
      } else {
        emit(Unauthenticated());
      }
      await authRepo.clearStore();
    }
  }

  void firstTimeUserCreation() async {
    subsequentLogin();
  }

  void subsequentLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final String? appUserID = await storage.read(key: 'sub');
    if (appUserID == null) {
      signOut();
    }
    try {
      appUser = await getAppUser(id: appUserID!);
      if (appUser.isEmpty) {
        int retryCount = 0;
        int seconds = 3;
        while (appUser.isEmpty && retryCount < 20) {
          await Future.delayed(Duration(seconds: seconds));
          appUser = await getAppUser(id: appUserID); // Fetch user again
          retryCount++;
          seconds = seconds * retryCount;
          if (appUser.isNotEmpty) {
            break;
          }
        }
        // if user is still empty after 20 seconds, sign out
        if (appUser.isEmpty && retryCount == 20) {
          signOut();
        } else {
          emit(Authenticated(user: appUser.first));
        }
      } else {
        emit(Authenticated(user: appUser.first));
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    await authRepo.signOutCurrentUser();
  }

  @override
  Future<void> close() {
    _authEventSubscription.cancel();
    _dataStoreEventSubscription.cancel();
    return super.close();
  }
}
