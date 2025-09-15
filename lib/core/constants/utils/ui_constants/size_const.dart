import 'package:flutter/widgets.dart';

import '../../../init/config/config.dart';

class SizeConst {
  /// sample width of Iphone Max = 375
  static const double sampleWidth = 375;
  static const double sampleHeight = 812;

  ///Width Factor
  static double widthFactor = 1;

  ///Height Factor
  static double heightFactor = 1;

  ///
  static const double appLogoSize = 48;

  ///
  static const double appBarHeight = 50;
  static const double appBarIconHeight = 31;

  ///Icons
  static double bigIconSize = 47 * widthFactor;
  static double bigIconHeightConst = 48;
  static const double bigIconSize2 = 35;
  static const double checkIconSize = 16;
  static const double missionLockIconSizeHeight = 19;

  static const double mediumIconSizeHeight = 29.25;
  static const double mediumIconSizeWidth = 32;
  static double mediumIconSizeResponsive = 32 * widthFactor;
  static const double medium1IconSize = 40;
  static const double mediumIconSizeBoxWidth = 40;

  static const double smallIconSizeBoxHeight = 50;
  static const double smallIconSizeBoxWidth = 28;
  static const double smallIconSizeBoxWidth2 = 22;
  static const double smallIconSize2 = 25;

  static const double smallestIconSize = 20;
  static const double smallest2IconSize = 15;
  static const double smallIconSize = 17;

  static const double tinyIconSize = 11;
  static const double tiny2IconSize = 17;

  ///Stack icons
  static const double stackIconSmall = 22;
  static const double stackIconMedium = 26;
  static const double stackIconBig = 36;

  ///BottomNavBar Size
  static double bnbHeight = Config.instance.isAndroid ? 66 : 66;

  ///Containers
  // static const double feedbackContainerWidth = 300;
  static const double feedbackTextContainerHeight = 60;
  static double feedbackButtonHeight = 63 * widthFactor;
  static double feedbackButtonWidth = 70 * widthFactor;

  /// BORDERS
  static const double borderAvatar = 18;

  ///IMAGES
  static const double imageSmall = 40;
  static const double imageSmallProfile = 72;

  static const double imageSmall1 = 50;
  static const double imageMedium1 = 89;
  static double podiumRanking = 66 * heightFactorMax1;
  static double podiumRankingFirst = 78 * heightFactorMax1;
  static const double imageBig = 100;
  static const double imageBiggest = 190;

  ///User Avatar
  static const double userImageSmall = 38;
  static const double userImageMedium = 60;
  static const double userImageMedium2 = 58;
  static const double userImageMedium1 = 66;
  static const double userImageBig = 96;

  ///Inputs
  static const double searchFormFieldHeight = 50;
  static const double couponFormFieldHeight = 48;
  static double formFieldHeight = 42;
  static const double cursorHeight = 26;
  static const double accountEditBoxHeight = 50;
  static const double accountBioEditBoxHeight = 140;

  ///BUTTONS
  static const double elevatedButtonSmall1Height = 24;
  static const double elevatedButtonSmall3Height = 28;
  static const double elevatedButtonSmall4Height = 30;
  static const double elevatedButtonSmall5Height = 32;

  ///
  static const double elevatedButtonSmallHeight = 34;
  static const double elevatedButtonSmall2Height = 42;
  static double elevatedButtonMediumHeight = 52;
  static double elevatedButtonBigHeight = 61;
  static double elevatedButtonSmallWidth = 155;
  static double elevatedButtonMaxHeight = 80 * heightFactor;
  static const double elevatedButtonMinWidth = 200;
  static const double elevatedButtonMaxWidth = 500;
  static const double outlinedButtonMaterialHeight = 45;
  static const double textButtonHeight = 20;
  static const double smallButtonWidth = 88;
  static const double small1ButtonWidth = 98;
  static const double mediumButtonWidth = 100;
  static const double medium1ButtonWidth = 105;
  static const double medium2ButtonWidth = 110;
  static const double medium4ButtonWidth = 140;
  
  static const double largeButtonWidth = 150;
  static const double large1ButtonWidth = 160;
  static const double waveDialogButtonWidth = 150;

  ///Buttons Auth
  static const double authSocialLoginButtons = 50;
  static const double authSwitchButtonHeight = 40;
  static const double authCheckBoxHeight = 50;
  static const double authPopButtonHeight = 26;
  static const double authPopButtonWidth = 26;
  static const double authTextFieldIconHeight = 15;
  static const double authTextFieldIconWidth = 20;

  ///Onboard
  static const double onBoardBoxSize = 150;
  static const double onBoardTitleSize = 80;
  static const double onBoardFavTopicsSubtitle = 30;
  static const double onBoardTileSubtitle = 32;

  ///
  static const double dotProgressIndicatorRadius = 16;
  static const double dotProgressIndicatorRadiusSmall = 10;
  static const double dotProgressIndicatorBoxHeight = 32;

  ///Mission"
  static double completedMissionHeight = 153 * heightFactor;
  static double jokerPowerChooseCatHeight = 153;
  static const double taskScreenshotItems = 258;
  static const double missionCounterTopHeader = 94;
  static const double missionModeTileHeight = 102;
  static const double missionModeLeftBoxWidth = 70;
  static const double missionModeStatusWidth = 70;
  static const double missionModeStatusHeight = 48;
  static const double missionModeCheckBoxSize = 18.5;
  static const double missionProgressContainer = 81;
  static double addIconSize = 12 * widthFactor;
  static const double modalBottomSheetHeight = 178;
  static const double missionInfoDialogHeight = 250;
  static const double fqShareButtonElementSize = 54;
  static const double globalChallengeAcceptButtonWidth = 88;
  static const double globalChallengeChallengerUserPhoto = 115;
  static const double globalChallengeUserNameWidth = 88;
  static const double fqAppMessageContainerHeight = 75;
  static const double deTitleBarHeight = 44;
  static const double incomingCallBoxHeight = 96;

  static const double notificationOverlayHeight = 160;
  static const double notificationOverlayTopBox = 60;
  static const double notificationOverlayBottomBox = 100;
  static const double unreadNotificationCircleSize = 16;

  ///Hallway
  static const double practiceHeaderHeight = 108;
  static const double practiceGoalWidth = 105;
  static const double hallwayCallButton = 90;
  static const double waveOverlayHeight = 200;
  static const double waveLabelBoxSize = 38;

  ///Paywall

  static double paywallPlanHeightSelected = 81;
  static double paywallPlanHeightUnselected = 73;

  static double paywallIllustrationHeight = 190 * heightFactor;

  static const double paywallLeftBoxWidth = 48;

  ///LockView

  static double lockedViewTopBoxDescription = 69;
  static double lockedViewTopBoxDescriptionBig = 93;

  ///
  static double callViewButton = 60 * widthFactor;
  static double callViewButtonCard = 80;
  static double unblockTextWidth = 70;

  ///CircularProgressIndicator
  static const double circularProgressIndicatorWidth = 2;
  static double circularCounter = 21 * heightFactor;

  ///GridView
  static const double interestsGridViewHeight = 132;
  static const double interestsGridTileHeight = 32;

  ///LIST TILE
  static const double listTileSizeHallway = 80;
  static const double listTileSizeRanking = 64;
  static const double listTileBlockedUsers = 60;
  static double listTileProfileFeedbackHeight = 57 + 12;
  static const double onBoardPracticeIconSize = 29;
  static double listTileFeedbackHeight = 34;

  /// Tabs
  static const double rankingTabBarHeight = 52;
  static const double rankingTabBarItemHeight = 34;

  /// TOAST

  static const double toastHeight = 25;

  /// -----------------     EMPTY     ----------------- ///
  static const double emptyOnBoardAgeGender = 20;

  ///
  static double getImageSize(bool? isMedium) {
    return (isMedium == null
        ? imageSmall
        : (isMedium ? imageMedium1 : imageBig));
  }

  static double getUserImageSize(bool? isMedium) {
    return (isMedium == null
        ? imageSmall
        : (isMedium ? userImageMedium : userImageBig));
  }

  static double get heightFactorMax1 => heightFactor > 1 ? 1 : heightFactor;

  static double get widthFactorMax1 => widthFactor > 1 ? 1 : widthFactor;

  static SizedBox dynamicBoxHeight(double size) =>
      SizedBox(height: size * heightFactor);

  static SizedBox dynamicBoxWidth(double size) =>
      SizedBox(width: size * widthFactor);

  static double dynamicHeight(double size) =>
      heightFactor > 1.3 ? size : size * heightFactor;

  static double dynamicWidth(double size) =>
      widthFactor > 1.4 ? size : size * widthFactor;
}
