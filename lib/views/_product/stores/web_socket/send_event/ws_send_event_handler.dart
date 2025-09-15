import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../core/constants/app/app_const.dart';
import '../../../../../product/enum/websocket/ws_event_sent_enum.dart';
import 'i_ws_send_event_handler.dart';

class WSSendEventHandler extends IWSSendEventHandler {
  bool _isSocketActive = false;

  bool _isIdentifySent = false;

  bool _hasUserAccessToHallway = true;

  @override
  void setWebSocketChannel(WebSocketChannel webSocketChannelValue) =>
      webSocketChannel = webSocketChannelValue;

  @override
  void clearWebSocketChannel() {
    webSocketChannel = null;
    _isSocketActive = false;
    setIsIdentifySent(false);
  }

  @override
  void setHasUserAccessToHallway(bool value) => _hasUserAccessToHallway = value;

  @override
  bool get hasUserAccessToHallway => _hasUserAccessToHallway;

  @override
  void setIsIdentifySent(bool isIdentifySent) =>
      _isIdentifySent = isIdentifySent;

  @override
  void setIsSocketActive(bool isSocketActive) {
    _isSocketActive = isSocketActive;
    if (isSocketActive == false) {
      pingTimer?.cancel();
    }
  }

  @override
  void sendIdentify(String token, bool isInvisible, bool isInCall) {
    if (token.isEmpty) {
      crashlyticsManager.sendACrash(
        error: 'token.isEmpty in sendIdentify',
        stackTrace: StackTrace.current,
        reason: 'ws_send_event_handler sendIdentify',
      );
    }
    _sendRequest(
      eventName: WSEventSentEnum.identify.toEnum,
      data: {
        AppConst.token: token,
        "invisible": isInvisible,
        "inCall": isInCall,
      },
    );
    _isIdentifySent = true;
    printDev.debug('IDENTIFY SENT');
  }

  @override
  void sendPing() {
    _sendRequest(eventName: WSEventSentEnum.ping.toEnum, data: {});
  }

  @override
  void updateUserOffline() {
    _sendRequest(
      eventName: AppConst.sendUserOffline,
      data: {AppConst.isOffline: true},
    );
  }

  @override
  void updateUserBusy() {
    _sendRequest(
      eventName: WSEventSentEnum.userBusy.toEnum,
      data: {AppConst.isBusy: true},
    );
    printDev.debug('userBusyEnumSent BUSY SENT');
  }

  @override
  void updateUserOnline() {
    _sendRequest(
      eventName: WSEventSentEnum.userOffline.toEnum,
      data: {AppConst.isOffline: false},
    );
    printDev.debug('userBusyEnumSent ONLINE SENT');
  }

  @override
  void sendCallHangUp({String? reason}) {
    _sendRequest(
      eventName: WSEventSentEnum.callHangUp.toEnum,
      data: {AppConst.reason: reason},
    );
  }

  @override
  void sendCallQuestion() {
    _sendRequest(eventName: WSEventSentEnum.callQuestion.toEnum, data: {});
  }

  @override
  void sendCloseQuestion() {
    _sendRequest(eventName: WSEventSentEnum.closeQuestion.toEnum, data: {});
  }

  @override
  void sendCallICECandidate(Map<String, dynamic> candidate) {
    _sendRequest(
      eventName: WSEventSentEnum.callICECandidate.toEnum,
      data: {AppConst.candidate: candidate},
    );
  }

  @override
  void sendCallIncoming({required bool isAccepted}) {
    _sendRequest(
      eventName: WSEventSentEnum.callIncoming.toEnum,
      data: {AppConst.isAccepted: isAccepted},
    );
  }

  @override
  void sendCallSessionDescription(Map<String, dynamic> offer) {
    _sendRequest(
      eventName: WSEventSentEnum.callSessionDescription.toEnum,
      data: {AppConst.description: offer},
    );
  }

  // @override
  // void sendToFetchUserWholeList({String? variant, HallwayFilterModel? filter}) {
  //   printDev.debug(
  //       "sendToFetchUserWholeList: $variant - age: ${filter?.age}, cefr: ${filter?.cefr}, gender: ${filter?.gender}");
  //   _sendRequest(
  //     eventName: WSEventSentEnum.userWholeList.toEnum,
  //     data: {'variant': variant, 'filter': filter?.toJson()},
  //   );
  // }

  @override
  void sendCallUser(String userId, {bool isSuperWave = false}) {
    _sendRequest(
      eventName: WSEventSentEnum.callUser.toEnum,
      data: {AppConst.userId: userId, "isSuperWave": isSuperWave},
    );
  }

  @override
  void sendCallAgent(String agentCodeName, {bool isSuperWave = false}) {
    _sendRequest(
      eventName: WSEventSentEnum.callUser.toEnum,
      data: {"agentCodeName": agentCodeName},
    );
  }

  void sendCallAgentInterrupt() {
    _sendRequest(
      eventName: WSEventSentEnum.callAgentInterrupt.toEnum,
      data: {},
    );
  }

  void sendProducerConnect(dynamic dtlsParameters) {
    print("sendProducerConnect: $dtlsParameters");
    _sendRequest(
      eventName: WSEventSentEnum.producerConnect.toEnum,
      data: {'dtlsParameters': dtlsParameters},
    );
  }

  void sendProducerProduce(dynamic parameters) {
    print("sendProducerProduce: $parameters");
    _sendRequest(
      eventName: WSEventSentEnum.producerProduce.toEnum,
      data: {"parameters": parameters},
    );
  }

  void sendProducerPaused(bool paused) {
    print("sendProducerPaused: $paused");
    _sendRequest(
      eventName: WSEventSentEnum.producerPause.toEnum,
      data: {"paused": paused},
    );
  }

  bool sendProducerRestartIce() {
    print("sendProducerRestartIce: ");
    return _sendRequest(
      eventName: WSEventSentEnum.producerRestartIce.toEnum,
      data: {},
    );
  }

  bool sendProducerRecreate() {
    print("sendProducerRecreate: ");
    return _sendRequest(
      eventName: WSEventSentEnum.producerRecreate.toEnum,
      data: {},
    );
  }

  void sendConsumerConnect(dynamic dtlsParameters) {
    print("sendConsumerConnect: $dtlsParameters");
    _sendRequest(
      eventName: WSEventSentEnum.consumerConnect.toEnum,
      data: {'dtlsParameters': dtlsParameters},
    );
  }

  void sendConsumerResume() {
    print("sendConsumerResume: ");
    _sendRequest(eventName: WSEventSentEnum.consumerResume.toEnum, data: {});
  }

  bool sendConsumerRestartIce() {
    print("sendConsumerRestartIce: ");
    return _sendRequest(
      eventName: WSEventSentEnum.consumerRestartIce.toEnum,
      data: {},
    );
  }

  bool sendConsumerRecreate() {
    print("sendConsumerRecreate: ");
    return _sendRequest(
      eventName: WSEventSentEnum.consumerRecreate.toEnum,
      data: {},
    );
  }

  bool _sendRequest({
    required Map<String, dynamic> data,
    required String eventName,
  }) {
    try {
      if (webSocketChannel == null) return false;

      /// If identify is not sent, and the eventName is not IDENTIFY
      /// then don't send a request
      if (_isIdentifySent == false && eventName != AppConst.sendIdentify) {
        return false;
        // throw Exception(
        //     '_isIdentifySent == false && eventName != AppConst.identifyEnumSent');
      }

      /// Makes sure that IDENTIFY is not sent multiple times, because after
      /// one IDENTIFY is sent, no other IDENTIFY should be sent, otherwise
      /// socket will be closed
      if (_isIdentifySent == true && eventName == AppConst.sendIdentify) {
        return false;
      }
      final encodedSink = jsonEncode({"e": eventName, "d": data});
      webSocketChannel?.sink.add(encodedSink);
      return true;
    } catch (e) {
      crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'ws_send_event_handler _sendRequest. Event $eventName',
      );
      return false;
    }
  }

  @override
  void sendCallAgentOptions({required double speechSpeed}) {
    _sendRequest(
      eventName: WSEventSentEnum.callAgentOptions.toEnum,
      data: {"speechSpeed": speechSpeed},
    );
  }
}
