// TEMPLATE: wrapper_store.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

part 'wrapper_store.g.dart';

/// TEMPLATE: WrapperStore - Manages app's core lifecycle, networking, and user state.
class WrapperStore = WrapperStoreBase with _$WrapperStore;

abstract class WrapperStoreBase with Store {
  // BuildContext
  late BuildContext viewModelContext;

  void setContext(BuildContext context) => viewModelContext = context;

  // Services & Dependencies
  late WrapperService wrapperService;
  late Upgrader _upgrader;

  // Flags & States
  bool _isAppAvailable = true;
  bool _isAppUpToDate = true;
  bool _isAppSoftUpToDate = true;
  bool _isConnectionAvailable = true;
  bool _isMaintenanceSheetShown = false;

  String? deepRedirect;

  Timer? _appResourcesTimer;
  StreamSubscription<DocumentSnapshot>? _appStatusSubscription;

  @observable
  bool isUserPremium = false;

  @observable
  bool isInitFetched = true;

  @observable
  FetchedInitialResult fetchedInitialResult = FetchedInitialResult();

  @observable
  UserProfileViewDataModel? userProfile;

  @action
  Future<void> init({
    bool isAuthenticated = true,
    bool bypassRedirect = false,
  }) async {
    // Initialize services
    wrapperService = WrapperService();
    _upgrader = Upgrader();
    await _upgrader.initialize();

    await _checkConnection();

    if (!_isConnectionAvailable) {
      _showOfflineSheet();
      return;
    }

    await _fetchAppStatus();

    if (!_isAppAvailable) {
      _showMaintenanceSheet();
      return;
    }

    bool refreshed = await refreshAppResources();
    if (!refreshed) {
      _showOfflineSheet();
      return;
    }

    if (isAuthenticated) {
      await fetchInitialData();
    }

    // Navigation & splash removal
    FlutterNativeSplash.remove();

    String? route = validateAndNavigate(
      isAppUpToDate: _isAppUpToDate,
      isAppSoftUpToDate: _isAppSoftUpToDate,
      isAuthenticated: isAuthenticated,
    );

    Future.microtask(() {
      if (route != null) {
        viewModelContext.go(route);
      }
    });
  }

  Future<void> _checkConnection() async {
    _isConnectionAvailable = true; // implement real connection logic
  }

  Future<void> _fetchAppStatus() async {
    if (!_isConnectionAvailable) return;
    _isAppAvailable = true; // fetch from Firestore or remote config
    _checkIsAppUpToDate();
  }

  void _checkIsAppUpToDate() {
    try {
      _isAppUpToDate = true; // implement logic with _upgrader
      _isAppSoftUpToDate = true;
    } catch (e) {
      // handle crash
    }
  }

  Future<bool> refreshAppResources() async {
    // Example dummy logic
    _appResourcesTimer?.cancel();
    return true;
  }

  Future<void> fetchInitialData() async {
    // Example dummy logic
    fetchedInitialResult = FetchedInitialResult();
    isInitFetched = true;
    isUserPremium = true;
  }

  String? validateAndNavigate({
    required bool isAppUpToDate,
    required bool isAppSoftUpToDate,
    required bool isAuthenticated,
  }) {
    if (!isAppUpToDate) return '/update-app';
    if (!isAuthenticated) return '/auth';
    return '/home';
  }

  void _showOfflineSheet() {
    // Show offline UI
  }

  void _showMaintenanceSheet() {
    if (!_isMaintenanceSheetShown) {
      _isMaintenanceSheetShown = true;
      // Show maintenance UI
    }
  }

  @action
  void clearAll() {
    isUserPremium = false;
    _isAppAvailable = true;
    _isAppUpToDate = true;
    _isConnectionAvailable = true;
    _isMaintenanceSheetShown = false;
  }

  void dispose() {
    _appStatusSubscription?.cancel();
    _appResourcesTimer?.cancel();
  }
}

// Dummy classes to prevent compilation errors
class WrapperService {
  Future<void> getAppResources() async {}
}

class Upgrader {
  Future<void> initialize() async {}
}

class FetchedInitialResult {}

class UserProfileViewDataModel {}

class FlutterNativeSplash {
  static void remove() {}
}
