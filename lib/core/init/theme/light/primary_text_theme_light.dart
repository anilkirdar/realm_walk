import 'package:flutter/material.dart';

import '../../../constants/app/app_const.dart';
import '../app_color_scheme.dart';

class PrimaryTextThemeLight {
  static PrimaryTextThemeLight? _instance;

  static PrimaryTextThemeLight get instance {
    return _instance ??= PrimaryTextThemeLight._init();
  }

  final AppColorScheme _appColorScheme = AppColorScheme.instance;

  PrimaryTextThemeLight._init();

  TextStyle get bodyLarge => TextStyle(
    fontSize: 18,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w500,
    fontFamily: AppConst.poppins,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: 16,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w400,
  );

  TextStyle get titleMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w400,
  );

  TextStyle get titleSmall => TextStyle(
    fontSize: 12,
    color: _appColorScheme.secondary,
    fontWeight: FontWeight.w400,
  );

  TextStyle get displayLarge => const TextStyle();

  TextStyle get displayMedium => const TextStyle();

  TextStyle get displaySmall => const TextStyle();

  TextStyle get headlineMedium => TextStyle(
    fontSize: 34,
    color: _appColorScheme.secondary,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headlineSmall => TextStyle(
    fontSize: 30,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get titleLarge => TextStyle(
    fontSize: 21,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get labelLarge => TextStyle(
    fontSize: 18,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.w600,
  );
}
