// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ARNotification _$ARNotificationFromJson(Map<String, dynamic> json) =>
    ARNotification(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$ARNotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      priority:
          $enumDecodeNullable(
            _$NotificationPriorityEnumMap,
            json['priority'],
          ) ??
          NotificationPriority.normal,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ARNotificationToJson(ARNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ARNotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': instance.data,
      'isRead': instance.isRead,
      'imageUrl': instance.imageUrl,
      'actionUrl': instance.actionUrl,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$ARNotificationTypeEnumMap = {
  ARNotificationType.spawn: 'spawn',
  ARNotificationType.combat: 'combat',
  ARNotificationType.resource: 'resource',
  ARNotificationType.social: 'social',
  ARNotificationType.achievement: 'achievement',
  ARNotificationType.system: 'system',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  enabled: json['enabled'] as bool? ?? true,
  spawnNotifications: json['spawnNotifications'] as bool? ?? true,
  combatNotifications: json['combatNotifications'] as bool? ?? true,
  resourceNotifications: json['resourceNotifications'] as bool? ?? true,
  socialNotifications: json['socialNotifications'] as bool? ?? true,
  achievementNotifications: json['achievementNotifications'] as bool? ?? true,
  systemNotifications: json['systemNotifications'] as bool? ?? true,
  minimumPriority:
      $enumDecodeNullable(
        _$NotificationPriorityEnumMap,
        json['minimumPriority'],
      ) ??
      NotificationPriority.normal,
  soundEnabled: json['soundEnabled'] as bool? ?? true,
  vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
  quietHours: json['quietHours'] == null
      ? null
      : TimeRange.fromJson(json['quietHours'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'spawnNotifications': instance.spawnNotifications,
  'combatNotifications': instance.combatNotifications,
  'resourceNotifications': instance.resourceNotifications,
  'socialNotifications': instance.socialNotifications,
  'achievementNotifications': instance.achievementNotifications,
  'systemNotifications': instance.systemNotifications,
  'minimumPriority': _$NotificationPriorityEnumMap[instance.minimumPriority]!,
  'soundEnabled': instance.soundEnabled,
  'vibrationEnabled': instance.vibrationEnabled,
  'quietHours': instance.quietHours?.toJson(),
};

TimeRange _$TimeRangeFromJson(Map<String, dynamic> json) => TimeRange(
  start: const TimeOfDayConverter().fromJson(json['start'] as String),
  end: const TimeOfDayConverter().fromJson(json['end'] as String),
);

Map<String, dynamic> _$TimeRangeToJson(TimeRange instance) => <String, dynamic>{
  'start': const TimeOfDayConverter().toJson(instance.start),
  'end': const TimeOfDayConverter().toJson(instance.end),
};
