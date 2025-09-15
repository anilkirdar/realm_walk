import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract mixin class IWebsocketStore {
  Future<bool> connect(String token);

  void disconnect();

  void setIsUserInPaywall(bool value);

  void setHasUserAccessToHallway(bool value);

  void setIsUserTalking(bool isTalking);

  void setIsUserBeingCalled(bool isBeingCalled);

  void setIsUserCalling(bool isUserCalling);

  /// if app is resumed set user Online or Busy
  /// or Offline according to conditions
  /// This method is called from [AppLifecycleState.resumed]
  void onAppResumed();

  /// if app is paused set user Offline
  /// This method is called from [AppLifecycleState.paused]
  /// or [AppLifecycleState.inactive] or [AppLifecycleState.detached]
  void onAppPaused();

  /// Update user offline
  void updateUserOffline();

  /// Update user busy
  void updateUserBusy({bool isForced});

  /// Accept incoming call
  void updateUserOnline({bool isForced});

  void sendToFetchUserWholeList();

  void acceptCall();
  
  void declineCall();

  void setIsSocketActive(bool value);

  void clearAll();

  void resetWebSocket();
}
