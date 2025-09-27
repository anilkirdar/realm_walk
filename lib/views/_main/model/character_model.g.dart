// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(
  Map<String, dynamic> json,
) => CharacterModel(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  name: json['name'] as String?,
  characterClass: json['characterClass'] as String?,
  level: (json['level'] as num?)?.toInt(),
  experience: (json['experience'] as num?)?.toInt(),
  experienceToNextLevel: (json['experienceToNextLevel'] as num?)?.toInt(),
  stats: json['stats'] == null
      ? null
      : CharacterStats.fromJson(json['stats'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : CharacterLocation.fromJson(json['location'] as Map<String, dynamic>),
  appearance: json['appearance'] == null
      ? null
      : CharacterAppearance.fromJson(
          json['appearance'] as Map<String, dynamic>,
        ),
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  equipment: json['equipment'] as Map<String, dynamic>?,
  achievements: (json['achievements'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastActive: json['lastActive'] == null
      ? null
      : DateTime.parse(json['lastActive'] as String),
  isOnline: json['isOnline'] as bool?,
  currentActivity: json['currentActivity'] as String?,
  prestigeLevel: (json['prestigeLevel'] as num?)?.toInt(),
  guild: json['guild'] as String?,
);

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'characterClass': instance.characterClass,
      'level': instance.level,
      'experience': instance.experience,
      'experienceToNextLevel': instance.experienceToNextLevel,
      'stats': instance.stats?.toJson(),
      'location': instance.location?.toJson(),
      'appearance': instance.appearance?.toJson(),
      'skills': instance.skills,
      'equipment': instance.equipment,
      'achievements': instance.achievements,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
      'isOnline': instance.isOnline,
      'currentActivity': instance.currentActivity,
      'prestigeLevel': instance.prestigeLevel,
      'guild': instance.guild,
    };

CharacterStats _$CharacterStatsFromJson(Map<String, dynamic> json) =>
    CharacterStats(
      health: json['health'] == null
          ? null
          : HealthStat.fromJson(json['health'] as Map<String, dynamic>),
      mana: json['mana'] == null
          ? null
          : ManaStat.fromJson(json['mana'] as Map<String, dynamic>),
      energy: json['energy'] == null
          ? null
          : EnergyStat.fromJson(json['energy'] as Map<String, dynamic>),
      attack: (json['attack'] as num?)?.toInt(),
      defense: (json['defense'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toInt(),
      intelligence: (json['intelligence'] as num?)?.toInt(),
      luck: (json['luck'] as num?)?.toInt(),
      criticalChance: (json['criticalChance'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      dodgeChance: (json['dodgeChance'] as num?)?.toDouble(),
      totalCombats: (json['totalCombats'] as num?)?.toInt(),
      victories: (json['victories'] as num?)?.toInt(),
      defeats: (json['defeats'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CharacterStatsToJson(CharacterStats instance) =>
    <String, dynamic>{
      'health': instance.health?.toJson(),
      'mana': instance.mana?.toJson(),
      'energy': instance.energy?.toJson(),
      'attack': instance.attack,
      'defense': instance.defense,
      'speed': instance.speed,
      'intelligence': instance.intelligence,
      'luck': instance.luck,
      'criticalChance': instance.criticalChance,
      'accuracy': instance.accuracy,
      'dodgeChance': instance.dodgeChance,
      'totalCombats': instance.totalCombats,
      'victories': instance.victories,
      'defeats': instance.defeats,
    };

HealthStat _$HealthStatFromJson(Map<String, dynamic> json) => HealthStat(
  current: (json['current'] as num).toInt(),
  max: (json['max'] as num).toInt(),
  regeneration: (json['regeneration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HealthStatToJson(HealthStat instance) =>
    <String, dynamic>{
      'current': instance.current,
      'max': instance.max,
      'regeneration': instance.regeneration,
    };

ManaStat _$ManaStatFromJson(Map<String, dynamic> json) => ManaStat(
  current: (json['current'] as num).toInt(),
  max: (json['max'] as num).toInt(),
  regeneration: (json['regeneration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ManaStatToJson(ManaStat instance) => <String, dynamic>{
  'current': instance.current,
  'max': instance.max,
  'regeneration': instance.regeneration,
};

EnergyStat _$EnergyStatFromJson(Map<String, dynamic> json) => EnergyStat(
  current: (json['current'] as num).toInt(),
  max: (json['max'] as num).toInt(),
  regeneration: (json['regeneration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EnergyStatToJson(EnergyStat instance) =>
    <String, dynamic>{
      'current': instance.current,
      'max': instance.max,
      'regeneration': instance.regeneration,
    };

CharacterLocation _$CharacterLocationFromJson(Map<String, dynamic> json) =>
    CharacterLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      region: json['region'] as String?,
      biome: json['biome'] as String?,
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$CharacterLocationToJson(CharacterLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'region': instance.region,
      'biome': instance.biome,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };

CharacterAppearance _$CharacterAppearanceFromJson(Map<String, dynamic> json) =>
    CharacterAppearance(
      gender: json['gender'] as String?,
      skinColor: json['skinColor'] as String?,
      hairColor: json['hairColor'] as String?,
      hairStyle: json['hairStyle'] as String?,
      eyeColor: json['eyeColor'] as String?,
      faceStyle: json['faceStyle'] as String?,
      customization: (json['customization'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$CharacterAppearanceToJson(
  CharacterAppearance instance,
) => <String, dynamic>{
  'gender': instance.gender,
  'skinColor': instance.skinColor,
  'hairColor': instance.hairColor,
  'hairStyle': instance.hairStyle,
  'eyeColor': instance.eyeColor,
  'faceStyle': instance.faceStyle,
  'customization': instance.customization,
};
