import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../core/base/service/base_service.dart';

abstract class IWSSendEventHandler extends BaseService {
  Timer? pingTimer;

  WebSocketChannel? webSocketChannel;

  /// Websocket
  void setWebSocketChannel(WebSocketChannel webSocketChannelValue);

  void clearWebSocketChannel();

  void setHasUserAccessToHallway(bool value);

  bool get hasUserAccessToHallway;

  /// Websocket
  void setIsIdentifySent(bool isIdentifySent);

  /// Websocket
  void setIsSocketActive(bool isSocketActive);

  /// Websocket
  void sendIdentify(String token, bool isInvisible, bool isInCall);

  /// Websocket
  void sendPing();

  /// Hallway
  void updateUserOffline();

  /// Hallway
  void updateUserBusy();

  /// Hallway
  void updateUserOnline();

  /// Fetch users
  // void sendToFetchUserWholeList({String? variant, HallwayFilterModel? filter});

  /// Send to get a question
  void sendCallQuestion();

  /// Send to close current question
  void sendCloseQuestion();

  /// webRTC
  void sendCallUser(String userId);

  /// webRTC
  void sendCallAgent(String agentCodeName);

  /// webRTC
  void sendCallIncoming({required bool isAccepted});

  /// webRTC
  void sendCallICECandidate(Map<String, dynamic> candidate);

  /// webRTC
  void sendCallSessionDescription(Map<String, dynamic> offer);

  /// webRTC
  void sendCallHangUp({String reason});

  /// webRTC
  void sendCallAgentOptions({
    required double speechSpeed,
  });
}
