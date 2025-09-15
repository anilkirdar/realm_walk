import 'package:flutter/material.dart';

import '../../../constants/app/app_const.dart';
import '../app_color_scheme.dart';

class TextThemeLight {
  static TextThemeLight? _instance;

  static TextThemeLight get instance {
    return _instance ??= TextThemeLight._init();
  }

  final AppColorScheme _appColorScheme = AppColorScheme.instance;

  TextThemeLight._init();

  TextStyle get bodyLarge => TextStyle(
    fontSize: 16,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w500,
    fontFamily: AppConst.poppins,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w500,
    fontFamily: AppConst.poppins,
  );

  TextStyle get titleMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.primary,
    fontWeight: FontWeight.w400,
    fontFamily: AppConst.poppins,
  );

  TextStyle get titleSmall => TextStyle(
    fontSize: 12,
    color: _appColorScheme.primary,
    fontWeight: FontWeight.w400,
    fontFamily: AppConst.poppins,
  );

  TextStyle get displayLarge => const TextStyle();

  TextStyle get displayMedium => TextStyle(color: _appColorScheme.white);

  TextStyle get displaySmall => TextStyle(
    fontSize: 36,
    color: _appColorScheme.primary,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headlineMedium => TextStyle(
    fontSize: 32,
    color: _appColorScheme.primary,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headlineSmall => TextStyle(
    fontSize: 26,
    color: _appColorScheme.secondary,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get titleLarge => TextStyle(
    fontSize: 21,
    color: _appColorScheme.secondary,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get labelLarge => TextStyle(
    fontSize: 12,
    color: _appColorScheme.primary,
    fontFamily: AppConst.poppins,
  );
}
