import '../../../core/constants/app/app_const.dart';

enum WSReceivedEnum {
  hello,
  pingAck,
  userChanged,
  userWholeListAck,
}

extension Event on WSReceivedEnum {
  String get toEnum {
    switch (this) {
      case WSReceivedEnum.hello:
        return AppConst.helloReceived;

      case WSReceivedEnum.pingAck:
        return AppConst.pingAckEnumReceived;

      case WSReceivedEnum.userChanged:
        return AppConst.userChangedReceived;

      case WSReceivedEnum.userWholeListAck:
        return AppConst.userWholeListAckReceived;

      default:
        return '';
    }
  }
}
