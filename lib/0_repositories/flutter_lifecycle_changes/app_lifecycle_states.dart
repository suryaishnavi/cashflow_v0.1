import 'dart:async';

import 'package:flutter/widgets.dart';

class AppLifecycleStates {
  static final AppLifecycleStates _instance = AppLifecycleStates._internal();

  factory AppLifecycleStates() => _instance;

  AppLifecycleStates._internal();

  AppLifecycleListener? _listener;

  final appLifeCycleEvent = StreamController<AppLifecycleState>.broadcast();

  void initialize() {
    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(
      // onDetach: _onDetach,
      // onHide: _onHide,
      // onInactive: _onInactive,
      // onPause: _onPause,
      // onResume: _onResume,
      // onShow: _onShow,
      onStateChange: _onStateChanged,
    );
  }

  // void _onDetach() {
  //   print('onDetach');
  //   appLifeCycleEvent.add(AppLifecycleState.detached);
  // }

  // void _onInactive() {
  //   print('onInactive');
  //   appLifeCycleEvent.add(AppLifecycleState.inactive);
  // }

  // void _onHide() {
  //   print('onHide');
  //   appLifeCycleEvent.add(AppLifecycleState.inactive);
  // }

  // void _onPause() {
  //   print('onPause');
  //   appLifeCycleEvent.add(AppLifecycleState.paused);
  // }

  // void _onResume() {
  //   print('onResume');
  //   appLifeCycleEvent.add(AppLifecycleState.resumed);
  // }

  // void _onShow() {
  //   print('onShow');
  //   appLifeCycleEvent.add(AppLifecycleState.resumed);
  // }

  void _onStateChanged(AppLifecycleState state) {
    appLifeCycleEvent.add(state);
  }

  Stream<AppLifecycleState> get appLifeCycleEvents => appLifeCycleEvent.stream;

  void dispose() {
    _listener?.dispose();
  }
}
