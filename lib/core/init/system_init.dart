import 'package:universal_io/io.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/context_extension.dart';
import 'cache/local_manager.dart';
import 'config/config.dart';
import 'firebase/performance/performance_manager.dart';
import 'managers/analytic_manager.dart';
import 'managers/permission_manager.dart';
import 'theme/app_color_scheme.dart';

class SystemInit {
  static SystemInit? _instance;

  static SystemInit get instance => _instance ??= SystemInit._();

  SystemInit._();

  void setSystemUIOverlayStyle(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            isDark
                ? AppColorScheme.instance.backgroundDark
                : AppColorScheme.instance.background,
        systemNavigationBarDividerColor:
            isDark
                ? AppColorScheme.instance.bottomNavBarDark
                : AppColorScheme.instance.background,
        systemNavigationBarColor:
            isDark
                ? AppColorScheme.instance.bottomNavBarDark
                : AppColorScheme.instance.background,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,

        // systemNavigationBarContrastEnforced: ,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void setCustomSystemUIOverlayStyle({
    SystemUiMode? mode,
    Color? statusBarColor,
    Color? systemNavigationBarDividerColor,
    Color? systemNavigationBarColor,
    Brightness? systemNavigationBarIconBrightness,
    Brightness? statusBarIconBrightness,
    Brightness? statusBarBrightness,
  }) {
    mode != null ? SystemChrome.setEnabledSystemUIMode(mode) : null;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        systemNavigationBarDividerColor: systemNavigationBarDividerColor,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
    );
  }

  void setSystemUIOverlayStyleCallView() {
    /// Set style according to call UI
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColorScheme.instance.secondary,
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColorScheme.instance.secondary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: AppColorScheme.instance.secondary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void setSystemUIOverlayStyleGuideView(BuildContext context) {
    /// Set style according to call UI
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: context.theme.scaffoldBackgroundColor,
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColorScheme.instance.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: context.theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void setSystemUIOverlayStyleWelcomeView() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  void setSystemUIOverlayStyleOnboardView() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
  
  void setSystemUIOverlayStyleAuthView() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void setSystemUIOverlayStyleProfileView(bool isDark) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor:
            isDark
                ? AppColorScheme.instance.bottomNavBarDark
                : AppColorScheme.instance.background,
        systemNavigationBarColor:
            isDark
                ? AppColorScheme.instance.bottomNavBarDark
                : AppColorScheme.instance.background,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Future<void> init() async {
    final Config config = Config.instance;

    /// kIsWeb check is required to be able to run on web
    /// otherwise Platform.isAndroid throws an error on web
    /// and PurchasesManager is not available for web
    if (kIsWeb == false) {
      config.setIsAndroid = Platform.isAndroid;

      /// Set setIsAndroid  = false, to see iOS UI
      //config.setIsAndroid = false;
      // _initPurchaseManager();
    }

    await LocalManager.preferencesInit();
    await AnalyticManager.initAnalyticManager();
    final bool areAnalyticsAllowed =
        await PermissionManager.instance.getAppTransparencyStatus();

    /// It makes sure that analytics are disabled, if ios user
    /// And if it is in release mode
    if (kReleaseMode) {
      /// If it is iOS platform and analytics are not allowed, it would not enable analytics
      if (areAnalyticsAllowed == false && config.isAndroid == false) {
        ///TODO: extract this code to analytics manager
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
        await PerformanceManager.instance.networkManager.setIsMonitoringEnabled(
          false,
        );

        ///TODO: extract this code to crashlytics manager
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          false,
        );
        return;
      }

      ///TODO: extract this code to crashlytics manager
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = (errorDetails) async {
        ///TODO: extract this code to crashlytics manager
        await FirebaseCrashlytics.instance.recordFlutterFatalError(
          errorDetails,
        );
      };

      ///TODO: extract this code to analytics manager
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await PerformanceManager.instance.networkManager.setIsMonitoringEnabled(
        true,
      );
    }
    /// Else it is debug mode, set analytics to false
    else {
      ///TODO: extract this code to analytics manager
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      await PerformanceManager.instance.networkManager.setIsMonitoringEnabled(
        false,
      );

      ///TODO: extract this code to crashlytics manager
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Init purchase manager with product's API keys
  // void _initPurchaseManager() {
  //   if (Platform.isIOS || Platform.isMacOS) {
  //     StoreConfig(
  //       store: Store.appleStore,
  //       apiKey: PurchaseConst.appleApiKey,
  //     );
  //   } else if (Platform.isAndroid) {
  //     StoreConfig(
  //       store: Store.googlePlay,
  //       apiKey: PurchaseConst.googleApiKey,
  //     );
  //   }
  // }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) {
//         return host == APIConst.baseUrl;
//     };
//   }
// }
