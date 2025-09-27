// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerSkill _$PlayerSkillFromJson(Map<String, dynamic> json) => PlayerSkill(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$SkillTypeEnumMap, json['type']),
  target: $enumDecode(_$SkillTargetEnumMap, json['target']),
  level: (json['level'] as num).toInt(),
  maxLevel: (json['maxLevel'] as num?)?.toInt() ?? 10,
  manaCost: (json['manaCost'] as num).toInt(),
  cooldown: (json['cooldown'] as num).toInt(),
  effects: json['effects'] as Map<String, dynamic>,
  iconPath: json['iconPath'] as String?,
  isUnlocked: json['isUnlocked'] as bool? ?? false,
  requiredLevel: (json['requiredLevel'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$PlayerSkillToJson(PlayerSkill instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$SkillTypeEnumMap[instance.type]!,
      'target': _$SkillTargetEnumMap[instance.target]!,
      'level': instance.level,
      'maxLevel': instance.maxLevel,
      'manaCost': instance.manaCost,
      'cooldown': instance.cooldown,
      'effects': instance.effects,
      'iconPath': instance.iconPath,
      'isUnlocked': instance.isUnlocked,
      'requiredLevel': instance.requiredLevel,
    };

const _$SkillTypeEnumMap = {
  SkillType.attack: 'attack',
  SkillType.defense: 'defense',
  SkillType.magic: 'magic',
  SkillType.heal: 'heal',
  SkillType.special: 'special',
  SkillType.passive: 'passive',
};

const _$SkillTargetEnumMap = {
  SkillTarget.self: 'self',
  SkillTarget.enemy: 'enemy',
  SkillTarget.ally: 'ally',
  SkillTarget.area: 'area',
  SkillTarget.all_enemies: 'all_enemies',
  SkillTarget.all_allies: 'all_allies',
};

SkillEffect _$SkillEffectFromJson(Map<String, dynamic> json) => SkillEffect(
  type: json['type'] as String,
  value: (json['value'] as num).toDouble(),
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  target: $enumDecode(_$SkillTargetEnumMap, json['target']),
  properties: json['properties'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$SkillEffectToJson(SkillEffect instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'duration': instance.duration,
      'target': _$SkillTargetEnumMap[instance.target]!,
      'properties': instance.properties,
    };

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => PlayerStats(
  health: (json['health'] as num).toInt(),
  maxHealth: (json['maxHealth'] as num).toInt(),
  mana: (json['mana'] as num).toInt(),
  maxMana: (json['maxMana'] as num).toInt(),
  attack: (json['attack'] as num).toInt(),
  defense: (json['defense'] as num).toInt(),
  speed: (json['speed'] as num).toInt(),
  level: (json['level'] as num).toInt(),
  experience: (json['experience'] as num).toInt(),
  energy: (json['energy'] as num).toInt(),
  maxEnergy: (json['maxEnergy'] as num).toInt(),
);

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'mana': instance.mana,
      'maxMana': instance.maxMana,
      'attack': instance.attack,
      'defense': instance.defense,
      'speed': instance.speed,
      'level': instance.level,
      'experience': instance.experience,
      'energy': instance.energy,
      'maxEnergy': instance.maxEnergy,
    };
