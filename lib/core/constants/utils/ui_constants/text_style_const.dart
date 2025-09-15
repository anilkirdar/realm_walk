import 'package:flutter/material.dart';

import '../../../init/theme/app_color_scheme.dart';
import '../../app/app_const.dart';
import 'font_size_const.dart';

class TextStyleConst {
  static TextStyleConst? _instance;

  static TextStyleConst get instance {
    return _instance ??= TextStyleConst._init();
  }

  TextStyleConst._init();

  TextStyle generalTextStyle1() {
    return TextStyle(
      fontSize: FontSizeConst.big,
      fontWeight: FontWeight.w600,
      color: AppColorScheme.instance.black,
      fontFamily: AppConst.poppins,
      height: 1,
    );
  }

  TextStyle tabbarStyle() {
    return TextStyle(
      fontSize: FontSizeConst.small,
      fontWeight: FontWeight.w700,
      color: AppColorScheme.instance.white,
      fontFamily: AppConst.poppins,
    );
  }

  TextStyle splashTitle() {
    return TextStyle(
      fontSize: FontSizeConst.huge,
      fontWeight: FontWeight.w700,
      color: AppColorScheme.instance.white,
      fontFamily: AppConst.poppins,
      height: 1,
    );
  }

  TextStyle splashSubtitle() {
    return TextStyle(
      fontSize: FontSizeConst.small,
      fontWeight: FontWeight.w600,
      color: AppColorScheme.instance.white,
      fontFamily: AppConst.poppins,
      height: 1,
    );
  }

  TextStyle onboardTitle() {
    return TextStyle(
      fontSize: FontSizeConst.biggest1,
      fontWeight: FontWeight.w700,
      color: AppColorScheme.instance.primary,
      fontFamily: AppConst.poppins,
      height: 1,
    );
  }

  TextStyle onboardSubtitle() {
    return TextStyle(
      fontSize: FontSizeConst.small,
      fontWeight: FontWeight.w400,
      color: AppColorScheme.instance.black,
      fontFamily: AppConst.poppins,
      height: 1,
    );
  }

  TextStyle onboardTextLink() {
    return TextStyle(
      fontFamily: AppConst.poppins,
      fontSize: FontSizeConst.small,
      fontWeight: FontWeight.w600,
      color: AppColorScheme.instance.primary,
    );
  }
}
