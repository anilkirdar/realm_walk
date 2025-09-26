import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/init/firebase/performance/performance_manager.dart';
import '../../core/init/managers/permission_manager.dart';
import '../_main/viewmodel/main_viewmodel.dart';
import '../auth/provider/auth_provider.dart';
import '../_product/stores/overlay_state_store.dart';
import '_wrapper/store/wrapper_store.dart';

class AuthStateChecker extends StatefulWidget {
  const AuthStateChecker({super.key, required this.child});

  final Widget child;

  @override
  State<AuthStateChecker> createState() => _AuthStateCheckerState();
}

class _AuthStateCheckerState extends State<AuthStateChecker> {
  @override
  void initState() {
    super.initState();

    // Build sonrası çalıştır → Overlay.of(context) ve provider'lar garanti hazır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      final wrapperStore = context.read<WrapperStore>();
      final auth = context.read<AuthProvider>();
      final overlayStateStore = context.read<OverlayStateStore>();
      final mainViewModel = context.read<MainViewModel>();

      overlayStateStore.setOverlayState(Overlay.of(context));

      final areAnalyticsAllowed = await PermissionManager.instance
          .getAppTransparencyPermission();

      if (areAnalyticsAllowed) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = (errorDetails) async {
          await FirebaseCrashlytics.instance.recordFlutterFatalError(
            errorDetails,
          );
        };
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
        await PerformanceManager.instance.networkManager.setIsMonitoringEnabled(
          true,
        );
      }

      mainViewModel.setContext(context);
      await auth.initialize();

      if (auth.isAuthenticated) {
        wrapperStore.init();
      } else {
        wrapperStore.init(isAuthenticated: false);
      }
    } catch (e, st) {
      debugPrint('AuthStateChecker initialization error: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Uygulama hemen router child'ını gösterecek
    return widget.child;
  }
}
