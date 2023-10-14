import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';

class AuthEventHandler {
  static final AuthEventHandler _instance = AuthEventHandler._internal();

  factory AuthEventHandler() => _instance;

  AuthEventHandler._internal();

  StreamSubscription<AuthHubEvent>? subscription;
  final authEvent = StreamController<AuthHubEvent>.broadcast();

  void initialize() {
    subscription = Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          authEvent.add(event);
          break;
        case AuthHubEventType.signedOut:
          authEvent.add(event);
          break;
        case AuthHubEventType.sessionExpired:
          authEvent.add(event);
          break;
        case AuthHubEventType.userDeleted:
          safePrint('The user has been deleted.');
          break;
      }
    });
  }

  Stream<AuthHubEvent> get authEvents => authEvent.stream;

  void dispose() {
    subscription?.cancel();
    subscription = null;
    authEvent.close();
  }
}
