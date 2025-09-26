class AppConst {
  static const String appName = 'RealmWalk';

  // <These constants change with updates>
  static const int majorVersion = 1;
  static const int minorVersion = 0;
  static const int subVersion = 0;

  static const int androidSubVersion = subVersion;
  static const int iOSSubVersion = subVersion;

  static const int androidVersionInt = 446;
  static const int iOSVersionInt = 446;

  static const String androidVersion =
      '$majorVersion.$minorVersion.$androidSubVersion';
  static const String iOSVersion = '$majorVersion.$minorVersion.$iOSSubVersion';
  static const String currentVersion =
      '$majorVersion.$minorVersion.$subVersion';

  static const String android = 'android';
  static const String iOS = 'iOS';

  // Fonts
  static const String poppins = 'Poppins';
  static const String poppinsSemiBold = 'Poppins-SemiBold';

  // Regex
  static const String emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$";

  /// Genders
  static const String maleEnum = 'MALE';
  static const String male = 'Male';
  static const String femaleEnum = 'FEMALE';
  static const String undefinedGenderEnum = 'UNDEFINED';
  static const String undefinedGender = 'Undefined';
  static const String gender = 'gender';

  /// Onboard pages
  static const String onGender = 'onGender';
  static const String onAge = 'onAge';
  static const String onCountry = 'onCountry';
  static const String onNativeLanguage = 'onNativeLanguage';
  static const String onEnglishLevel = 'onEnglishLevel';
  static const String onPracticeGoal = 'onPracticeGoal';
  static const String onFavouriteTopics = 'onFavouriteTopics';
  static const String onAppLanguage = 'onAppLanguage';

  ///Notification types
  static const String profile = 'profile';
  // static const String hallway = 'hallway';
  // static const String mission = 'mission';
  // static const String paywall = 'paywall';
  // static const String missionChecked = 'missionChecked';

  /// Hallway:  Event Sent
  static const String sendIdentify = 'IDENTIFY';
  static const String sendPing = 'PING';
  static const String sendUserBusy = 'USER_BUSY';
  static const String sendUserOffline = 'USER_OFFLINE';
  static const String sendUserWholeList = 'USER_WHOLE_LIST';
  static const String callQuestion = 'CALL_QUESTION';
  static const String closeQuestion = 'CALL_QUESTION_CANCEL';

  /// TODO: extract to enum
  /// Hallway:  Event Received
  static const String helloReceived = 'HELLO';
  static const String pingAckEnumReceived = 'PING_ACK';
  static const String userChangedReceived = 'USER_CHANGED';
  static const String userWholeListAckReceived = 'USER_WHOLE_LIST_ACK';
  static const String callQuestionAck = 'CALL_QUESTION_ACK';

  /// TODO: extract to enum
  /// webRTC: Event Sent
  static const String sendCallUser = 'CALL_USER';
  static const String sendCallIncoming = 'CALL_INCOMING_ACK';
  static const String sendCallICECandidate = 'CALL_ICE_CANDIDATE';
  static const String sendCallSessionDescription = 'CALL_SESSION_DESCRIPTION';
  static const String sendCallHangUp = 'CALL_HANG_UP';
  static const String sendCallAgentOptions = 'CALL_AGENT_OPTIONS';

  static const String sendSetRtpCapabilities = 'CALL_SET_RTP_CAPABILITIES';
  static const String sendProducerConnect = 'CALL_PRODUCER_CONNECT';
  static const String sendProducerProduce = 'CALL_PRODUCER_PRODUCE';
  static const String sendProducerPause = 'CALL_PRODUCER_PAUSE';
  static const String sendProducerRestartIce = 'CALL_PRODUCER_RESTART_ICE';
  static const String sendProducerRecreate = 'CALL_PRODUCER_RECREATE';
  static const String sendConsumerConnect = 'CALL_CONSUMER_CONNECT';
  static const String sendConsumerResume = 'CALL_CONSUMER_RESUME';
  static const String sendConsumerRestartIce = 'CALL_CONSUMER_RESTART_ICE';
  static const String sendConsumerRecreate = 'CALL_CONSUMER_RECREATE';
  static const String sendCallAgentInterrupt = 'CALL_AGENT_INTERRUPT';
  static const String producerCreateAck = 'CALL_PRODUCER_CREATE_ACK';
  static const String producerConnectAck = 'CALL_PRODUCER_CONNECT_ACK';
  static const String producerProduceAck = 'CALL_PRODUCER_PRODUCE_ACK';
  static const String producerRestartIceAck = 'CALL_PRODUCER_RESTART_ICE_ACK';
  static const String consumerCreateAck = 'CALL_CONSUMER_CREATE_ACK';
  static const String consumerConnectAck = 'CALL_CONSUMER_CONNECT_ACK';
  static const String consumerConsumeAck = 'CALL_CONSUMER_CONSUME_ACK';
  static const String consumerRestartIceAck = 'CALL_CONSUMER_RESTART_ICE_ACK';

  static const String token = 'token';
  static const String userId = 'userId';

  static const String isBusy = 'isBusy';
  static const String isOffline = 'isOffline';

  static const String candidate = 'candidate';
  static const String description = 'description';
  static const String cancelMagicMatchReason = 'CANCEL_MAGIC_CALL';
  static const String reason = 'reason';
  static const String isCaller = 'isCaller';
  static const String stats = 'stats';

  /// webRTC
  static const String isAccepted = 'isAccepted';
  static const String rtcPeerConnectionStateFailed =
      'RTCPeerConnectionStateFailed';
  static const String rtcPeerConnectionStateDisconnected =
      'RTCPeerConnectionStateDisconnected';
  static const String peerHangUp = 'peerHangUp';
  static const String hangUpByLimit = 'peerHangUp';

  ///
  static const String id = 'id';
  static const String isVerified = 'isVerified';
  static const String email = 'email';
  static const String modeStatus = 'modeStatus';
  static const String message = 'message';
  static const String error = 'error';
}
