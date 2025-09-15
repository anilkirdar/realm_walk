import 'package:flutter/material.dart';

import '../theme/dark/_app_theme_dark.dart';
import '../theme/light/_app_theme_light.dart';
import 'custom_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier() {
    readThemeMode();
  }

  late ThemeData _theme = AppThemeLight.instance.theme;
  late bool _isDark = false;
  late CustomTheme _customTheme = CustomTheme.light();

  CustomTheme get getCustomTheme => _customTheme;

  ThemeData get getTheme => _theme;

  bool get isDark => _isDark;

  readThemeMode() async {
    // final String value =
    //     LocalManager.instance.getStringValue(LocalManagerKeys.themeMode);
    // var themeMode = value == '' ? 'light' : value;
    var themeMode = 'light';
    if (themeMode == 'light') {
      _customTheme = CustomTheme.light();
      _theme = AppThemeLight.instance.theme;
    } else {
      _customTheme = CustomTheme.dark();
      _isDark = true;
      _theme = AppThemeDark.instance.theme;
    }
    //SystemInit.instance.setSystemUIOverlayStyle(isDark);
    // setDarkMode();
    // setLightMode();
    notifyListeners();
  }

  void setDarkMode() async {
    _customTheme = CustomTheme.dark();
    _theme = AppThemeDark.instance.theme;
    _isDark = true;
    // await LocalManager.instance
    //     .setStringValue(LocalManagerKeys.themeMode, 'dark');
    //SystemInit.instance.setSystemUIOverlayStyle(!isDark);
    notifyListeners();
  }

  void setLightMode() async {
    _customTheme = CustomTheme.light();
    _theme = AppThemeLight.instance.theme;
    _isDark = false;
    // await LocalManager.instance
    //     .setStringValue(LocalManagerKeys.themeMode, 'light');
    // SystemInit.instance.setSystemUIOverlayStyle(!isDark);
    notifyListeners();
  }
}
