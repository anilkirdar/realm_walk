import 'package:flutter/material.dart';

import '../../../constants/app/app_const.dart';
import '../app_color_scheme.dart';

class TextThemeDark {
  static TextThemeDark? _instance;

  static TextThemeDark get instance {
    return _instance ??= TextThemeDark._init();
  }

  final AppColorScheme _appColorScheme = AppColorScheme.instance;

  TextThemeDark._init();

  TextStyle get bodyLarge => TextStyle(
    fontSize: 16,
    color: _appColorScheme.secondaryDark,
    fontWeight: FontWeight.w500,
    fontFamily: AppConst.poppins,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.white,
    fontWeight: FontWeight.w500,
    fontFamily: AppConst.poppins,
  );

  TextStyle get titleMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.secondaryDark,
    fontWeight: FontWeight.w400,
    fontFamily: AppConst.poppins,
  );

  TextStyle get titleSmall => TextStyle(
    fontSize: 12,
    color: _appColorScheme.white,
    fontWeight: FontWeight.w400,
    fontFamily: AppConst.poppins,
  );

  TextStyle get displayLarge => TextStyle();

  TextStyle get displayMedium => TextStyle(color: _appColorScheme.white);

  TextStyle get displaySmall => TextStyle(
    fontSize: 36,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.w900,
  );

  TextStyle get headlineMedium => TextStyle(
    fontSize: 32,
    color: _appColorScheme.primaryDark,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headlineSmall => TextStyle(
    fontSize: 26,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get titleLarge => TextStyle(
    fontSize: 21,
    color: _appColorScheme.secondaryDark,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get labelLarge => TextStyle(
    fontSize: 12,

    ///TODO find where it is used and set fontWeight
    color: _appColorScheme.primaryDark,
    fontFamily: AppConst.poppins,
  );
}
