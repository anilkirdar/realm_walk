// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatSession _$CombatSessionFromJson(Map<String, dynamic> json) =>
    CombatSession(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      monsterId: json['monsterId'] as String,
      monster: json['monster'] == null
          ? null
          : ARMonster.fromJson(json['monster'] as Map<String, dynamic>),
      playerStats: CombatStats.fromJson(
        json['playerStats'] as Map<String, dynamic>,
      ),
      monsterStats: CombatStats.fromJson(
        json['monsterStats'] as Map<String, dynamic>,
      ),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$CombatSessionStatusEnumMap, json['status']),
      turns:
          (json['turns'] as List<dynamic>?)
              ?.map((e) => CombatTurn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      playerLatitude: (json['playerLatitude'] as num?)?.toDouble(),
      playerLongitude: (json['playerLongitude'] as num?)?.toDouble(),
      sessionType: json['sessionType'] as String?,
    );

Map<String, dynamic> _$CombatSessionToJson(CombatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'monsterId': instance.monsterId,
      'monster': instance.monster?.toJson(),
      'playerStats': instance.playerStats.toJson(),
      'monsterStats': instance.monsterStats.toJson(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$CombatSessionStatusEnumMap[instance.status]!,
      'turns': instance.turns.map((e) => e.toJson()).toList(),
      'playerLatitude': instance.playerLatitude,
      'playerLongitude': instance.playerLongitude,
      'sessionType': instance.sessionType,
    };

const _$CombatSessionStatusEnumMap = {
  CombatSessionStatus.pending: 'pending',
  CombatSessionStatus.active: 'active',
  CombatSessionStatus.completed: 'completed',
  CombatSessionStatus.abandoned: 'abandoned',
  CombatSessionStatus.expired: 'expired',
};

CombatTurn _$CombatTurnFromJson(Map<String, dynamic> json) => CombatTurn(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  turnNumber: (json['turnNumber'] as num).toInt(),
  isPlayerTurn: json['isPlayerTurn'] as bool,
  actionId: json['actionId'] as String?,
  actionName: json['actionName'] as String?,
  damage: (json['damage'] as num?)?.toInt(),
  isCritical: json['isCritical'] as bool?,
  isMiss: json['isMiss'] as bool?,
  statusEffects: (json['statusEffects'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  statsAfterTurn: json['statsAfterTurn'] == null
      ? null
      : CombatStats.fromJson(json['statsAfterTurn'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CombatTurnToJson(CombatTurn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'turnNumber': instance.turnNumber,
      'isPlayerTurn': instance.isPlayerTurn,
      'actionId': instance.actionId,
      'actionName': instance.actionName,
      'damage': instance.damage,
      'isCritical': instance.isCritical,
      'isMiss': instance.isMiss,
      'statusEffects': instance.statusEffects,
      'timestamp': instance.timestamp.toIso8601String(),
      'statsAfterTurn': instance.statsAfterTurn?.toJson(),
    };
