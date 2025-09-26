enum LocalManagerKeys {
  // auth
  token,
  tokenExpiryDate,
  userId,
  userEmail,
  username,
  characterData,
  firstAppRunOfToday,

  /// isFirstRun5 is required to force cleaning cache of a user
  /// Number at the end means version of force
  isFirstRun5, // bool
  canSwitchServer, // bool
  isStagingServer, // bool
  isUserVerified,

  userProfile,

  ///
  isGuideViewed, //bool
  isPaywallPlanSelected, // bool
  isPremium,

  ///
  modeStatus,
  themeMode, //String
  initialUserData,
  goalStreak, // int
  goalPracticeMax, // int
  goalPracticeValue, // int
  ///mission
  missionPickedTime, // int Date
  missionSubmissionDate, // int Date
  fetchedMission, //Map<String,dynamic> MissionOfToday
  ///TODO it should not be encoded
  pickedMissionMode, //String
  missionDifficulty, //String
  fetchedMissionDate, // int Date
  isMissionPicked, // bool
  fqLink, //String
  isFQCodeActive, // bool
  tempLinqoinReference, //int
  ///
  hasHallwayAccess, // bool
  ///bool
  isNotificationEnabled, // bool

  dateOfFirstCallOffDay, // int Date

  locale,
}
