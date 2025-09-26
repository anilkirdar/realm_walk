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
  location: json['location'] == null
      ? null
      : ARLocation.fromJson(json['location'] as Map<String, dynamic>),
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
);

Map<String, dynamic> _$ARMonsterToJson(ARMonster instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'name': instance.name,
  'level': instance.level,
  'location': instance.location?.toJson(),
  'stats': instance.stats?.toJson(),
  'timeLeft': instance.timeLeft,
  'isPersonal': instance.isPersonal,
  'biome': instance.biome,
  'altitude': instance.altitude,
  'ownerId': instance.ownerId,
  'spawnSeed': instance.spawnSeed,
  'spawnIndex': instance.spawnIndex,
};

ARLocation _$ARLocationFromJson(Map<String, dynamic> json) => ARLocation(
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ARLocationToJson(ARLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
    };

ARResource _$ARResourceFromJson(Map<String, dynamic> json) => ARResource(
  id: json['id'] as String?,
  type: json['type'] as String?,
  location: json['location'] == null
      ? null
      : ARLocation.fromJson(json['location'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt(),
  quality: json['quality'] as String?,
  timeLeft: (json['timeLeft'] as num?)?.toInt(),
  biome: json['biome'] as String?,
);

Map<String, dynamic> _$ARResourceToJson(ARResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'location': instance.location?.toJson(),
      'quantity': instance.quantity,
      'quality': instance.quality,
      'timeLeft': instance.timeLeft,
      'biome': instance.biome,
    };

MonsterStats _$MonsterStatsFromJson(Map<String, dynamic> json) => MonsterStats(
  health: (json['health'] as num?)?.toInt(),
  maxHealth: (json['maxHealth'] as num?)?.toInt(),
  attack: (json['attack'] as num?)?.toInt(),
  defense: (json['defense'] as num?)?.toInt(),
  experienceReward: (json['experienceReward'] as num?)?.toInt(),
);

Map<String, dynamic> _$MonsterStatsToJson(MonsterStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'attack': instance.attack,
      'defense': instance.defense,
      'experienceReward': instance.experienceReward,
    };

PersonalSpawnData _$PersonalSpawnDataFromJson(Map<String, dynamic> json) =>
    PersonalSpawnData(
      monsters: (json['monsters'] as List<dynamic>)
          .map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalGenerated: (json['totalGenerated'] as num?)?.toInt() ?? 0,
      spawnReason: json['spawnReason'] as String? ?? 'periodic',
    );

Map<String, dynamic> _$PersonalSpawnDataToJson(PersonalSpawnData instance) =>
    <String, dynamic>{
      'monsters': instance.monsters.map((e) => e.toJson()).toList(),
      'totalGenerated': instance.totalGenerated,
      'spawnReason': instance.spawnReason,
    };

ProximitySpawnData _$ProximitySpawnDataFromJson(Map<String, dynamic> json) =>
    ProximitySpawnData(
      monsters: (json['monsters'] as List<dynamic>)
          .map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList(),
      movementDistance: (json['movementDistance'] as num?)?.toDouble() ?? 0.0,
      spawnTrigger: json['spawnTrigger'] as String? ?? 'movement',
    );

Map<String, dynamic> _$ProximitySpawnDataToJson(ProximitySpawnData instance) =>
    <String, dynamic>{
      'monsters': instance.monsters.map((e) => e.toJson()).toList(),
      'movementDistance': instance.movementDistance,
      'spawnTrigger': instance.spawnTrigger,
    };

SpawnDensityInfo _$SpawnDensityInfoFromJson(Map<String, dynamic> json) =>
    SpawnDensityInfo(
      monsterDensity: (json['monsterDensity'] as num?)?.toDouble() ?? 0.5,
      resourceDensity: (json['resourceDensity'] as num?)?.toDouble() ?? 0.3,
      biome: json['biome'] as String? ?? 'temperate',
      populationLevel: json['populationLevel'] as String? ?? 'medium',
      spawnRates:
          (json['spawnRates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$SpawnDensityInfoToJson(SpawnDensityInfo instance) =>
    <String, dynamic>{
      'monsterDensity': instance.monsterDensity,
      'resourceDensity': instance.resourceDensity,
      'biome': instance.biome,
      'populationLevel': instance.populationLevel,
      'spawnRates': instance.spawnRates,
    };

ARObjectsResponse _$ARObjectsResponseFromJson(Map<String, dynamic> json) =>
    ARObjectsResponse(
      monsters:
          (json['monsters'] as List<dynamic>?)
              ?.map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      resources:
          (json['resources'] as List<dynamic>?)
              ?.map((e) => ARResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      personalMonsters:
          (json['personalMonsters'] as List<dynamic>?)
              ?.map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ARObjectsResponseToJson(
  ARObjectsResponse instance,
) => <String, dynamic>{
  'monsters': instance.monsters.map((e) => e.toJson()).toList(),
  'resources': instance.resources.map((e) => e.toJson()).toList(),
  'personalMonsters': instance.personalMonsters.map((e) => e.toJson()).toList(),
  'timestamp': instance.timestamp?.toIso8601String(),
};

PersonalSpawnsResponse _$PersonalSpawnsResponseFromJson(
  Map<String, dynamic> json,
) => PersonalSpawnsResponse(
  monsters:
      (json['monsters'] as List<dynamic>?)
          ?.map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  spawnRadius: (json['spawnRadius'] as num?)?.toInt(),
  nextSpawnTime: json['nextSpawnTime'] == null
      ? null
      : DateTime.parse(json['nextSpawnTime'] as String),
);

Map<String, dynamic> _$PersonalSpawnsResponseToJson(
  PersonalSpawnsResponse instance,
) => <String, dynamic>{
  'monsters': instance.monsters.map((e) => e.toJson()).toList(),
  'spawnRadius': instance.spawnRadius,
  'nextSpawnTime': instance.nextSpawnTime?.toIso8601String(),
};

NearbyPlayer _$NearbyPlayerFromJson(Map<String, dynamic> json) => NearbyPlayer(
  playerId: json['playerId'] as String?,
  name: json['name'] as String?,
  level: (json['level'] as num?)?.toInt(),
  characterClass: json['characterClass'] as String?,
  position: _$JsonConverterFromJson<Map<String, dynamic>, Position>(
    json['position'],
    const PositionConverter().fromJson,
  ),
  isFriend: json['isFriend'] as bool?,
  isGuildMember: json['isGuildMember'] as bool?,
  lastSeen: json['lastSeen'] == null
      ? null
      : DateTime.parse(json['lastSeen'] as String),
);

Map<String, dynamic> _$NearbyPlayerToJson(NearbyPlayer instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'name': instance.name,
      'level': instance.level,
      'characterClass': instance.characterClass,
      'position': _$JsonConverterToJson<Map<String, dynamic>, Position>(
        instance.position,
        const PositionConverter().toJson,
      ),
      'isFriend': instance.isFriend,
      'isGuildMember': instance.isGuildMember,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

FriendLocation _$FriendLocationFromJson(Map<String, dynamic> json) =>
    FriendLocation(
      friendId: json['friendId'] as String?,
      name: json['name'] as String?,
      position: _$JsonConverterFromJson<Map<String, dynamic>, Position>(
        json['position'],
        const PositionConverter().fromJson,
      ),
      isOnline: json['isOnline'] as bool?,
      guildEmblem: json['guildEmblem'] as String?,
    );

Map<String, dynamic> _$FriendLocationToJson(FriendLocation instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'name': instance.name,
      'position': _$JsonConverterToJson<Map<String, dynamic>, Position>(
        instance.position,
        const PositionConverter().toJson,
      ),
      'isOnline': instance.isOnline,
      'guildEmblem': instance.guildEmblem,
    };

ARStats _$ARStatsFromJson(Map<String, dynamic> json) => ARStats(
  totalMonsters: (json['totalMonsters'] as num?)?.toInt(),
  monstersInRange: (json['monstersInRange'] as num?)?.toInt(),
  personalMonsters: (json['personalMonsters'] as num?)?.toInt(),
  resources: (json['resources'] as num?)?.toInt(),
  nearbyPlayers: (json['nearbyPlayers'] as num?)?.toInt(),
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ARStatsToJson(ARStats instance) => <String, dynamic>{
  'totalMonsters': instance.totalMonsters,
  'monstersInRange': instance.monstersInRange,
  'personalMonsters': instance.personalMonsters,
  'resources': instance.resources,
  'nearbyPlayers': instance.nearbyPlayers,
  'timestamp': instance.timestamp?.toIso8601String(),
};
