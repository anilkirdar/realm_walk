// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatAction _$CombatActionFromJson(Map<String, dynamic> json) => CombatAction(
  id: json['id'] as String?,
  gestureType: $enumDecodeNullable(_$GestureTypeEnumMap, json['gestureType']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  baseDamage: (json['baseDamage'] as num?)?.toInt(),
  manaCost: (json['manaCost'] as num?)?.toInt() ?? 0,
  energyCost: (json['energyCost'] as num?)?.toInt() ?? 10,
  cooldown: json['cooldown'] == null
      ? const Duration(seconds: 1)
      : Duration(microseconds: (json['cooldown'] as num).toInt()),
  animation: json['animation'] as String?,
  effectEmoji: json['effectEmoji'] as String?,
);

Map<String, dynamic> _$CombatActionToJson(CombatAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gestureType': _$GestureTypeEnumMap[instance.gestureType],
      'name': instance.name,
      'description': instance.description,
      'baseDamage': instance.baseDamage,
      'manaCost': instance.manaCost,
      'energyCost': instance.energyCost,
      'cooldown': instance.cooldown.inMicroseconds,
      'animation': instance.animation,
      'effectEmoji': instance.effectEmoji,
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
  health: (json['health'] as num?)?.toInt(),
  maxHealth: (json['maxHealth'] as num?)?.toInt(),
  mana: (json['mana'] as num?)?.toInt(),
  maxMana: (json['maxMana'] as num?)?.toInt(),
  energy: (json['energy'] as num?)?.toInt(),
  maxEnergy: (json['maxEnergy'] as num?)?.toInt(),
  attack: (json['attack'] as num?)?.toInt(),
  defense: (json['defense'] as num?)?.toInt(),
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
    };

CombatResult _$CombatResultFromJson(Map<String, dynamic> json) => CombatResult(
  damage: (json['damage'] as num?)?.toInt(),
  isCritical: json['isCritical'] as bool? ?? false,
  isBlocked: json['isBlocked'] as bool? ?? false,
  effectDescription: json['effectDescription'] as String?,
  stunDuration: json['stunDuration'] == null
      ? Duration.zero
      : Duration(microseconds: (json['stunDuration'] as num).toInt()),
);

Map<String, dynamic> _$CombatResultToJson(CombatResult instance) =>
    <String, dynamic>{
      'damage': instance.damage,
      'isCritical': instance.isCritical,
      'isBlocked': instance.isBlocked,
      'effectDescription': instance.effectDescription,
      'stunDuration': instance.stunDuration?.inMicroseconds,
    };
