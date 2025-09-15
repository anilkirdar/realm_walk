import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../../base/service/base_service.dart';
import '../../../components/toast/toast.dart';
import '../../print_dev.dart';

class AnalyticsManager extends BaseService {
  static AnalyticsManager? _instance;

  static AnalyticsManager get instance {
    return _instance ??= AnalyticsManager._init();
  }

  AnalyticsManager._init();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  get appInstanceId => _analytics.appInstanceId;

  Future<void> onDeviceConversion(String email) async {
    if (Platform.isIOS) {
      await _analytics
          .initiateOnDeviceConversionMeasurementWithEmailAddress(email);
    }
  }

  Future<void> setUserId(String id) async {
    try {
      if (id == '-1' || id.isEmpty) return;
      await _analytics.setUserId(id: id);
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error setUserId',
      );
      return;
    }
  }

  /// send a custom log
  Future<void> sendALog({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      if (kReleaseMode) {
        await _analytics.logEvent(name: name, parameters: parameters);
      } else if (kDebugMode) {
        PrintDev.instance.debug(
            '________________________________ANALYTICS________________________________');
        PrintDev.instance.debug(name);
        PrintDev.instance.debug(
            '||______________________________ANALYTICS______________________________||');

        return;
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: '$name log caused an error, or internet connection issue');
      return;
    }
  }

  /// send a custom log
  Future<void> logPurchase({
    String? currency,
    String? coupon,
    double? value,
    List<AnalyticsEventItem>? items,
    double? tax,
    double? shipping,
    String? transactionId,
    String? affiliation,
    AnalyticsCallOptions? callOptions,
  }) async {
    try {
      if (kReleaseMode) {
        await _analytics.logPurchase(
          currency: currency,
          coupon: coupon,
          value: value,
          items: items,
          tax: tax,
          shipping: shipping,
          transactionId: transactionId,
          affiliation: affiliation,
          callOptions: callOptions,
        );
      } else if (kDebugMode) {
        PrintDev.instance.debug(
            '________________________________ANALYTICS________________________________');
        PrintDev.instance.debug('purchase');
        flutterInfoToast('purchase');
        PrintDev.instance.debug(
            '||______________________________ANALYTICS______________________________||');

        return;
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'purchase log caused an error, or internet connection issue');
      return;
    }
  }

  /// Log app open
  Future<void> logAppOpen() async {
    try {
      if (kReleaseMode) {
        await _analytics.logAppOpen();
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error logAppOpen',
      );
      return;
    }
  }

  /// Log login
  Future<void> logLogin(String loginMethod) async {
    try {
      if (kReleaseMode) {
        await _analytics.logLogin(loginMethod: loginMethod);
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Error logLogin',
      );
      return;
    }
  }

  /// Log sign up
  Future<void> logSignUp(String signUpMethod) async {
    try {
      if (kReleaseMode) {
        await _analytics.logSignUp(signUpMethod: signUpMethod);
      }
    } catch (e) {
      await crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'Error logSignUp');
      return;
    }
  }
}

///TODO add unit test to make sure that length is less than 40
class AnalyticsNames {
  /// Auth
  static const String emailLogin = 'email_login';
  static const String signUp = 'sign_up';
  static const String googleLogin = 'google_login';
  static const String appleLogin = 'apple_login';
  static const String facebookLogin = 'facebook_login';
  static const String userVerified = 'user_verified';

  static const String accountDeleted = 'account_deleted';
  static const String onUpdateAppPressed = 'on_update_app_pressed';

  /// Onboard
  static const String onboardSubmittedWithSuccess =
      'onboard_submitted_with_success';

  static const String onboardSubmissionFailed = 'onboard_submission_failed';

  /// Here are parameters of each page
  static const String onboardNextPage = 'onboard_next_page';

  static const String activation = 'activation';

  /// Purchase
  static const String purchaseCanceled = 'purchase_canceled';
  static const String premiumPlanPurchased = 'premium_plan_purchased';

  // static const String managePremiumPlanTapped = 'manage_premium_plan_tapped';
  static const String settingsManagePremiumPlanTapped =
      'settings_manage_premium_plan_tapped';

  // static const String upgradePremiumPlanTapped = 'upgrade-premium-plan-tapped';
  static const String settingsUpgradePremiumPlanTapped =
      'settings_upgrade_premium_plan_tapped';
  static const String restorePremiumPlanTapped = 'restore_premium_plan_tapped';

  /// Hallway
  static const String magicMatchClicked = 'magic_match_clicked';
  static const String magicMatchCanceled = 'magic_match_canceled';
  static const String magicMatchAccepted = 'magic_match_accepted';

  /// Call
  static const String callEnded = 'call_ended';
  static const String callCanceled = 'call_canceled';
  static const String webRTCConnected = 'web_rtc_connected';
  static const String webRTFailed = 'web_rtc_failed';

  /// Feedback
  static const String feedbackSubmitted = 'feedback_submitted';
  static const String feedbackNextButtonClicked =
      'feedback_next_button_clicked';

  /// Mission
  static const String selectedMissionMode = 'selected_mission_mode';
  static const String socialCheckDone = 'social_check_done';
  static const String pickedMission = 'picked_mission';
  static const String submittedMission = 'submitted_mission';

  /// Profile
  static const String changeUserBioFromProfileTapped =
      'change_user_bio_from_profile_tapped';
}

class AnalyticsParameters {
  static const String mission = 'mission';
  static const String missionId = 'missionId';
  static const String missionDifficulty = 'missionDifficulty';
  static const String missionCategoryId = 'missionCategoryId';
  static const String secondsPassed = 'secondsPassed';
  static const String callDuration = 'callDuration';
  static const String waitingSeconds = 'waitingSeconds';
  static const String value = 'value';
  static const String page = 'page';
}
