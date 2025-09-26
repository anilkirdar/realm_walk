// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'ar_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ARMonster extends INetworkModel<ARMonster> {
  final String? id;
  final String? type;
  final String? name;
  final int? level;
  final ARLocation? location;
  final MonsterStats? stats;
  final int? timeLeft;
  final bool isPersonal; // Kişiye özel spawn mı?
  final String? biome; // Hangi biome'da spawn oldu
  final double? altitude; // Yükseklik bilgisi
  final String? ownerId; // Personal spawn için owner
  final int? spawnSeed; // Deterministic spawn için
  final int? spawnIndex; // Spawn sırası

  const ARMonster({
    this.id,
    this.type,
    this.name,
    this.level,
    this.location,
    this.stats,
    this.timeLeft,
    this.isPersonal = false,
    this.biome,
    this.altitude,
    this.ownerId,
    this.spawnSeed,
    this.spawnIndex,
  });

  factory ARMonster.fromJson(Map<String, dynamic> json) =>
      _$ARMonsterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARMonsterToJson(this);

  @override
  ARMonster fromJson(Map<String, dynamic> json) => _$ARMonsterFromJson(json);

  ARMonster copyWith({
    String? id,
    String? type,
    String? name,
    int? level,
    ARLocation? location,
    MonsterStats? stats,
    int? timeLeft,
    bool? isPersonal,
    String? biome,
    double? altitude,
    String? ownerId,
    int? spawnSeed,
    int? spawnIndex,
  }) {
    return ARMonster(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      level: level ?? this.level,
      location: location ?? this.location,
      stats: stats ?? this.stats,
      timeLeft: timeLeft ?? this.timeLeft,
      isPersonal: isPersonal ?? this.isPersonal,
      biome: biome ?? this.biome,
      altitude: altitude ?? this.altitude,
      ownerId: ownerId ?? this.ownerId,
      spawnSeed: spawnSeed ?? this.spawnSeed,
      spawnIndex: spawnIndex ?? this.spawnIndex,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ARLocation {
  final double? latitude;
  final double? longitude;
  final double? altitude;

  ARLocation({this.latitude, this.longitude, this.altitude = 0.0});

  factory ARLocation.fromJson(Map<String, dynamic> json) =>
      _$ARLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ARLocationToJson(this);

  ARLocation fromJson(Map<String, dynamic> json) => _$ARLocationFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ARResource {
  final String? id;
  final String? type;
  final ARLocation? location;
  final int? quantity;
  final String? quality;
  final int? timeLeft;
  final String? biome;

  ARResource({
    this.id,
    this.type,
    this.location,
    this.quantity,
    this.quality,
    this.timeLeft,
    this.biome,
  });

  factory ARResource.fromJson(Map<String, dynamic> json) =>
      _$ARResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ARResourceToJson(this);
}

@JsonSerializable()
class MonsterStats {
  final int? health;
  final int? maxHealth;
  final int? attack;
  final int? defense;
  final int? experienceReward;

  MonsterStats({
    this.health,
    this.maxHealth,
    this.attack,
    this.defense,
    this.experienceReward,
  });

  factory MonsterStats.fromJson(Map<String, dynamic> json) =>
      _$MonsterStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MonsterStatsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PersonalSpawnData extends INetworkModel<PersonalSpawnData> {
  final List<ARMonster> monsters;
  final int totalGenerated;
  final String spawnReason;

  const PersonalSpawnData({
    this.monsters = const [],
    this.totalGenerated = 0,
    this.spawnReason = 'periodic',
  });

  factory PersonalSpawnData.fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnDataFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalSpawnDataToJson(this);

  @override
  PersonalSpawnData fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnDataFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ProximitySpawnData extends INetworkModel<ProximitySpawnData> {
  final List<ARMonster> monsters;
  final double movementDistance;
  final String spawnTrigger;

  const ProximitySpawnData({
    this.monsters = const [],
    this.movementDistance = 0.0,
    this.spawnTrigger = 'movement',
  });

  factory ProximitySpawnData.fromJson(Map<String, dynamic> json) =>
      _$ProximitySpawnDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProximitySpawnDataToJson(this);

  @override
  ProximitySpawnData fromJson(Map<String, dynamic> json) =>
      _$ProximitySpawnDataFromJson(json);
}

@JsonSerializable()
class SpawnDensityInfo extends INetworkModel<SpawnDensityInfo> {
  final double monsterDensity;
  final double resourceDensity;
  final String biome;
  final String populationLevel;
  final Map<String, int> spawnRates;

  const SpawnDensityInfo({
    this.monsterDensity = 0.5,
    this.resourceDensity = 0.3,
    this.biome = 'temperate',
    this.populationLevel = 'medium',
    this.spawnRates = const {},
  });

  factory SpawnDensityInfo.fromJson(Map<String, dynamic> json) =>
      _$SpawnDensityInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SpawnDensityInfoToJson(this);

  @override
  SpawnDensityInfo fromJson(Map<String, dynamic> json) =>
      _$SpawnDensityInfoFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ARObjectsResponse extends INetworkModel<ARObjectsResponse> {
  final List<ARMonster> monsters;
  final List<ARResource> resources;
  final List<ARMonster> personalMonsters;
  final DateTime? timestamp;

  const ARObjectsResponse({
    this.monsters = const [],
    this.resources = const [],
    this.personalMonsters = const [],
    this.timestamp,
  });

  factory ARObjectsResponse.fromJson(Map<String, dynamic> json) =>
      _$ARObjectsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ARObjectsResponseToJson(this);

  @override
  ARObjectsResponse fromJson(Map<String, dynamic> json) =>
      _$ARObjectsResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class PersonalSpawnsResponse extends INetworkModel<PersonalSpawnsResponse> {
  final List<ARMonster> monsters;
  final int? spawnRadius;
  final DateTime? nextSpawnTime;

  const PersonalSpawnsResponse({
    this.monsters = const [],
    this.spawnRadius,
    this.nextSpawnTime,
  });

  factory PersonalSpawnsResponse.fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalSpawnsResponseToJson(this);
  @override
  PersonalSpawnsResponse fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnsResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NearbyPlayer extends INetworkModel<NearbyPlayer> {
  final String? playerId;
  final String? name;
  final int? level;
  final String? characterClass;
  @PositionConverter()
  final Position? position;
  final bool? isFriend;
  final bool? isGuildMember;
  final DateTime? lastSeen;

  const NearbyPlayer({
    this.playerId,
    this.name,
    this.level,
    this.characterClass,
    this.position,
    this.isFriend,
    this.isGuildMember,
    this.lastSeen,
  });

  factory NearbyPlayer.fromJson(Map<String, dynamic> json) =>
      _$NearbyPlayerFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyPlayerToJson(this);
  @override
  NearbyPlayer fromJson(Map<String, dynamic> json) =>
      _$NearbyPlayerFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class FriendLocation extends INetworkModel<FriendLocation> {
  final String? friendId;
  final String? name;
  @PositionConverter()
  final Position? position;
  final bool? isOnline;
  final String? guildEmblem;

  const FriendLocation({
    this.friendId,
    this.name,
    this.position,
    this.isOnline,
    this.guildEmblem,
  });

  factory FriendLocation.fromJson(Map<String, dynamic> json) =>
      _$FriendLocationFromJson(json);
  Map<String, dynamic> toJson() => _$FriendLocationToJson(this);
  @override
  FriendLocation fromJson(Map<String, dynamic> json) =>
      _$FriendLocationFromJson(json);
}

@JsonSerializable()
class ARStats extends INetworkModel<ARStats> {
  final int? totalMonsters;
  final int? monstersInRange;
  final int? personalMonsters;
  final int? resources;
  final int? nearbyPlayers;
  final DateTime? timestamp;

  const ARStats({
    this.totalMonsters,
    this.monstersInRange,
    this.personalMonsters,
    this.resources,
    this.nearbyPlayers,
    this.timestamp,
  });

  factory ARStats.fromJson(Map<String, dynamic> json) =>
      _$ARStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ARStatsToJson(this);

  factory ARStats.empty() => ARStats(
    totalMonsters: 0,
    monstersInRange: 0,
    personalMonsters: 0,
    resources: 0,
    nearbyPlayers: 0,
    timestamp: DateTime.now(),
  );

  @override
  ARStats fromJson(Map<String, dynamic> json) => _$ARStatsFromJson(json);
}

class PositionConverter
    implements JsonConverter<Position, Map<String, dynamic>> {
  const PositionConverter();

  @override
  Position fromJson(Map<String, dynamic> json) {
    return Position(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
      heading: (json['heading'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble() ?? 0.0,
      altitudeAccuracy: (json['altitudeAccuracy'] as num?)?.toDouble() ?? 0.0,
      headingAccuracy: (json['headingAccuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson(Position position) {
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': position.timestamp.toIso8601String(),
      'accuracy': position.accuracy,
      'altitude': position.altitude,
      'heading': position.heading,
      'speed': position.speed,
      'speedAccuracy': position.speedAccuracy,
    };
  }
}
