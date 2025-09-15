import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/init/firebase/crashlytics/crashlytics_manager.dart';

part 'connectivity_store.g.dart';

class ConnectivityStore = ConnectivityStoreBase with _$ConnectivityStore;

abstract class ConnectivityStoreBase with Store {
  late final Connectivity connectivity;
  final CrashlyticsManager _crashlyticsManager = CrashlyticsManager.instance;
  bool _isOfflineModeShowing = false;

  ConnectivityStoreBase() {
    // connectivityStream = ObservableStream(Connectivity().onConnectivityChanged);
    connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        ///This check is required to be able to run on web while debugging.
        if (kIsWeb == false && kDebugMode == false) {
          triggerConnection(false);
        }
      } else {
        triggerConnection(true);
      }
    });
  }

  // @observable
  // ObservableStream<ConnectivityResult>? connectivityStream;

  @observable
  bool hasConnection = true;

  @action
  void triggerConnection(bool value) {
    if (value == hasConnection) return;
    hasConnection = value;
  }

  void showOfflineMode(BuildContext context) {
    if (!_isOfflineModeShowing && !hasConnection) {
      _isOfflineModeShowing = true;
      // showOfflineModeBottomSheet(context, isInitialLaunch: false);
    }
  }

  void hideOfflineMode(BuildContext context) {
    if (_isOfflineModeShowing && hasConnection) {
      _isOfflineModeShowing = false;
      context.pop();
    }
  }

  Future<bool> checkConnection() async {
    try {
      final ConnectivityResult result = await connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) return false;
      return true;
    } catch (e) {
      await _crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'connectivity_store/checkConnection');
      return false;
    }
  }

  Stream<ConnectivityResult> get getConnectivityStream {
    return connectivity.onConnectivityChanged;
  }
}
