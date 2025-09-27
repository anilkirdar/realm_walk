// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatAction _$CombatActionFromJson(Map<String, dynamic> json) => CombatAction(
  id: json['id'] as String,
  gestureType: $enumDecode(_$GestureTypeEnumMap, json['gestureType']),
  name: json['name'] as String,
  description: json['description'] as String,
  baseDamage: (json['baseDamage'] as num).toInt(),
  manaCost: (json['manaCost'] as num?)?.toInt() ?? 0,
  energyCost: (json['energyCost'] as num?)?.toInt() ?? 10,
  cooldown: json['cooldown'] == null
      ? null
      : Duration(microseconds: (json['cooldown'] as num).toInt()),
  animation: json['animation'] as String?,
  effectEmoji: json['effectEmoji'] as String?,
  soundEffect: json['soundEffect'] as String?,
  criticalChance: (json['criticalChance'] as num?)?.toDouble(),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
  statusEffects: (json['statusEffects'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  characterClass: json['characterClass'] as String?,
  minimumLevel: (json['minimumLevel'] as num?)?.toInt(),
);

Map<String, dynamic> _$CombatActionToJson(CombatAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gestureType': _$GestureTypeEnumMap[instance.gestureType]!,
      'name': instance.name,
      'description': instance.description,
      'baseDamage': instance.baseDamage,
      'manaCost': instance.manaCost,
      'energyCost': instance.energyCost,
      'cooldown': instance.cooldown?.inMicroseconds,
      'animation': instance.animation,
      'effectEmoji': instance.effectEmoji,
      'soundEffect': instance.soundEffect,
      'criticalChance': instance.criticalChance,
      'accuracy': instance.accuracy,
      'statusEffects': instance.statusEffects,
      'characterClass': instance.characterClass,
      'minimumLevel': instance.minimumLevel,
    };

const _$GestureTypeEnumMap = {
  GestureType.punch: 'punch',
  GestureType.uppercut: 'uppercut',
  GestureType.block: 'block',
  GestureType.dodge: 'dodge',
  GestureType.spin: 'spin',
  GestureType.fireball: 'fireball',
  GestureType.heal: 'heal',
  GestureType.charge: 'charge',
  GestureType.none: 'none',
};

CombatStats _$CombatStatsFromJson(Map<String, dynamic> json) => CombatStats(
  health: (json['health'] as num?)?.toInt() ?? 100,
  maxHealth: (json['maxHealth'] as num?)?.toInt() ?? 100,
  mana: (json['mana'] as num?)?.toInt() ?? 50,
  maxMana: (json['maxMana'] as num?)?.toInt() ?? 50,
  energy: (json['energy'] as num?)?.toInt() ?? 100,
  maxEnergy: (json['maxEnergy'] as num?)?.toInt() ?? 100,
  attack: (json['attack'] as num?)?.toInt() ?? 10,
  defense: (json['defense'] as num?)?.toInt() ?? 5,
  level: (json['level'] as num?)?.toInt() ?? 1,
  experience: (json['experience'] as num?)?.toInt() ?? 0,
  experienceToNextLevel:
      (json['experienceToNextLevel'] as num?)?.toInt() ?? 100,
  criticalChance: (json['criticalChance'] as num?)?.toDouble(),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
  dodgeChance: (json['dodgeChance'] as num?)?.toDouble(),
  blockChance: (json['blockChance'] as num?)?.toDouble(),
  combatsWon: (json['combatsWon'] as num?)?.toInt(),
  combatsLost: (json['combatsLost'] as num?)?.toInt(),
  totalDamageDealt: (json['totalDamageDealt'] as num?)?.toInt(),
  totalDamageReceived: (json['totalDamageReceived'] as num?)?.toInt(),
);

Map<String, dynamic> _$CombatStatsToJson(CombatStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'mana': instance.mana,
      'maxMana': instance.maxMana,
      'energy': instance.energy,
      'maxEnergy': instance.maxEnergy,
      'attack': instance.attack,
      'defense': instance.defense,
      'level': instance.level,
      'experience': instance.experience,
      'experienceToNextLevel': instance.experienceToNextLevel,
      'criticalChance': instance.criticalChance,
      'accuracy': instance.accuracy,
      'dodgeChance': instance.dodgeChance,
      'blockChance': instance.blockChance,
      'combatsWon': instance.combatsWon,
      'combatsLost': instance.combatsLost,
      'totalDamageDealt': instance.totalDamageDealt,
      'totalDamageReceived': instance.totalDamageReceived,
    };

CombatActionResult _$CombatActionResultFromJson(Map<String, dynamic> json) =>
    CombatActionResult(
      success: json['success'] as bool,
      damage: (json['damage'] as num).toInt(),
      isCritical: json['isCritical'] as bool? ?? false,
      isMiss: json['isMiss'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isDodged: json['isDodged'] as bool? ?? false,
      message: json['message'] as String,
      actionId: json['actionId'] as String?,
      appliedEffects: (json['appliedEffects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedPlayerStats: json['updatedPlayerStats'] == null
          ? null
          : CombatStats.fromJson(
              json['updatedPlayerStats'] as Map<String, dynamic>,
            ),
      updatedEnemyStats: json['updatedEnemyStats'] == null
          ? null
          : CombatStats.fromJson(
              json['updatedEnemyStats'] as Map<String, dynamic>,
            ),
      animationDuration: (json['animationDuration'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CombatActionResultToJson(CombatActionResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'damage': instance.damage,
      'isCritical': instance.isCritical,
      'isMiss': instance.isMiss,
      'isBlocked': instance.isBlocked,
      'isDodged': instance.isDodged,
      'message': instance.message,
      'actionId': instance.actionId,
      'appliedEffects': instance.appliedEffects,
      'updatedPlayerStats': instance.updatedPlayerStats?.toJson(),
      'updatedEnemyStats': instance.updatedEnemyStats?.toJson(),
      'animationDuration': instance.animationDuration,
    };

CombatResult _$CombatResultFromJson(Map<String, dynamic> json) => CombatResult(
  isVictory: json['isVictory'] as bool,
  totalDamageDealt: (json['totalDamageDealt'] as num).toInt(),
  totalDamageReceived: (json['totalDamageReceived'] as num).toInt(),
  combatDuration: Duration(
    microseconds: (json['combatDuration'] as num).toInt(),
  ),
  actionsPerformed: (json['actionsPerformed'] as num).toInt(),
  criticalHits: (json['criticalHits'] as num?)?.toInt() ?? 0,
  missedAttacks: (json['missedAttacks'] as num?)?.toInt() ?? 0,
  blockedAttacks: (json['blockedAttacks'] as num?)?.toInt() ?? 0,
  dodgedAttacks: (json['dodgedAttacks'] as num?)?.toInt() ?? 0,
  usedActions: (json['usedActions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  finalPlayerStats: json['finalPlayerStats'] == null
      ? null
      : CombatStats.fromJson(json['finalPlayerStats'] as Map<String, dynamic>),
  finalEnemyStats: json['finalEnemyStats'] == null
      ? null
      : CombatStats.fromJson(json['finalEnemyStats'] as Map<String, dynamic>),
  combatRating: json['combatRating'] as String?,
  combatData: json['combatData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CombatResultToJson(CombatResult instance) =>
    <String, dynamic>{
      'isVictory': instance.isVictory,
      'totalDamageDealt': instance.totalDamageDealt,
      'totalDamageReceived': instance.totalDamageReceived,
      'combatDuration': instance.combatDuration.inMicroseconds,
      'actionsPerformed': instance.actionsPerformed,
      'criticalHits': instance.criticalHits,
      'missedAttacks': instance.missedAttacks,
      'blockedAttacks': instance.blockedAttacks,
      'dodgedAttacks': instance.dodgedAttacks,
      'usedActions': instance.usedActions,
      'finalPlayerStats': instance.finalPlayerStats?.toJson(),
      'finalEnemyStats': instance.finalEnemyStats?.toJson(),
      'combatRating': instance.combatRating,
      'combatData': instance.combatData,
    };
