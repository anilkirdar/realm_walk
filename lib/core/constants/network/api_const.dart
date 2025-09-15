import 'dart:math';

import '../../init/config/config.dart';

class APIConst {
  static const String apiPathV1 = '/api/v1';
  static const String baseUrl = 'api.linqiapp.com';
  static const String baseStagingUrl = 'api-staging.linqiapp.com';
  static const String linqiAppMain = 'https://linqiapp.com/';
  static const String googleCom = 'https://google.com/';
  static const String linqiAppOneClick = 'https://get.linqiapp.com';
  static const String blog = 'https://blog.linqiapp.com';
  static const String linqiAppPlayStore =
      'https://play.google.com/store/apps/details?id=com.edukeyt.linqi_app';
  static const String linqiAppAppStore =
      'https://apps.apple.com/app/linqiapp-speak-english-fast/id1660919976';
  static const String discordCommunity =
      'https://discord.com/invite/JsxWA4yEF4';
  static const String whatsappContact = 'https://ig.me/m/linqiapp';
  static const String instagramFollow = 'https://www.instagram.com/linqiapp';
  static const String tiktokFollow = 'https://www.tiktok.com/@linqiapp';
  static const String youtubeFollow = 'https://www.youtube.com/@linqiapp';
  static const String twitterFollow = 'https://twitter.com/Linqiapp';
  static const String readBlog = 'https://blog.linqiapp.com/';
  static const String visitWebsite = 'https://linqiapp.com/';

  static const String linqiAppAppStoreReview =
      "https://apps.apple.com/tr/app/linqiapp-speak-english-fast/id1660919976?action=write-review";

  ///Auth
  static const String auth = '$apiPathV1/auth';
  static const String signIn = '$auth/sign_in';
  static const String signUp = '$auth/sign_up';
  static const String sendForgotPassword = '$auth/send_forgot_password_email';
  static const String verifyEmail = '$auth/verify_email';
  static const String verifyPasswordCode = '$auth/verify_password_code';
  static const String updatePassword = '$auth/forgot_password';
  static const String sendVerificationAgain = '$auth/send_verify_email_again';

  static const String sendForgotPasswordAgain =
      '$auth/send_forgot_password_email_again';
  static const String googleSignIn = '$auth/sign_up_or_login/google';
  static const String facebookSignIn = '$auth/sign_up_or_login/facebook';
  static const String appleSignIn = '$auth/sign_up_or_login/apple';

  ///
  static const String privacyPolicy = '${linqiAppMain}privacy-policy/';
  static const String privacyPolicyWebView =
      '${linqiAppMain}privacy-policy-webview/';
  static const String termsOfUse = '${linqiAppMain}terms-of-use/';
  static const String termsOfUseWebView =
      '${linqiAppMain}terms-of-use-webview/';
  static const String user = '$apiPathV1/user';
  static const String userInit = '$user/init';
  static const String userUpdate = '$apiPathV1/user/update';
  static const String paymentRestore = '$apiPathV1/payment/restore?v=2';
  static const String currentUserProfile = '$apiPathV1/user/index';

  static String userProfile(int id) =>
      '$apiPathV1/user/${id == 0 ? '@me' : id}/profile';

  static String userFollowers(int id) =>
      '$apiPathV1/user/${id == 0 ? '@me' : id}/followers';

  static String userFollowings(int id) =>
      '$apiPathV1/user/${id == 0 ? '@me' : id}/followings';
  static const String userStalkers = '$apiPathV1/user/@me/stalkers';

  static String userMutuals(int id) => '$apiPathV1/user/$id/mutuals';

  static String userFeedbackList(int id) => '$apiPathV1/user/$id/feedback_list';

  static String topicUsers(int id) => '$user/by_topic/$id';

  static String resources = '$apiPathV1/resources';

  static String userProgress(id) => '$apiPathV1/user/$id/progress';

  static String streakHistory(DateTime since, DateTime until,
          {String id = '@me'}) =>
      '$apiPathV1/user/$id/streak_history?v=2&since=${since.millisecondsSinceEpoch}&until=${until.millisecondsSinceEpoch}';
  static const String notificationHistory = '$user/notification_history';
  static const String readNotification = '$user/read_notification';
  static const String otherUserProfile = '$user/peer_index';
  static const String blockUser = '$user/block/';
  static const String unblockUser = '$user/unblock/';
  static const String getUsersDidntPickMission =
      '$user/get_users_didnt_pick_mission';
  static const String deleteUser = '$user/delete';
  static String suspendOtherUser(id) => '$user/suspend/$id';
  static const String blockedUsers = '$user/blocked_users/';
  static const String reportUser = '$user/report';
  static const String deleteNotification = '$user/delete_notification';

  //Friend Suggestions
  static String friendSuggestions(id) => '$user/$id/friend_suggestions';

  /// Hallway
  static const String gateway = 'wss://$baseUrl/gateway';
  static const String gatewayStaging = 'wss://$baseStagingUrl/gateway';
  static const String randomAvatar = '$user/random_avatars';
  static const String rewardWithLinqoin = '$user/reward_with_linqion';
  static const String rewardWithPremium = '$user/reward_with_premium';
  static const String submitNpsScore = '$user/nps_score';
  static const String submitNpsFeedback = '$user/nps_feedback';
  static const String userAlerts = '$user/@me/alerts';
  static const String userAlertsRead = '$user/@me/alerts/read';

  /// Profile
  static const String profile = '$apiPathV1/profile';
  static const String createProfile = '$profile/create';
  static const String updateProfile = '$profile/update';
  static const String findProfile = '$profile/find';
  static const String removeUserAvatar = '$profile/remove_user_avatar';

  static String resetOtherProfile(id) => '$profile/reset/$id';

  static const String bindLanguages = '$user/bind_languages';
  static const String updateUserLanguages = '$user/update_user_languages';
  static const String bindPracticeGoal = '$user/bind_practice_goal';
  static const String updatePracticeGoal = '$apiPathV1/practice_goal/update';
  static const String bindFavTopics = '$user/bind_topics';
  static const String updateFavTopics = '$user/update_user_topics';
  static const String updateLocale = '$user/update_locale';

  ///Mission
  static const String mission = '$apiPathV1/mission';
  static const String uncheckedUserMission =
      '$mission/get_unchecked_user_mission';
  static const String checkUserMission = '$mission/check_user_mission';
  static const String checkReferenceCode = '$mission/check_reference_code';
  static const String getEasyMission =
      '$mission/get_random_mission?difficulty=easy';
  static const String getMediumMission =
      '$mission/get_random_mission?difficulty=medium';
  static const String getHardMission =
      '$mission/get_random_mission?difficulty=hard';
  static const String createLinkData = '$mission/create_reference_code';
  static const String acceptOrDeclineGlobalChallenge =
      '$mission/accept_or_decline_global_challenge';
  static const String availableGlobalChallenge =
      '$mission/available_global_challenges';
  static const String createGlobalChallenge =
      '$mission/create_global_challenge';

  static const String createDominionEffect = '$mission/create_dominion_effect';
  static const String getDominionEffectStatus =
      '$mission/get_dominion_effect_status';

  static String get randomMissionDifficulty {
    final int randomNumber = Random().nextInt(3);
    switch (randomNumber) {
      case 0:
        return getEasyMission;
      case 1:
        return getMediumMission;
      case 2:
        return getHardMission;
      default:

        /// if there is an error occurred, it returns easy mission
        return getEasyMission;
    }
  }

  static const String assignMission = '$mission/assign_mission';
  static const String sharableMission = '$mission/shareable_users';
  static const String inviteUserToMission =
      'https://$baseStagingUrl$mission/share_with_user';
  static const String getWeeklyStats = '$mission/index_v2';
  static const String submitMission = '$mission/submit_mission';
  static const String findUserMissionOfToday =
      '$mission/find_user_mission_of_today';

  ///
  static const String fcm = '$apiPathV1/fcm';

  static const String firestoreAppStatus = 'app_status';

  /// Feedback
  static const String giveFeedback = '$apiPathV1/feedback/create';
  static const String giveReference = '$apiPathV1/reference/give_references';
  static const String giveAdvice = '$apiPathV1/advice/give_advices';

  /// Practice Chat
  static const String practiceChat = '$apiPathV1/practice_chat';
  static const String goalStreak = '$practiceChat/goal_streak';

  /// Ranking
  static const String ranking = '$apiPathV1/ranking';

  static String follow(String uid) => '$apiPathV1/user/@me/followings/$uid';

  static String removeFollow(String uid) =>
      '$apiPathV1/user/@me/followers/$uid';

  static const String daily = 'daily';
  static const String weekly = 'weekly';
  static const String allTime = 'alltime';

  static const String translate = '$apiPathV1/translation/translate';
  static String settings =
      '/settings/startup?platform=${Config.instance.isAndroid ? 'android' : 'ios'}';

  static String contactUsCategories = '$apiPathV1/contact-us/categories';
  static String contactUsCreateRequest =
      '$apiPathV1/contact-us/create-support-request';

  static String waveWaitingWaves(List<int> excludeUserIds) =>
      '$apiPathV1/user/@me/waves?excludeUserIds=${excludeUserIds.join(',')}';

  static String waveInfiniteWaves(List<int> excludeUserIds) =>
      '$apiPathV1/user/@me/infinite-waves?excludeUserIds=${excludeUserIds.join(',')}';

  static String waveWaveUpdates(List<int> excludeUserIds) =>
      '$apiPathV1/user/@me/wave-updates?excludeUserIds=${excludeUserIds.join(',')}';

  static String waveSend(
          String waveeId, bool bypassSuperWaveCheck, String origin) =>
      '$apiPathV1/user/@me/waves/${waveeId}?bypassSuperWaveCheck=${bypassSuperWaveCheck}&origin=${origin}';

  static String waveIgnore(String waverId, bool isInfinite, String origin) =>
      '$apiPathV1/user/@me/waves/${waverId}/ignore?isInfiniteWave=${isInfinite}&origin=${origin}';

  static String waveUndo(String waveeId) =>
      '$apiPathV1/user/@me/waves/${waveeId}/undo';

  static String linqiShopSettings = '$apiPathV1/linqoin-shop/settings';
  static String linqiShopBuyItem =
      '$apiPathV1/linqoin-shop/buy-item-with-linqoin';
  static String linqiShopRedeemPromoCode =
      '$apiPathV1/linqoin-shop/redeem-promo-code';

  static String userSurveyByName(String name) => '$apiPathV1/user-survey/$name';

  static String agentsGetAll = '$apiPathV1/agents/all';
  static String agentsHelp = '$apiPathV1/agents/get_help_answer';

  static const String userSurveyAnswer =
      'https://api-staging.linqiapp.com/api/v1/user-survey/answer';
}
