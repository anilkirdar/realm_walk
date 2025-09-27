// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'ar_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class ARNotification extends INetworkModel<ARNotification> {
  final int id;
  final ARNotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final NotificationPriority priority;
  final DateTime? expiresAt;

  const ARNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.data,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.priority = NotificationPriority.normal,
    this.expiresAt,
  });

  factory ARNotification.fromJson(Map<String, dynamic> json) =>
      _$ARNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARNotificationToJson(this);

  @override
  ARNotification fromJson(Map<String, dynamic> json) =>
      _$ARNotificationFromJson(json);

  ARNotification copyWith({
    int? id,
    ARNotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    NotificationPriority? priority,
    DateTime? expiresAt,
  }) {
    return ARNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      priority: priority ?? this.priority,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  // Helper methods
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;
  bool get hasData => data != null && data!.isNotEmpty;

  Duration get age => DateTime.now().difference(timestamp);

  String get ageText {
    if (age.inMinutes < 1) {
      return 'Az önce';
    } else if (age.inHours < 1) {
      return '${age.inMinutes} dakika önce';
    } else if (age.inDays < 1) {
      return '${age.inHours} saat önce';
    } else if (age.inDays < 7) {
      return '${age.inDays} gün önce';
    } else {
      return '${(age.inDays / 7).floor()} hafta önce';
    }
  }

  String get typeEmoji => type.emoji;
  String get priorityEmoji => priority.emoji;

  Duration? get timeUntilExpiry {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isRecent => age.inMinutes < 5;
  bool get isToday => age.inDays < 1;

  // Data accessors for specific notification types
  String? get monsterId => data?['monsterId'] as String?;
  String? get monsterName => data?['monsterName'] as String?;
  double? get latitude => data?['latitude'] as double?;
  double? get longitude => data?['longitude'] as double?;
  String? get playerId => data?['playerId'] as String?;
  String? get playerName => data?['playerName'] as String?;
  bool? get isFriend => data?['isFriend'] as bool?;
  String? get resourceName => data?['resourceName'] as String?;
  int? get quantity => data?['quantity'] as int?;
  bool? get isVictory => data?['isVictory'] as bool?;

  String get summaryText {
    switch (type) {
      case ARNotificationType.spawn:
        return monsterName != null
            ? '$monsterName görüldü!'
            : 'Yeni yaratık görüldü!';
      case ARNotificationType.combat:
        return isVictory == true ? 'Savaş kazanıldı!' : 'Savaş bitti!';
      case ARNotificationType.resource:
        return resourceName != null
            ? '$resourceName toplandı!'
            : 'Kaynak toplandı!';
      case ARNotificationType.social:
        return playerName != null
            ? '$playerName yakınında!'
            : 'Oyuncu yakınında!';
      case ARNotificationType.achievement:
        return 'Başarım kazanıldı!';
      case ARNotificationType.system:
        return 'Sistem bildirimi';
    }
  }
}

enum ARNotificationType {
  @JsonValue('spawn')
  spawn,
  @JsonValue('combat')
  combat,
  @JsonValue('resource')
  resource,
  @JsonValue('social')
  social,
  @JsonValue('achievement')
  achievement,
  @JsonValue('system')
  system,
}

extension ARNotificationTypeExtension on ARNotificationType {
  String get displayName {
    switch (this) {
      case ARNotificationType.spawn:
        return 'Yaratık Spawn';
      case ARNotificationType.combat:
        return 'Savaş';
      case ARNotificationType.resource:
        return 'Kaynak';
      case ARNotificationType.social:
        return 'Sosyal';
      case ARNotificationType.achievement:
        return 'Başarım';
      case ARNotificationType.system:
        return 'Sistem';
    }
  }

  String get emoji {
    switch (this) {
      case ARNotificationType.spawn:
        return '👹';
      case ARNotificationType.combat:
        return '⚔️';
      case ARNotificationType.resource:
        return '🌿';
      case ARNotificationType.social:
        return '👥';
      case ARNotificationType.achievement:
        return '🏆';
      case ARNotificationType.system:
        return '⚙️';
    }
  }
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Düşük';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'Yüksek';
      case NotificationPriority.urgent:
        return 'Acil';
    }
  }

  String get emoji {
    switch (this) {
      case NotificationPriority.low:
        return '🔵';
      case NotificationPriority.normal:
        return '🟢';
      case NotificationPriority.high:
        return '🟡';
      case NotificationPriority.urgent:
        return '🔴';
    }
  }

  int get sortOrder {
    switch (this) {
      case NotificationPriority.urgent:
        return 4;
      case NotificationPriority.high:
        return 3;
      case NotificationPriority.normal:
        return 2;
      case NotificationPriority.low:
        return 1;
    }
  }
}

@JsonSerializable(explicitToJson: true)
class NotificationSettings extends INetworkModel<NotificationSettings> {
  final bool enabled;
  final bool spawnNotifications;
  final bool combatNotifications;
  final bool resourceNotifications;
  final bool socialNotifications;
  final bool achievementNotifications;
  final bool systemNotifications;
  final NotificationPriority minimumPriority;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final TimeRange? quietHours;

  const NotificationSettings({
    this.enabled = true,
    this.spawnNotifications = true,
    this.combatNotifications = true,
    this.resourceNotifications = true,
    this.socialNotifications = true,
    this.achievementNotifications = true,
    this.systemNotifications = true,
    this.minimumPriority = NotificationPriority.normal,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHours,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  @override
  NotificationSettings fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  NotificationSettings copyWith({
    bool? enabled,
    bool? spawnNotifications,
    bool? combatNotifications,
    bool? resourceNotifications,
    bool? socialNotifications,
    bool? achievementNotifications,
    bool? systemNotifications,
    NotificationPriority? minimumPriority,
    bool? soundEnabled,
    bool? vibrationEnabled,
    TimeRange? quietHours,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      spawnNotifications: spawnNotifications ?? this.spawnNotifications,
      combatNotifications: combatNotifications ?? this.combatNotifications,
      resourceNotifications:
          resourceNotifications ?? this.resourceNotifications,
      socialNotifications: socialNotifications ?? this.socialNotifications,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      minimumPriority: minimumPriority ?? this.minimumPriority,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHours: quietHours ?? this.quietHours,
    );
  }

  // Helper methods
  bool isTypeEnabled(ARNotificationType type) {
    if (!enabled) return false;

    switch (type) {
      case ARNotificationType.spawn:
        return spawnNotifications;
      case ARNotificationType.combat:
        return combatNotifications;
      case ARNotificationType.resource:
        return resourceNotifications;
      case ARNotificationType.social:
        return socialNotifications;
      case ARNotificationType.achievement:
        return achievementNotifications;
      case ARNotificationType.system:
        return systemNotifications;
    }
  }

  bool isPriorityEnabled(NotificationPriority priority) {
    return priority.sortOrder >= minimumPriority.sortOrder;
  }

  bool shouldShowNotification(ARNotification notification) {
    return enabled &&
        isTypeEnabled(notification.type) &&
        isPriorityEnabled(notification.priority) &&
        !isInQuietHours();
  }

  bool isInQuietHours() {
    if (quietHours == null) return false;
    final now = TimeOfDay.now();
    return quietHours!.contains(now);
  }
}

@JsonSerializable(explicitToJson: true)
class TimeRange extends INetworkModel<TimeRange> {
  @TimeOfDayConverter()
  final TimeOfDay start;
  @TimeOfDayConverter()
  final TimeOfDay end;

  const TimeRange({required this.start, required this.end});

  factory TimeRange.fromJson(Map<String, dynamic> json) =>
      _$TimeRangeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimeRangeToJson(this);

  @override
  TimeRange fromJson(Map<String, dynamic> json) => _$TimeRangeFromJson(json);

  bool contains(TimeOfDay time) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final timeMinutes = time.hour * 60 + time.minute;

    if (startMinutes <= endMinutes) {
      // Same day range
      return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
    } else {
      // Overnight range
      return timeMinutes >= startMinutes || timeMinutes <= endMinutes;
    }
  }

  Duration get duration {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return Duration(minutes: endMinutes - startMinutes);
    } else {
      return Duration(minutes: (24 * 60) - startMinutes + endMinutes);
    }
  }

  String displayText(BuildContext context) {
    return '${start.format(context)} - ${end.format(context)}';
  }
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) =>
      "${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}";
}
