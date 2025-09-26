// TEMPLATE: wrapper_store.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../../../../core/init/firebase/remote_config/remote_config_keys.dart';
import '../../../../core/init/firebase/remote_config/remote_config_manager.dart';
import '../../../../core/init/notifier/localization_notifier.dart';
import '../../../../product/enum/local_keys_enum.dart';
import '../../../_main/model/user_model.dart';
import '../../../_main/viewmodel/main_viewmodel.dart';
import '../../../_product/stores/connectivity/connectivity_store.dart';
import '../../maintenance/maintenance_view.dart';
import '../service/wrapper_service.dart';

part 'wrapper_store.g.dart';

/// TEMPLATE: WrapperStore - Manages app's core lifecycle, networking, and user state.
class WrapperStore = WrapperStoreBase with _$WrapperStore;

abstract class WrapperStoreBase with Store, BaseViewModel {
  // Services & ViewModels
  late ConnectivityStore connectivityStore;
  late LocalizationNotifier localizationNotifier;
  late MainViewModel mainViewModel;
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

  bool get isPlatformAndroid => Platform.isAndroid;

  bool get isAppAvailable => _isAppAvailable;

  bool get isAppUpToDate => _isAppUpToDate;

  bool get isAppSoftUpToDate => _isAppSoftUpToDate;

  bool get isConnectionAvailable => _isConnectionAvailable;

  // Observables
  @observable
  bool isLoading = true;

  @observable
  bool isError = false;

  @observable
  bool isInitFetched = true;

  @observable
  UserModel? user;

  // Context
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  Future<void> init({
    bool isAuthenticated = true,
    bool bypassRedirect = false,
  }) async {
    try {
      setLoading(true);

      _initializeServices();
      await _initializeUpgrader();
      await _checkConnection();

      if (!_isConnectionAvailable) {
        _showOfflineSheet();
        return;
      }

      await _fetchAppStatus();

      if (!_isAppAvailable) {
        _showMaintenanceBottomSheet();
        return;
      }

      // Remove splash & navigate
      // FlutterNativeSplash.remove();

      final String? navigatedView = validateAndNavigate(
        isAppUpToDate: isAppUpToDate,
        isAppSoftUpToDate: _isAppSoftUpToDate,
        isInitFetched: isInitFetched,
        isAuthenticated: isAuthenticated,
        currentPath: GoRouter.of(
          viewModelContext,
        ).routerDelegate.currentConfiguration.fullPath,
      );

      Future.microtask(() async {
        if (!(navigatedView?.startsWith('/update-app') ?? false)) {
          mainViewModel.init();
        }

        if (navigatedView?.startsWith('/update-app') ?? false) {
          if (Platform.isAndroid) {
            try {
              await InAppUpdate.checkForUpdate();
              await InAppUpdate.performImmediateUpdate();
              return;
            } catch (e) {
              crashlyticsManager.sendACrash(
                error: e.toString(),
                stackTrace: StackTrace.current,
                reason: 'Error performImmediateUpdate at wrapperStore',
              );
            }
          }
        } else {
          if (navigatedView == null) {
            null;
          } else {
            viewModelContext.go(navigatedView);
          }
          if (deepRedirect != null) {
            viewModelContext.push(deepRedirect!);
            deepRedirect = null;
          }
        }
      });
    } catch (e, st) {
      setError(true);
      crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: st,
        reason: 'Error during WrapperStoreBase.init',
      );
    } finally {
      setLoading(false);
    }
  }

  void dispose() {
    _appResourcesTimer?.cancel();
  }

  // Actions
  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setError(bool value) => isError = value;

  Future<void> saveFCM(String fcmToken) async {
    final String userId =
        "${localManager.getIntValue(LocalManagerKeys.userId) ?? ''}";

    if (userId.isEmpty) return;
  }

  @action
  void clearAll() {
    _isAppAvailable = true;
    _isAppUpToDate = true;
    _isConnectionAvailable = true;
    _isMaintenanceSheetShown = false;
  }

  // Private methods
  void _initializeServices() {
    wrapperService = WrapperService(
      manager: vexanaManager.networkManager,
      googleComManager: vexanaManager.googleComManager,
    );
    connectivityStore = viewModelContext.read<ConnectivityStore>();
    localizationNotifier = viewModelContext.read<LocalizationNotifier>();
    mainViewModel = viewModelContext.read<MainViewModel>();
  }

  Future<void> _initializeUpgrader() async {
    _upgrader = Upgrader(
      minAppVersion: Platform.isAndroid
          ? RemoteConfigManager.instance.getString(
              RemoteConfigKeys.androidForceUpdateVersion,
            )
          : RemoteConfigManager.instance.getString(
              RemoteConfigKeys.iosForceUpdateVersion,
            ),
      durationUntilAlertAgain: const Duration(days: 1),
    );

    await _upgrader.initialize();
  }

  Future<void> _checkConnection() async {
    _isConnectionAvailable = await connectivityStore.checkConnection();
  }

  Future<void> _fetchAppStatus() async {
    if (!_isConnectionAvailable) return;

    _isAppAvailable = true; // fetch from Firestore or remote config
    _checkIsAppUpToDate();
  }

  void _checkIsAppUpToDate() {
    try {
      _isAppUpToDate = !_upgrader.belowMinAppVersion();
      _isAppSoftUpToDate = !_upgrader.isUpdateAvailable();
    } catch (e, st) {
      crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: st,
        reason: 'Error checking app update in _checkIsAppUpToDate',
      );
    }
  }

  static String? validateAndNavigate({
    required bool isAppUpToDate,
    required bool isAppSoftUpToDate,
    required bool isInitFetched,
    required bool isAuthenticated,
    required String currentPath,
  }) {
    if (isAppUpToDate == false) {
      return '/update-app?isUpdateAvailable=${isAppSoftUpToDate == false}';
    }

    if (isAuthenticated == false) {
      return '/auth';
    }

    if (currentPath == '/') {
      return '/home';
    } else if (currentPath.startsWith('/auth')) {
      if (isAuthenticated == false) {
        return null;
      } else {
        return '/home';
      }
    }

    return null;
  }

  void _showOfflineSheet() {
    // Show offline UI
  }

  void _showMaintenanceBottomSheet() {
    if (!_isMaintenanceSheetShown) {
      _isMaintenanceSheetShown = true;
      showMaintenanceBottomSheet(viewModelContext);
    }
  }
}
