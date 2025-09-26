// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      characterClass: json['characterClass'] as String?,
      level: (json['level'] as num?)?.toInt(),
      experience: (json['experience'] as num?)?.toInt(),
      stats: json['stats'] == null
          ? null
          : CharacterStats.fromJson(json['stats'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : CharacterLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'characterClass': instance.characterClass,
      'level': instance.level,
      'experience': instance.experience,
      'stats': instance.stats,
      'location': instance.location,
    };

CharacterStats _$CharacterStatsFromJson(Map<String, dynamic> json) =>
    CharacterStats(
      health: json['health'] == null
          ? null
          : HealthStat.fromJson(json['health'] as Map<String, dynamic>),
      mana: json['mana'] == null
          ? null
          : ManaStat.fromJson(json['mana'] as Map<String, dynamic>),
      attack: (json['attack'] as num?)?.toInt(),
      defense: (json['defense'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CharacterStatsToJson(CharacterStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'mana': instance.mana,
      'attack': instance.attack,
      'defense': instance.defense,
      'speed': instance.speed,
    };

HealthStat _$HealthStatFromJson(Map<String, dynamic> json) => HealthStat(
  current: (json['current'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
);

Map<String, dynamic> _$HealthStatToJson(HealthStat instance) =>
    <String, dynamic>{'current': instance.current, 'max': instance.max};

ManaStat _$ManaStatFromJson(Map<String, dynamic> json) => ManaStat(
  current: (json['current'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
);

Map<String, dynamic> _$ManaStatToJson(ManaStat instance) => <String, dynamic>{
  'current': instance.current,
  'max': instance.max,
};

CharacterLocation _$CharacterLocationFromJson(Map<String, dynamic> json) =>
    CharacterLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$CharacterLocationToJson(CharacterLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };
