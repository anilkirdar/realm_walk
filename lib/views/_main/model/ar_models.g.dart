// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ARMonster _$ARMonsterFromJson(Map<String, dynamic> json) => ARMonster(
  id: json['id'] as String?,
  type: json['type'] as String?,
  name: json['name'] as String?,
  level: (json['level'] as num?)?.toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  distance: (json['distance'] as num?)?.toDouble(),
  health: (json['health'] as num?)?.toInt(),
  maxHealth: (json['maxHealth'] as num?)?.toInt(),
  stats: json['stats'] == null
      ? null
      : MonsterStats.fromJson(json['stats'] as Map<String, dynamic>),
  timeLeft: (json['timeLeft'] as num?)?.toInt(),
  isPersonal: json['isPersonal'] as bool? ?? false,
  biome: json['biome'] as String?,
  altitude: (json['altitude'] as num?)?.toDouble(),
  ownerId: json['ownerId'] as String?,
  spawnSeed: (json['spawnSeed'] as num?)?.toInt(),
  spawnIndex: (json['spawnIndex'] as num?)?.toInt(),
  rarity: json['rarity'] as String?,
  abilities: (json['abilities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  spawnTime: json['spawnTime'] == null
      ? null
      : DateTime.parse(json['spawnTime'] as String),
  despawnTime: json['despawnTime'] == null
      ? null
      : DateTime.parse(json['despawnTime'] as String),
);

Map<String, dynamic> _$ARMonsterToJson(ARMonster instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'name': instance.name,
  'level': instance.level,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'distance': instance.distance,
  'health': instance.health,
  'maxHealth': instance.maxHealth,
  'stats': instance.stats?.toJson(),
  'timeLeft': instance.timeLeft,
  'isPersonal': instance.isPersonal,
  'biome': instance.biome,
  'altitude': instance.altitude,
  'ownerId': instance.ownerId,
  'spawnSeed': instance.spawnSeed,
  'spawnIndex': instance.spawnIndex,
  'rarity': instance.rarity,
  'abilities': instance.abilities,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'spawnTime': instance.spawnTime?.toIso8601String(),
  'despawnTime': instance.despawnTime?.toIso8601String(),
};

ARResource _$ARResourceFromJson(Map<String, dynamic> json) => ARResource(
  id: json['id'] as String?,
  type: json['type'] as String?,
  name: json['name'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  distance: (json['distance'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num?)?.toInt(),
  quality: json['quality'] as String?,
  timeLeft: (json['timeLeft'] as num?)?.toInt(),
  biome: json['biome'] as String?,
  altitude: (json['altitude'] as num?)?.toDouble(),
  rarity: json['rarity'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  spawnTime: json['spawnTime'] == null
      ? null
      : DateTime.parse(json['spawnTime'] as String),
  despawnTime: json['despawnTime'] == null
      ? null
      : DateTime.parse(json['despawnTime'] as String),
  isHarvestable: json['isHarvestable'] as bool?,
  harvestAmount: (json['harvestAmount'] as num?)?.toInt(),
  harvestTime: json['harvestTime'] == null
      ? null
      : Duration(microseconds: (json['harvestTime'] as num).toInt()),
);

Map<String, dynamic> _$ARResourceToJson(ARResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'timeLeft': instance.timeLeft,
      'biome': instance.biome,
      'altitude': instance.altitude,
      'rarity': instance.rarity,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'spawnTime': instance.spawnTime?.toIso8601String(),
      'despawnTime': instance.despawnTime?.toIso8601String(),
      'isHarvestable': instance.isHarvestable,
      'harvestAmount': instance.harvestAmount,
      'harvestTime': instance.harvestTime?.inMicroseconds,
    };

MonsterStats _$MonsterStatsFromJson(Map<String, dynamic> json) => MonsterStats(
  health: (json['health'] as num?)?.toInt(),
  maxHealth: (json['maxHealth'] as num?)?.toInt(),
  attack: (json['attack'] as num?)?.toInt(),
  defense: (json['defense'] as num?)?.toInt(),
  speed: (json['speed'] as num?)?.toInt(),
  experience: (json['experience'] as num?)?.toInt(),
  weaknesses: (json['weaknesses'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  resistances: (json['resistances'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$MonsterStatsToJson(MonsterStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'attack': instance.attack,
      'defense': instance.defense,
      'speed': instance.speed,
      'experience': instance.experience,
      'weaknesses': instance.weaknesses,
      'resistances': instance.resistances,
    };

SpawnDensityInfo _$SpawnDensityInfoFromJson(Map<String, dynamic> json) =>
    SpawnDensityInfo(
      monsterDensity: (json['monsterDensity'] as num?)?.toDouble(),
      resourceDensity: (json['resourceDensity'] as num?)?.toDouble(),
      nearbyMonsters: (json['nearbyMonsters'] as num?)?.toInt(),
      nearbyResources: (json['nearbyResources'] as num?)?.toInt(),
      biome: json['biome'] as String?,
      spawnRate: (json['spawnRate'] as num?)?.toDouble(),
      maxSpawns: (json['maxSpawns'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpawnDensityInfoToJson(SpawnDensityInfo instance) =>
    <String, dynamic>{
      'monsterDensity': instance.monsterDensity,
      'resourceDensity': instance.resourceDensity,
      'nearbyMonsters': instance.nearbyMonsters,
      'nearbyResources': instance.nearbyResources,
      'biome': instance.biome,
      'spawnRate': instance.spawnRate,
      'maxSpawns': instance.maxSpawns,
    };
