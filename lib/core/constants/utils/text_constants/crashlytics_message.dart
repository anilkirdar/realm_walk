class CrashlyticsMessages {
  static CrashlyticsMessages? _instance;

  static CrashlyticsMessages get instance {
    return _instance ??= CrashlyticsMessages._init();
  }

  CrashlyticsMessages._init();

  final String signIn = '$couldNot sign in';

  static String couldNot = "Could not";
  final String couldNotCreateAUser = '$couldNot create a user';
  final String couldNotFetchGoalStreak = '$couldNot fetch goal streak';
  final String bindUserToLanguages = '$couldNot bind user to languages';
  final String bindUserToPracticeGoal = '$couldNot bind user to practice goal';
  final String bindUserToTopics = '$couldNot bind user to topics';
  final String getBlockedUsersList = '$couldNot get list of blocked users';
  final String updateBio = '$couldNot update bio';
}
