import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/utils/ui_constants/radius_const.dart';
import '../../../init/notifier/theme_notifier.dart';
import '../../../init/theme/app_color_scheme.dart';

class BoxDecorationConst {
  static BoxDecorationConst? _instance;
  late final BoxShadowConst _boxShadowConst;

  static BoxDecorationConst get instance {
    return _instance ??= BoxDecorationConst._init();
  }

  BoxDecorationConst._init() {
    _boxShadowConst = BoxShadowConst.instance;
  }

  BoxDecoration bottomNavBar(ThemeData theme) {
    return BoxDecoration(
      borderRadius: RadiusConst.bottomNavBar,
      boxShadow: [_boxShadowConst.bottomNavBar],
    );
  }

  BoxDecoration primaryColorSmallRadius(ThemeData theme, BuildContext context) {
    return BoxDecoration(
      color:
          Provider.of<ThemeNotifier>(context).getCustomTheme.purpleToDarkGrey,
      borderRadius: RadiusConst.smallRectangular,
    );
  }

  BoxDecoration profileNotificationNumber(ThemeData theme) {
    return BoxDecoration(
        color: AppColorScheme.instance.white,
        shape: BoxShape.circle,
        boxShadow: [_boxShadowConst.dropShadow002]);
  }

  BoxDecoration notificationTopBox(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondary,
      borderRadius: RadiusConst.topNotificationBox,
    );
  }

  BoxDecoration notificationBottomBox(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor,
      borderRadius: RadiusConst.bottomNotificationBox,
    );
  }

  BoxDecoration rankingTabBar(ThemeData theme, BuildContext context) {
    return BoxDecoration(
      color:
          Provider.of<ThemeNotifier>(context).getCustomTheme.purpleToDarkerGrey,
      borderRadius: RadiusConst.mediumRectangular,
    );
  }

  BoxDecoration rankIcon(ThemeData theme) {
    return BoxDecoration(
        color: theme.primaryColor,
        borderRadius: RadiusConst.circular5,
        border: Border.all(
            color: theme.colorScheme.inversePrimary,
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside));
  }

  BoxDecoration rankingNonButton(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondary,
      borderRadius: RadiusConst.bigRectangular,
    );
  }

  BoxDecoration practiceTimeCard(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondary,
      borderRadius: RadiusConst.medium2Rectangular,
    );
  }

  BoxDecoration missionProgressHeader(ThemeData theme) {
    /// the difference between this and card5 is in borderRadius
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.smallRectangular,
    );
  }

  BoxDecoration primaryBigRectangular(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor,
      borderRadius: RadiusConst.bigRectangular,
    );
  }

  BoxDecoration hallwayPracticeGoal(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.topLeftBottomRightBigRadius,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration discountDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.topRightBottomLeftBigRadius,
    );
  }

  BoxDecoration waveOverlayBox(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor,
      borderRadius: RadiusConst.listTile,
      border: Border.all(
        color: AppColorScheme.instance.cursorColorLightMode,
        width: 1,
      ),
    );
  }

  BoxDecoration waveLabelBox(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: RadiusConst.topLeftBottomRightListTile,
        boxShadow: [_boxShadowConst.dropShadow444]);
  }

  BoxDecoration rankingTabBarItem(ThemeData theme, bool isSelected) {
    return BoxDecoration(
      color: isSelected ? theme.colorScheme.secondary : theme.primaryColor,
      borderRadius: RadiusConst.mediumRectangular,
    );
  }

  BoxDecoration rankingListTileShimmer(ThemeData theme) {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: RadiusConst.bigRectangular,
    );
  }

  BoxDecoration paywallListTileShimmer(ThemeData theme, bool isSelected) {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: isSelected
          ? RadiusConst.paywallCardSelected
          : RadiusConst.paywallCard,
    );
  }

  BoxDecoration podiumItem(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor.withOpacity(0.75),
      borderRadius: RadiusConst.smallRectangular,
    );
  }

  BoxDecoration newUserLabel(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(7),
        bottomRight: Radius.circular(7),
        topRight: Radius.circular(7),
      ),
    );
  }

  BoxDecoration missionFileListTile(ThemeData theme) {
    return BoxDecoration(
      color: theme.primaryColor,
    );
  }

  BoxDecoration podiumUserAvatar(ThemeData theme) {
    return BoxDecoration(
        borderRadius: RadiusConst.circular50,
        border: Border.all(
            color: theme.primaryColor,
            width: 3,
            strokeAlign: BorderSide.strokeAlignOutside));
  }

  BoxDecoration userAvatar(ThemeData theme) {
    return BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorScheme.instance.white,
        border: Border.all(
          color: theme.colorScheme.onSurface,
          width: 1,
        ));
  }

  BoxDecoration waveUserAvatar(ThemeData theme) {
    return BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: AppColorScheme.instance.white,
          width: 2,
        ));
  }

  BoxDecoration waveUserListAvatar(ThemeData theme) {
    return BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorScheme.instance.white,
        border: Border.all(
          color: AppColorScheme.instance.goldenDark,
          width: 2,
        ));
  }

  BoxDecoration callerAvatar(ThemeData theme) {
    return BoxDecoration(
        borderRadius: RadiusConst.circular50,
        border: Border.all(
            color: theme.colorScheme.onPrimary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside));
  }

  /// Color, BorderRadius
  BoxDecoration searchField(ThemeData theme, BuildContext context) {
    return BoxDecoration(
        color: Provider.of<ThemeNotifier>(context)
            .getCustomTheme
            .lightGreyToDarkerGrey,
        borderRadius: RadiusConst.listTile);
  }

  BoxDecoration primaryBackground(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.primary, borderRadius: RadiusConst.listTile);
  }

  BoxDecoration missionDescriptionBox(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: RadiusConst.leftBottomExcludedListTile);
  }

  BoxDecoration missionHelperDialog(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: RadiusConst.listTile);
  }

  BoxDecoration secondaryContainerBackground(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.topLeftBottomRightListTile,
    );
  }

  BoxDecoration missionDescriptionInfoButton(
      ThemeData theme, bool isTopRightBottomLeftBorder,
      {Color? color}) {
    return BoxDecoration(
      color: color ?? theme.colorScheme.secondary,
      borderRadius: isTopRightBottomLeftBorder
          ? RadiusConst.topRightBottomLeftListTile
          : RadiusConst.topLeftBottomRightListTile,
    );
  }

  BoxDecoration closeButton(ThemeData theme) {
    return BoxDecoration(
        color: theme.primaryColor,
        borderRadius: RadiusConst.closeOnCallTranslate,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ]);
  }

  BoxDecoration missionListTile(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: RadiusConst.leftBottomExcludedBigRadius,
    );
  }

  BoxDecoration missionListTileTrailing(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.topLeftBottomRightBigRadius,
    );
  }

  BoxDecoration missionListTileStatus(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: RadiusConst.topRightBottomLeftBigRadius,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ]);
  }

  BoxDecoration lockedMissionMode(ThemeData theme) {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: RadiusConst.bigRectangular,
    );
  }

  BoxDecoration feedbackText(ThemeData theme) {
    return BoxDecoration(
        borderRadius: RadiusConst.bigRectangular1,
        border: Border.all(color: theme.dividerColor, width: 1));
  }

  ///Border, BorderRadius
  BoxDecoration onBoardCard(ThemeData theme) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: theme.cardTheme.shadowColor!, width: 2));
  }

  ///Color, BorderRadius, BoxShadow
  BoxDecoration smallIconButton(ThemeData theme, BuildContext context) {
    return BoxDecoration(
      color: Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToDarkGrey,
      borderRadius: RadiusConst.smallSquaredButton,
    );
  }

  BoxDecoration rankingListTile(ThemeData theme) {
    return BoxDecoration(
        color: theme.colorScheme.onSecondary,
        borderRadius: RadiusConst.bigRectangular,
        boxShadow: [_boxShadowConst.dropShadow036]);
  }

  BoxDecoration discountLitTile(ThemeData theme) {
    return BoxDecoration(
        color: AppColorScheme.instance.secondary,
        borderRadius: const BorderRadius.only(
            topRight: RadiusConst.bigRectangularRadius,
            topLeft: RadiusConst.bigRectangularRadius),
        boxShadow: [_boxShadowConst.dropShadow036]);
  }

  BoxDecoration icon1(ThemeData theme) {
    return BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: RadiusConst.circular25,
        boxShadow: [_boxShadowConst.dropShadow036]);
  }

  BoxDecoration card2(ThemeData theme) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: RadiusConst.mediumRectangular,
      boxShadow: [_boxShadowConst.dropShadow026],
    );
  }

  BoxDecoration card3(ThemeData theme, BuildContext context) {
    return BoxDecoration(
      color: theme.colorScheme.onSecondaryContainer,
      borderRadius: RadiusConst.smallRectangular,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration card5(ThemeData theme) {
    return BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: RadiusConst.smallestRectangular,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration card6(ThemeData theme) {
    /// the difference between this and card5 is in borderRadius
    return BoxDecoration(
      color: Colors.white,
      borderRadius: RadiusConst.smallRectangular,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration imagePicker(ThemeData theme) {
    /// the difference between this and card5 is in borderRadius
    return BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: RadiusConst.imagePickerButton,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration onBoardGenderCard(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: RadiusConst.onBoardBox,
      boxShadow: [_boxShadowConst.dropShadow036],
    );
  }

  BoxDecoration onBoardAgePicker(ThemeData theme) {
    return BoxDecoration(
        color: theme.cardColor,
        borderRadius: RadiusConst.onBoardBox,
        boxShadow: [_boxShadowConst.dropShadow036]);
  }

  ///Color, Border, BorderRadius

  BoxDecoration card4(ThemeData theme) {
    return BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: RadiusConst.listTile,
      border:
          Border.all(width: 1, color: theme.colorScheme.onSecondaryContainer),
    );
  }

  BoxDecoration onBoardInterests(
      bool isSelected, ThemeData theme, BuildContext context) {
    return BoxDecoration(
        color: AppColorScheme.instance.onboardGrid(isSelected, theme),
        border: Border.all(
            width: 1,
            color: isSelected
                ? Color(0xFF6962CF)
                : Provider.of<ThemeNotifier>(context)
                    .getCustomTheme
                    .purpleToWhite),
        borderRadius: RadiusConst.gridTile);
  }

  BoxDecoration onBoardGender(ThemeData theme, BuildContext context) {
    return BoxDecoration(
        color: theme.colorScheme.onSecondaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
            width: 1,
            color: Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .purpleToWhite));
  }

  BoxDecoration rectangleTextButton(ThemeData theme, BuildContext context) {
    return BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      border: Border.all(
          width: 1,
          color:
              Provider.of<ThemeNotifier>(context).getCustomTheme.purpleToWhite),
      borderRadius: RadiusConst.elevatedButton,
    );
  }

  BoxDecoration profileInterestsGrid(ThemeData theme, BuildContext context) {
    return BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 0,
            blurStyle: BlurStyle.solid,
            offset: Offset(0, 3),
            color: Provider.of<ThemeNotifier>(context).isDark
                ? Colors.white
                : Colors.black.withOpacity(0.25),
          ),
        ],
        color:
            Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToDarkGrey,
        border: Border.all(
            width: 1,
            color: Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .beigeToWhite),
        borderRadius: RadiusConst.gridTile);
  }

  BoxDecoration LogoutInterestsBox(ThemeData theme, BuildContext context) {
    return BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 0,
            blurStyle: BlurStyle.solid,
            offset: const Offset(0, 2),
            color: AppColorScheme.instance.error,
          ),
        ],
        color: Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToBeige,
        border: Border.all(width: 1, color: AppColorScheme.instance.error),
        borderRadius: RadiusConst.gridTile);
  }

  BoxDecoration jokwerPowerGridItem(ThemeData theme, bool isLoading) {
    return BoxDecoration(
        color: isLoading
            ? theme.colorScheme.secondaryContainer
            : theme.scaffoldBackgroundColor,
        border: Border.all(width: 1, color: theme.hintColor),
        borderRadius: RadiusConst.gridTile);
  }

  BoxDecoration missionModeCheckBox(ThemeData theme) {
    return BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(width: 1, color: theme.primaryColor),
        borderRadius: RadiusConst.smallRectangular);
  }

  BoxDecoration checkBox3Decoration(ThemeData theme) {
    return BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: RadiusConst.smallRectangular);
  }

  BoxDecoration couponTextField(ThemeData theme) {
    return BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        border: Border.all(width: 1, color: theme.primaryColor),
        borderRadius: RadiusConst.small3Rectangular);
  }

  BoxDecoration stackTextIcon(ThemeData theme,
      [bool isBordered = false, double borderWidth = 2]) {
    return BoxDecoration(
      color: theme.primaryColor,
      borderRadius: RadiusConst.circular25,
      border: isBordered
          ? Border.all(
              color: theme.colorScheme.onSurface,
              width: borderWidth,
              strokeAlign: BorderSide.strokeAlignOutside)
          : null,
    );
  }

  BoxDecoration paywallSelectedPlan(ThemeData theme, bool isSelected) {
    return BoxDecoration(
      borderRadius: isSelected
          ? RadiusConst.paywallCardSelected
          : RadiusConst.paywallCard,
      boxShadow: isSelected ? [BoxShadowConst.instance.dropShadow036] : [],
      border: Border.all(
        width: isSelected ? 3 : 1,
        color: isSelected
            ? theme.colorScheme.secondaryContainer
            : theme.primaryColor,
      ),
    );
  }

  BoxDecoration paywallPlanCardLeftBox(ThemeData theme, bool isSelected) {
    return BoxDecoration(
        color: isSelected ? theme.colorScheme.secondary : theme.primaryColor,
        borderRadius: RadiusConst.paywallCardLeftBoxSelected);
  }

  BoxDecoration paywallPlanCardLeftBoxBackground(ThemeData theme) {
    return BoxDecoration(
        color: theme.primaryColor,
        borderRadius: RadiusConst.topRightExcludedListTile);
  }

  BoxDecoration paywallSelectedPlanRightBox(ThemeData theme, bool isSelected) {
    return BoxDecoration(
      color: isSelected ? theme.primaryColor : AppColorScheme.instance.white,
      borderRadius: RadiusConst.bigRectangularRadiusRight,
    );
  }

  BoxDecoration paywallFeaturedStar(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(7),
        topRight: Radius.circular(14),
      ),
    );
  }

  BoxDecoration paywallPayLess(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondary,
      borderRadius: RadiusConst.topLeftBottomRightPaywallPayLess,
    );
  }

  BoxDecoration stackTextIcon1(ThemeData theme) {
    return BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: RadiusConst.circular25,
        boxShadow: [_boxShadowConst.dropShadow036]);
  }

  ///

  BoxDecoration opacity03(ThemeData theme) {
    return BoxDecoration(
      boxShadow: [
        _boxShadowConst.opacityShadowBackground(theme, 0.3),
        _boxShadowConst.opacityShadowBackground(theme, 0.6),
      ],
    );
  }

  BoxDecoration opacity05(ThemeData theme) {
    return BoxDecoration(
      boxShadow: [
        _boxShadowConst.opacityShadowBackground(theme, 0.3),
        _boxShadowConst.opacityShadowBackground(theme, 0.4),
        _boxShadowConst.opacityShadowBackground(theme, 0.5),
      ],
    );
  }

  BoxDecoration userProfilePhotoInMissions(ThemeData theme) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: RadiusConst.listTile,
      border: Border.all(width: 1, color: theme.colorScheme.secondary),
    );
  }

  BoxDecoration friendQuestShareButtonElement(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: RadiusConst.bigRectangular1,
    );
  }

  BoxDecoration friendQuestAppMessage(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.error,
      borderRadius: RadiusConst.elevatedButton,
      boxShadow: [
        _boxShadowConst.dropShadow036,
      ],
    );
  }

  BoxDecoration userChallengeAcceptContainer(ThemeData theme) {
    return BoxDecoration(
      color: theme.disabledColor,
      borderRadius: RadiusConst.elevatedButton,
      boxShadow: [
        _boxShadowConst.dropShadow036,
      ],
    );
  }
}

class BoxShadowConst {
  static BoxShadowConst? _instance;
  late final AppColorScheme _colorSchemeLight;

  static BoxShadowConst get instance {
    return _instance ??= BoxShadowConst._init();
  }

  BoxShadowConst._init() {
    _colorSchemeLight = AppColorScheme.instance;
  }

  BoxShadow get bottomNavBar {
    return BoxShadow(
        color: AppColorScheme.instance.primary.withOpacity(0.25),
        offset: const Offset(5, 0),
        blurRadius: 13.0);
  } // static BoxShadow get dropShadow01 {
  //   return BoxShadow(
  //       color: ColorsConst.shadowColorDark,
  //       offset: const Offset(0.0, 1.0),
  //       blurRadius: 6.0);
  // }

  BoxShadow get dropShadow002 {
    return BoxShadow(
        color: _colorSchemeLight.shadowColorDark,
        offset: const Offset(0, 0),
        blurRadius: 2.0);
  }

  BoxShadow get dropShadow026 {
    return BoxShadow(
        color: _colorSchemeLight.shadowColorDark,
        offset: const Offset(0, 2),
        blurRadius: 6.0);
  }

  BoxShadow get dropShadow036 {
    return BoxShadow(
        color: _colorSchemeLight.shadowColorDark,
        offset: const Offset(0.0, 3.0),
        blurRadius: 6.0);
  }

  BoxShadow get dropShadow044 {
    return BoxShadow(
        color: _colorSchemeLight.shadowColorDark,
        offset: const Offset(0, 4),
        blurRadius: 4.0);
  }

  BoxShadow get dropShadow444 {
    return BoxShadow(
        color: _colorSchemeLight.shadowColorDark,
        offset: const Offset(4, 4),
        blurRadius: 4.0);
  }

  BoxShadow opacityShadowBackground(ThemeData theme, double opacity) {
    return BoxShadow(
        color: theme.scaffoldBackgroundColor.withOpacity(opacity),
        blurRadius: 12.0);
  }
}
