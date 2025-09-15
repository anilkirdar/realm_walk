import 'package:flutter/material.dart';

import '../../../constants/app/app_const.dart';
import '../app_color_scheme.dart';

class PrimaryTextThemeDark {
  static PrimaryTextThemeDark? _instance;

  static PrimaryTextThemeDark get instance {
    return _instance ??= PrimaryTextThemeDark._init();
  }

  final AppColorScheme _appColorScheme = AppColorScheme.instance;

  PrimaryTextThemeDark._init();

  TextStyle get bodyLarge => TextStyle(
    fontSize: 18,
    color: _appColorScheme.white,
    fontWeight: FontWeight.w500,
  );

  TextStyle get bodyMedium => TextStyle(
    fontSize: 16,
    color: _appColorScheme.white,
    fontWeight: FontWeight.w400,
  );

  TextStyle get titleMedium => TextStyle(
    fontSize: 14,
    color: _appColorScheme.white,
    fontWeight: FontWeight.w400,
  );

  TextStyle get titleSmall => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _appColorScheme.white,
  );

  TextStyle get displayLarge => const TextStyle();

  TextStyle get displayMedium => const TextStyle();

  TextStyle get displaySmall => const TextStyle();

  TextStyle get headlineMedium => TextStyle(
    fontSize: 34,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headlineSmall => const TextStyle();

  TextStyle get titleLarge => TextStyle(
    fontSize: 21,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.bold,
  );

  ///Cupertino Button style bcz it doesn't support ElevatedButton's textstyle
  TextStyle get labelLarge => TextStyle(
    fontSize: 18,
    color: _appColorScheme.white,
    fontFamily: AppConst.poppins,
    fontWeight: FontWeight.w600,
  );
}
