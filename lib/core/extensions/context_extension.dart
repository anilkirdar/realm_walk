import 'package:universal_io/io.dart';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../constants/responsibilities_constant.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Color get randomColor => Colors.primaries[Random().nextInt(17)];

  Container get randomColorContainer =>
      Container(height: 20, width: double.infinity, color: randomColor);

  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;

  double get keyboardPadding => MediaQuery.of(this).viewInsets.bottom;

  Brightness get appBrightness => MediaQuery.of(this).platformBrightness;

  double get textScaleFactor =>
      MediaQuery.of(
        this,
      ).textScaleFactor; //TODO investigate this code and implement
      
  S get s => S.of(this);

  String get sLanguageCode => Localizations.localeOf(this).languageCode;
}

//Check device operating system  with context value
extension DeviceOSExtension on BuildContext {
  bool get isAndroidDevice => Platform.isAndroid;

  bool get isIOSDevice => Platform.isIOS;

  ///Since we are using only Android and
  ///iOS the bottom onces are commented.
  ///Maybe we can use them in the future
  // bool get isWindowsDevice => Platform.isWindows;
  // bool get isLinuxDevice => Platform.isLinux;
  // bool get isMacOSDevice => Platform.isMacOS;
}

extension MediQueryExtension on BuildContext {
  double get statusBarHeight => mediaQuery.padding.top;

  double get navigationBarHeight => mediaQuery.padding.bottom;

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  double get lowValueHeight => height * 0.01;

  double get normalValueHeight => height * 0.02;

  double get mediumValueHeight => height * 0.04;

  double get highValueHeight => height * 0.1;

  double get lowValueWidth => width * 0.01;

  double get normalValueWidth => width * 0.02;

  double get mediumValueWidth => width * 0.06;

  double get highValueWidth => width * 0.1;

  double get highestValueWidth => width * 0.18;

  double get safeHeight =>
      height -
      MediaQuery.paddingOf(this).bottom -
      MediaQuery.paddingOf(this).top;

  double dynamicWidth(double val) => width * val;

  double dynamicHeight(double val) => height * val;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  TextTheme get primaryTextTheme => theme.primaryTextTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  ///TODO: Use it everywhere
  TextStyle get buttonStyle1 => theme.primaryTextTheme.labelLarge!;
}

//Device Screen Type By Width(300-600-900)
//Values from https://flutter.dev/docs/development/ui/layout/building-adaptive-apps
extension ContextDeviceTypeExtension on BuildContext {
  bool get isSmallScreen =>
      width >= ResponsibilityConstants.instance.smallScreenSize &&
              width < ResponsibilityConstants.instance.mediumScreenSize
          ? true
          : false;

  bool get isMediumScreen =>
      width >= ResponsibilityConstants.instance.mediumScreenSize &&
              width < ResponsibilityConstants.instance.largeScreenSize
          ? true
          : false;

  bool get isLargeScreen =>
      width >= ResponsibilityConstants.instance.largeScreenSize ? true : false;
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowValueHeight);

  EdgeInsets get paddingNormal => EdgeInsets.all(normalValueHeight);

  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValueHeight);

  EdgeInsets get paddingHigh => EdgeInsets.all(highValueHeight);

  EdgeInsets get paddingMainHorizontal =>
      EdgeInsets.symmetric(horizontal: width * 0.06);

  EdgeInsets get paddingMainHorizontal2 =>
      EdgeInsets.symmetric(horizontal: width * 0.054);

  EdgeInsets get paddingMediumHorizontal =>
      EdgeInsets.symmetric(horizontal: width * 0.04);

  EdgeInsets get paddingMainHorizontalLeft =>
      EdgeInsets.only(left: width * 0.06);

  EdgeInsets get paddingMainHorizontalLeft2 =>
      EdgeInsets.only(left: width * 0.054);

  EdgeInsets get paddingMainHorizontalRight =>
      EdgeInsets.only(right: width * 0.06);

  EdgeInsets get horizontalPaddingLow =>
      EdgeInsets.symmetric(horizontal: lowValueWidth);

  EdgeInsets get horizontalPaddingNormal =>
      EdgeInsets.symmetric(horizontal: normalValueWidth);

  EdgeInsets get horizontalPaddingMedium =>
      EdgeInsets.symmetric(horizontal: mediumValueWidth);

  EdgeInsets get horizontalPaddingHigh =>
      EdgeInsets.symmetric(horizontal: highValueWidth);

  EdgeInsets get horizontalPaddingHighest =>
      EdgeInsets.symmetric(horizontal: highestValueWidth);

  EdgeInsets get verticalPaddingLow =>
      EdgeInsets.symmetric(vertical: lowValueHeight);

  EdgeInsets get verticalPaddingNormal =>
      EdgeInsets.symmetric(vertical: normalValueHeight);

  EdgeInsets get verticalPaddingMedium =>
      EdgeInsets.symmetric(vertical: mediumValueHeight);

  EdgeInsets get verticalPaddingHigh =>
      EdgeInsets.symmetric(vertical: highValueHeight);

  EdgeInsets get onlyLeftPaddingLow => EdgeInsets.only(left: lowValueHeight);

  EdgeInsets get onlyLeftPaddingNormal =>
      EdgeInsets.only(left: normalValueHeight);

  EdgeInsets get onlyLeftPaddingMedium =>
      EdgeInsets.only(left: mediumValueHeight);

  EdgeInsets get onlyLeftPaddingHigh => EdgeInsets.only(left: highValueHeight);

  EdgeInsets get onlyRightPaddingLow => EdgeInsets.only(right: lowValueHeight);

  EdgeInsets get onlyRightPaddingNormal =>
      EdgeInsets.only(right: normalValueHeight);

  EdgeInsets get onlyRightPaddingMedium =>
      EdgeInsets.only(right: mediumValueHeight);

  EdgeInsets get onlyRightPaddingHigh =>
      EdgeInsets.only(right: highValueHeight);

  EdgeInsets get onlyBottomPaddingLow =>
      EdgeInsets.only(bottom: lowValueHeight);

  EdgeInsets get onlyBottomPaddingNormal =>
      EdgeInsets.only(bottom: normalValueHeight);

  EdgeInsets get onlyBottomPaddingMedium =>
      EdgeInsets.only(bottom: mediumValueHeight);

  EdgeInsets get onlyBottomPaddingHigh =>
      EdgeInsets.only(bottom: highValueHeight);

  EdgeInsets get onlyTopPaddingLow => EdgeInsets.only(top: lowValueHeight);

  EdgeInsets get onlyTopPaddingNormal =>
      EdgeInsets.only(top: normalValueHeight);

  EdgeInsets get onlyTopPaddingMedium =>
      EdgeInsets.only(top: mediumValueHeight);

  EdgeInsets get onlyTopPaddingHigh => EdgeInsets.only(top: highValueHeight);
}

extension DurationExtension on BuildContext {
  Duration get durationLowest => const Duration(milliseconds: 500);

  Duration get durationLow => const Duration(milliseconds: 1000);

  Duration get durationNormal => const Duration(milliseconds: 1500);

  Duration get durationSlow => const Duration(milliseconds: 2000);

  Duration get durationSlowest => const Duration(milliseconds: 3000);
}
