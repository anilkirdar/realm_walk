import '../../../core/constants/app/app_const.dart';

enum WSEventSentEnum {
  identify,
  ping,
  userBusy,
  userOffline,
  userWholeList,
  callHangUp,
  callICECandidate,
  callIncoming,
  callSessionDescription,
  callUser,
  callAgentInterrupt,
  callQuestion,
  closeQuestion,
  setRtpCapabilities,
  producerConnect,
  producerProduce,
  producerPause,
  producerRestartIce,
  producerRecreate,
  consumerConnect,
  consumerResume,
  consumerRestartIce,
  consumerRecreate,
  callAgentOptions,
}

extension Event on WSEventSentEnum {
  String get toEnum {
    switch (this) {
      case WSEventSentEnum.identify:
        return AppConst.sendIdentify;

      case WSEventSentEnum.ping:
        return AppConst.sendPing;

      case WSEventSentEnum.userBusy:
        return AppConst.sendUserBusy;

      case WSEventSentEnum.userOffline:
        return AppConst.sendUserOffline;

      case WSEventSentEnum.userWholeList:
        return AppConst.sendUserWholeList;

      case WSEventSentEnum.callHangUp:
        return AppConst.sendCallHangUp;

      case WSEventSentEnum.callICECandidate:
        return AppConst.sendCallICECandidate;

      case WSEventSentEnum.callIncoming:
        return AppConst.sendCallIncoming;

      case WSEventSentEnum.callSessionDescription:
        return AppConst.sendCallSessionDescription;

      case WSEventSentEnum.callUser:
        return AppConst.sendCallUser;

      case WSEventSentEnum.callQuestion:
        return AppConst.callQuestion;

      case WSEventSentEnum.closeQuestion:
        return AppConst.closeQuestion;

      case WSEventSentEnum.setRtpCapabilities:
        return AppConst.sendSetRtpCapabilities;

      case WSEventSentEnum.producerConnect:
        return AppConst.sendProducerConnect;

      case WSEventSentEnum.producerProduce:
        return AppConst.sendProducerProduce;

      case WSEventSentEnum.producerPause:
        return AppConst.sendProducerPause;

      case WSEventSentEnum.producerRestartIce:
        return AppConst.sendProducerRestartIce;

      case WSEventSentEnum.producerRecreate:
        return AppConst.sendProducerRecreate;

      case WSEventSentEnum.consumerConnect:
        return AppConst.sendConsumerConnect;

      case WSEventSentEnum.consumerResume:
        return AppConst.sendConsumerResume;

      case WSEventSentEnum.consumerRestartIce:
        return AppConst.sendConsumerRestartIce;

      case WSEventSentEnum.consumerRecreate:
        return AppConst.sendConsumerRecreate;

      case WSEventSentEnum.callAgentInterrupt:
        return AppConst.sendCallAgentInterrupt;

      case WSEventSentEnum.callAgentOptions:
        return AppConst.sendCallAgentOptions;

      default:
        return '';
    }
  }
}
