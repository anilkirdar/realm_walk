import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app/app_const.dart';
import 'core/init/cache/local_manager.dart';
import 'core/init/notifier/localization_notifier.dart';
import 'core/init/notifier/provider_list.dart';
import 'core/init/notifier/theme_notifier.dart';
import 'core/init/system_init.dart';
import 'generated/l10n.dart';
import 'product/enum/local_keys_enum.dart';
import 'routes/router.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...ApplicationProvider.instance.dependedItems],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, child) {
          final cacheThemeMode = LocalManager.instance.getStringValue(
            LocalManagerKeys.themeMode,
          );
          if (cacheThemeMode.isEmpty) {
            // final isDark = ctx.mediaQuery.platformBrightness == Brightness.dark;
            final isDark = false;
            if (isDark) {
              theme.setDarkMode();
            } else {
              theme.setLightMode();
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemInit.instance.setSystemUIOverlayStyle(theme.isDark);
          });

          return Consumer<LocalizationNotifier>(
            builder: (context, localizationNotifier, child) {
              return MaterialApp.router(
                title: AppConst.appName,
                debugShowCheckedModeBanner: false,
                theme: theme.getTheme,
                locale: Locale.fromSubtags(
                  languageCode: localizationNotifier.locale,
                ),
                localizationsDelegates: _localizationDelegate(),
                supportedLocales: _supportedLocales(),
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (didPop, result) async {
                      if (didPop) return;

                      final router = AppRouter.router;
                      // final currentLocation =
                      //     router.routerDelegate.currentConfiguration.uri
                      //         .toString();

                      if (router.canPop()) {
                        router.pop();
                      } else {
                        router.go('/'); // Ana sayfaya dön
                      }
                    },
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Iterable<LocalizationsDelegate<dynamic>>? _localizationDelegate() {
  return [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

Iterable<Locale> _supportedLocales() {
  return S.delegate.supportedLocales;
}
