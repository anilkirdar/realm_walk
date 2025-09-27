// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_objects_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ARObjectsData _$ARObjectsDataFromJson(Map<String, dynamic> json) =>
    ARObjectsData(
      monsters: (json['monsters'] as List<dynamic>)
          .map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList(),
      resources: (json['resources'] as List<dynamic>)
          .map((e) => ARResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      personalMonsters: (json['personalMonsters'] as List<dynamic>)
          .map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList(),
      spawnInfo: json['spawnInfo'] == null
          ? null
          : SpawnDensityInfo.fromJson(
              json['spawnInfo'] as Map<String, dynamic>,
            ),
      biome: json['biome'] as String?,
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radius: (json['radius'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ARObjectsDataToJson(
  ARObjectsData instance,
) => <String, dynamic>{
  'monsters': instance.monsters.map((e) => e.toJson()).toList(),
  'resources': instance.resources.map((e) => e.toJson()).toList(),
  'personalMonsters': instance.personalMonsters.map((e) => e.toJson()).toList(),
  'spawnInfo': instance.spawnInfo?.toJson(),
  'biome': instance.biome,
  'lastUpdate': instance.lastUpdate?.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'radius': instance.radius,
};

PersonalSpawnData _$PersonalSpawnDataFromJson(Map<String, dynamic> json) =>
    PersonalSpawnData(
      monsters: (json['monsters'] as List<dynamic>)
          .map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList(),
      resources: (json['resources'] as List<dynamic>)
          .map((e) => ARResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      playerId: json['playerId'] as String?,
      spawnTime: json['spawnTime'] == null
          ? null
          : DateTime.parse(json['spawnTime'] as String),
      cooldownSeconds: (json['cooldownSeconds'] as num?)?.toInt(),
      maxSpawns: (json['maxSpawns'] as num?)?.toInt(),
      spawnRadius: (json['spawnRadius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PersonalSpawnDataToJson(PersonalSpawnData instance) =>
    <String, dynamic>{
      'monsters': instance.monsters.map((e) => e.toJson()).toList(),
      'resources': instance.resources.map((e) => e.toJson()).toList(),
      'playerId': instance.playerId,
      'spawnTime': instance.spawnTime?.toIso8601String(),
      'cooldownSeconds': instance.cooldownSeconds,
      'maxSpawns': instance.maxSpawns,
      'spawnRadius': instance.spawnRadius,
    };
