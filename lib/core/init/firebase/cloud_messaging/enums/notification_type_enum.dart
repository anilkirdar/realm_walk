import '../../../../constants/app/app_const.dart';

enum NotificationTypeEnum { profile }

extension NotificationTypeExtension on NotificationTypeEnum {
  String get enumValue {
    switch (this) {
      case NotificationTypeEnum.profile:
        return AppConst.profile;
      default:
        throw Exception("notificationTypeEnumNotFound");
    }
  }
}
