import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app/app_const.dart';
import '../../../constants/utils/ui_constants/font_size_const.dart';
import '../../../constants/utils/ui_constants/radius_const.dart';
import '../../../constants/utils/ui_constants/size_const.dart';
import '../../config/config.dart';
import '../app_theme.dart';
import 'dark_theme_interface.dart';

class AppThemeDark extends AppTheme with IDarkTheme {
  static AppThemeDark? _instance;

  static AppThemeDark get instance {
    return _instance ??= AppThemeDark._init();
  }

  AppThemeDark._init();

  Color gecisColor = Colors.black;

  @override
  ThemeData get theme => ThemeData(
    ///Text Theme
    textTheme: TextTheme(
      bodyLarge: textTheme.bodyLarge,
      bodyMedium: textTheme.bodyMedium,
      titleMedium: textTheme.titleMedium,
      titleSmall: textTheme.titleSmall,
      displayLarge: textTheme.displayLarge,
      displayMedium: textTheme.displayMedium,
      displaySmall: textTheme.displaySmall,
      headlineMedium: textTheme.headlineMedium,
      headlineSmall: textTheme.headlineSmall,
      titleLarge: textTheme.titleLarge,
      labelLarge: textTheme.labelLarge,
    ),
    primaryTextTheme: TextTheme(
      bodyLarge: primaryTextTheme.bodyLarge,
      bodyMedium: primaryTextTheme.bodyMedium,
      titleMedium: primaryTextTheme.titleMedium,
      titleSmall: primaryTextTheme.titleSmall,
      displayLarge: primaryTextTheme.displayLarge,
      displayMedium: primaryTextTheme.displayMedium,
      displaySmall: primaryTextTheme.displaySmall,
      headlineMedium: primaryTextTheme.headlineMedium,
      headlineSmall: primaryTextTheme.headlineSmall,
      titleLarge: primaryTextTheme.titleLarge,
      labelLarge: primaryTextTheme.labelLarge,
    ),

    /// GENERAL CONFIGURATION
    applyElevationOverlayColor: false,
    cupertinoOverrideTheme: _noDefaultCupertinoThemeData,
    inputDecorationTheme: _inputDecorationTheme,
    pageTransitionsTheme: _pageTransitionsTheme,
    platform:
        Config.instance.isAndroid ? TargetPlatform.android : TargetPlatform.iOS,
    splashFactory: NoSplash.splashFactory,
    useMaterial3: true,

    /// COLOR
    // bottomAppBarColor: Colors.blue,
    brightness: Brightness.dark,
    // canvasColor: Colors.white,
    // cardColor: Colors.red
    // Color? colorSchemeSeed,
    // Color? dialogBackgroundColor,
    // disabledColor: ColorConst.lightGrey,
    dividerColor: colorScheme.grey1,
    // Color? focusColor,
    // Color? highlightColor,
    hintColor: colorScheme.grey1,
    // Color? hoverColor,
    // indicatorColor:Colors.red,
    primaryColor: colorScheme.primary,

    ///TODO: check this color
    primaryColorDark: colorScheme.error,
    // Color? primaryColorLight,
    // MaterialColor? primarySwatch,
    scaffoldBackgroundColor: colorScheme.backgroundDark,
    // Color? secondaryHeaderColor,
    // Color? selectedRowColor,
    shadowColor: colorScheme.shadowColorDark,
    splashColor: Colors.transparent,
    unselectedWidgetColor: colorScheme.grey,

    /// TYPOGRAPHY & ICONOGRAPHY
    fontFamily: AppConst.poppins,
    iconTheme: _iconThemeData,
    primaryIconTheme: _primaryIconThemeData,
    // typography:Typography(),

    /// COMPONENT Themes
    appBarTheme: _appBarTheme,
    scrollbarTheme: _scrollbarThemeData,
    bottomNavigationBarTheme: _bottomNavigationBarThemeData,
    // bannerTheme: MaterialBannerThemeData(),
    // BottomSheetThemeData? bottomSheetTheme,
    // ButtonBarThemeData? buttonBarTheme,
    // ButtonThemeData? buttonTheme,
    cardTheme: _cardTheme,
    checkboxTheme: _checkboxThemeData,

    ///This is from dart fix
    // checkboxTheme: _checkboxThemeData.copyWith(
    //   fillColor: MaterialStateProperty.resolveWith<Color?>(
    //       (Set<MaterialState> states) {
    //     if (states.contains(MaterialState.disabled)) {
    //       return null;
    //     }
    //     if (states.contains(MaterialState.selected)) {
    //       return Colors.white;
    //     }
    //     return null;
    //   }),
    // ),
    // ChipThemeData? chipTheme,
    // DataTableThemeData? dataTableTheme,
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: RadiusConst.smallRectangular),
    ),
    dividerTheme: DividerThemeData(thickness: 1, color: colorScheme.grey1),
    // DrawerThemeData? drawerTheme,
    elevatedButtonTheme: _elevatedButtonThemeData,
    // ExpansionTileThemeData? expansionTileTheme,
    // FloatingActionButtonThemeData? floatingActionButtonTheme,
    listTileTheme: _listTileThemeData,
    // NavigationBarThemeData? navigationBarTheme,
    // NavigationRailThemeData? navigationRailTheme,
    // OutlinedButtonThemeData? outlinedButtonTheme,
    // PopupMenuThemeData? popupMenuTheme,
    progressIndicatorTheme: _progressIndicatorThemeData,
    // RadioThemeData? radioTheme,
    // SliderThemeData? sliderTheme,
    // SnackBarThemeData? snackBarTheme,
    // SwitchThemeData? switchTheme,
    tabBarTheme: _tabBarTheme,
    // TextButtonThemeData? textButtonTheme,
    textSelectionTheme: _textSelectionThemeData,
    // TimePickerThemeData? timePickerTheme,
    toggleButtonsTheme: _toggleButtonsThemeData,

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        return colorScheme.white;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return Colors.green;
        }
        return colorScheme.darkGrey;
      }),
    ),

    colorScheme: _colorScheme,
    // TooltipThemeData? tooltipTheme,    ///Text Themes
  );

  ///  _____________________ GETTERS _____________________  ///
  ToggleButtonsThemeData get _toggleButtonsThemeData =>
      const ToggleButtonsThemeData(fillColor: Colors.white);

  IconThemeData get _primaryIconThemeData =>
      IconThemeData(color: colorScheme.white);

  IconThemeData get _iconThemeData => IconThemeData(color: colorScheme.grey1);

  PageTransitionsTheme get _pageTransitionsTheme {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        // TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(iconColor: colorScheme.darkGrey);
  }

  NoDefaultCupertinoThemeData get _noDefaultCupertinoThemeData {
    return NoDefaultCupertinoThemeData(
      scaffoldBackgroundColor: colorScheme.backgroundDark,
      brightness: Brightness.dark,
    );
  }

  ProgressIndicatorThemeData get _progressIndicatorThemeData =>
      ProgressIndicatorThemeData(color: colorScheme.grey);

  TextSelectionThemeData get _textSelectionThemeData {
    return TextSelectionThemeData(cursorColor: colorScheme.cursorColorDarkMode);
  }

  TabBarThemeData get _tabBarTheme {
    return TabBarThemeData(
      labelStyle: TextStyle(
        color: colorScheme.white,
        fontFamily: AppConst.poppins,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        color: colorScheme.grey,
        fontFamily: AppConst.poppins,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  ListTileThemeData get _listTileThemeData {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: RadiusConst.listTile),
      selectedTileColor: colorScheme.primary,
      selectedColor: colorScheme.white,
      style: ListTileStyle.drawer,
      enableFeedback: false,
      textColor: colorScheme.secondary,
    );
  }

  ElevatedButtonThemeData get _elevatedButtonThemeData {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primaryDark,
        elevation: 1,
        shadowColor: colorScheme.shadowColorElevatedButton,
        disabledBackgroundColor: colorScheme.darkGrey,
        visualDensity: VisualDensity.comfortable,
        minimumSize: Size(
          SizeConst.elevatedButtonMinWidth,
          SizeConst.elevatedButtonMediumHeight,
        ),
        maximumSize: Size(
          SizeConst.elevatedButtonMinWidth,
          SizeConst.elevatedButtonMaxHeight,
        ),
        // fixedSize: const Size(300, 60),
        shape: RoundedRectangleBorder(borderRadius: RadiusConst.elevatedButton),
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          color: colorScheme.primary,
          fontFamily: AppConst.poppins,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  CheckboxThemeData get _checkboxThemeData {
    return CheckboxThemeData(
      overlayColor: MaterialStatePropertyAll(colorScheme.primary),
      fillColor: MaterialStatePropertyAll(colorScheme.primary),
      shape: RoundedRectangleBorder(
        borderRadius: RadiusConst.smallSquaredButton,
      ),
    );
  }

  CardThemeData get _cardTheme =>
      CardThemeData(shadowColor: colorScheme.grey1, color: colorScheme.error);

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colorScheme.bottomNavBarDark,
      selectedIconTheme: IconThemeData(color: colorScheme.white),
      unselectedIconTheme: IconThemeData(color: colorScheme.grey1Dark),
      selectedItemColor: colorScheme.grey1Dark,
      unselectedItemColor: colorScheme.grey1Dark,
      selectedLabelStyle: TextStyle(
        fontSize: FontSizeConst.smallest,
        fontFamily: AppConst.poppins,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        color: colorScheme.white,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: FontSizeConst.smallest,
        fontFamily: AppConst.poppins,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
      ),
      elevation: 0,
    );
  }

  ScrollbarThemeData get _scrollbarThemeData {
    return const ScrollbarThemeData(radius: RadiusConst.scrollBar);
  }

  AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: colorScheme.backgroundDark,
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: colorScheme.white,
      fontWeight: FontWeight.w700,
      fontFamily: AppConst.poppins,
    ),
    actionsIconTheme: IconThemeData(color: colorScheme.white),
    iconTheme: IconThemeData(color: colorScheme.white),
  );

  ColorScheme get _colorScheme => ColorScheme(
    brightness: Brightness.dark,
    background: Colors.white,
    onBackground: colorScheme.white,
    primary: colorScheme.primaryDark,
    onPrimary: Colors.white,
    secondary: colorScheme.secondaryDark,
    onSecondary: const Color(0xFF3F3F3F),
    surface: Colors.red,
    onSurface: colorScheme.white,
    error: colorScheme.errorDark,
    onError: Colors.white,

    //   ///Optional
    //   // errorContainer: Colors.white,
    inversePrimary: Colors.white,
    //   // inverseSurface: Colors.white,
    //   // onErrorContainer: Colors.white,
    //   // onInverseSurface: Colors.white,
    onPrimaryContainer: colorScheme.grey,
    onSecondaryContainer: Color(0xFFF6F6F6),
    //   // onSurfaceVariant: Colors.white,
    // onTertiary: Colors.white,
    //   // onTertiaryContainer: Colors.white,
    //   // outline: Colors.white,
    //   // primaryContainer: Colors.white,
    //   // primaryVariant: Colors.white,
    secondaryContainer: colorScheme.successDark,
    shadow: colorScheme.secondary,
    surfaceTint: Colors.white,
    surfaceVariant: Colors.white,
    tertiary: Colors.white,
    tertiaryContainer: Colors.white,
  );
}
