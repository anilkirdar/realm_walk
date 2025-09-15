import 'package:flutter/material.dart';

class AppColorScheme {
  static AppColorScheme? _instance;

  static AppColorScheme get instance {
    return _instance ??= AppColorScheme._init();
  }

  AppColorScheme._init();

  // final Color primary = const Color(0xFF6962CF);
  final Color primary = const Color(0xFFF22E63);
  final Color primaryDark = const Color(0xFF6962CF); //xxx need a new one
  final Color primaryOp10 = const Color(0xFFefeef9);
  // final Color secondary = const Color(0xFF413E69);
  final Color secondary = const Color(0xFFFF6480);
  final Color secondaryDark = const Color(0xFF23223A);
  final Color background = const Color(0xFFFFFFFF);
  final Color backgroundDark = const Color(0xFF2E2E2E);
  final Color bottomNavBarDark = const Color(0xFF3F3F3F);
  final Color white = const Color(0xFFFFFFFF);
  final Color black = const Color(0xFF000000);
  final Color shadowColorDark = const Color(0xFF000000).withOpacity(0.16);
  final Color shadowColorDark25 = const Color(0xFF000000).withOpacity(0.25);
  final Color shadowColorElevatedButton = const Color(0xFFF1F7FF);

  final Color grey = const Color(0xFF9D9D9D);
  final Color greyDark = const Color(0xFF6B6B6B); //xxx
  final Color grey1 = const Color(0xFFD0CFD5);
  final Color grey1Dark = const Color(0xFF96969B); //xxx
  final Color lightGrey = const Color(0xFFF6F6F6);
  final Color darkGrey = const Color(0xFF4F4F4F); //xxx
  final Color greyinput = const Color(0xFFC6CEDD);
  final Color cursorColorLightMode = const Color(0xFF707070);
  final Color cursorColorDarkMode = const Color(0xFFB6B6B6); //xxx

  final Color success = const Color(0xFF76C989);
  final Color successDark = const Color(0xFF76C989); //xxx
  final Color error = const Color(0xFFF45151);
  final Color errorDark = const Color(0xFFF45151); //xxx
  final Color golden = const Color(0xFFFFED27);
  final Color goldenDark = const Color(0xFFFFD629);
  final Color darkRed = const Color(0xFFB31E1E);

  //TODO: Add lightGreen to app_theme_light
  Color onboardListTileLeading(bool isSelected, ThemeData theme) {
    return isSelected ? Colors.white : theme.primaryColor;
  }

  Color onboardGrid(bool isSelected, ThemeData theme) {
    return isSelected ? theme.primaryColor : theme.scaffoldBackgroundColor;
  }
}
