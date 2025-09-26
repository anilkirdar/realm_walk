// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatSession _$CombatSessionFromJson(Map<String, dynamic> json) =>
    CombatSession(
      id: json['id'] as String?,
      playerId: json['playerId'] as String?,
      monsterId: json['monsterId'] as String?,
      monsterStats: json['monsterStats'] as Map<String, dynamic>?,
      playerStats: json['playerStats'] as Map<String, dynamic>?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$CombatSessionToJson(CombatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'monsterId': instance.monsterId,
      'monsterStats': instance.monsterStats,
      'playerStats': instance.playerStats,
      'startTime': instance.startTime?.toIso8601String(),
      'isActive': instance.isActive,
    };
