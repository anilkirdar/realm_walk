// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'ar_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ARMonster extends INetworkModel<ARMonster> {
  final String? id;
  final String? type;
  final String? name;
  final int? level;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final int? health;
  final int? maxHealth;
  final MonsterStats? stats;
  final int? timeLeft;
  final bool isPersonal;
  final String? biome;
  final double? altitude;
  final String? ownerId;
  final int? spawnSeed;
  final int? spawnIndex;
  final String? rarity;
  final List<String>? abilities;
  final String? description;
  final String? imageUrl;
  final DateTime? spawnTime;
  final DateTime? despawnTime;

  const ARMonster({
    this.id,
    this.type,
    this.name,
    this.level,
    this.latitude,
    this.longitude,
    this.distance,
    this.health,
    this.maxHealth,
    this.stats,
    this.timeLeft,
    this.isPersonal = false,
    this.biome,
    this.altitude,
    this.ownerId,
    this.spawnSeed,
    this.spawnIndex,
    this.rarity,
    this.abilities,
    this.description,
    this.imageUrl,
    this.spawnTime,
    this.despawnTime,
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
    double? latitude,
    double? longitude,
    double? distance,
    int? health,
    int? maxHealth,
    MonsterStats? stats,
    int? timeLeft,
    bool? isPersonal,
    String? biome,
    double? altitude,
    String? ownerId,
    int? spawnSeed,
    int? spawnIndex,
    String? rarity,
    List<String>? abilities,
    String? description,
    String? imageUrl,
    DateTime? spawnTime,
    DateTime? despawnTime,
  }) {
    return ARMonster(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      level: level ?? this.level,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      stats: stats ?? this.stats,
      timeLeft: timeLeft ?? this.timeLeft,
      isPersonal: isPersonal ?? this.isPersonal,
      biome: biome ?? this.biome,
      altitude: altitude ?? this.altitude,
      ownerId: ownerId ?? this.ownerId,
      spawnSeed: spawnSeed ?? this.spawnSeed,
      spawnIndex: spawnIndex ?? this.spawnIndex,
      rarity: rarity ?? this.rarity,
      abilities: abilities ?? this.abilities,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      spawnTime: spawnTime ?? this.spawnTime,
      despawnTime: despawnTime ?? this.despawnTime,
    );
  }

  // Helper methods
  String get displayName => name ?? type ?? 'Unknown Monster';

  String get rarityEmoji {
    switch (rarity?.toLowerCase()) {
      case 'common':
        return '⚪';
      case 'uncommon':
        return '🟢';
      case 'rare':
        return '🔵';
      case 'epic':
        return '🟣';
      case 'legendary':
        return '🟡';
      case 'mythic':
        return '🔴';
      default:
        return '⚪';
    }
  }

  String get biomeEmoji {
    switch (biome?.toLowerCase()) {
      case 'forest':
        return '🌲';
      case 'urban':
        return '🏙️';
      case 'desert':
        return '🏜️';
      case 'mountain':
        return '🏔️';
      case 'water':
        return '🌊';
      case 'ice':
        return '❄️';
      default:
        return '🌍';
    }
  }

  bool get isAlive => (health ?? 0) > 0;
  bool get isDead => !isAlive;
  double get healthPercentage =>
      maxHealth != null && maxHealth! > 0 ? (health ?? 0) / maxHealth! : 0.0;
}

@JsonSerializable(explicitToJson: true)
class ARResource extends INetworkModel<ARResource> {
  final String? id;
  final String? type;
  final String? name;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final int? quantity;
  final String? quality;
  final int? timeLeft;
  final String? biome;
  final double? altitude;
  final String? rarity;
  final String? description;
  final String? imageUrl;
  final DateTime? spawnTime;
  final DateTime? despawnTime;
  final bool? isHarvestable;
  final int? harvestAmount;
  final Duration? harvestTime;

  const ARResource({
    this.id,
    this.type,
    this.name,
    this.latitude,
    this.longitude,
    this.distance,
    this.quantity,
    this.quality,
    this.timeLeft,
    this.biome,
    this.altitude,
    this.rarity,
    this.description,
    this.imageUrl,
    this.spawnTime,
    this.despawnTime,
    this.isHarvestable,
    this.harvestAmount,
    this.harvestTime,
  });

  factory ARResource.fromJson(Map<String, dynamic> json) =>
      _$ARResourceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARResourceToJson(this);

  @override
  ARResource fromJson(Map<String, dynamic> json) => _$ARResourceFromJson(json);

  ARResource copyWith({
    String? id,
    String? type,
    String? name,
    double? latitude,
    double? longitude,
    double? distance,
    int? quantity,
    String? quality,
    int? timeLeft,
    String? biome,
    double? altitude,
    String? rarity,
    String? description,
    String? imageUrl,
    DateTime? spawnTime,
    DateTime? despawnTime,
    bool? isHarvestable,
    int? harvestAmount,
    Duration? harvestTime,
  }) {
    return ARResource(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      quantity: quantity ?? this.quantity,
      quality: quality ?? this.quality,
      timeLeft: timeLeft ?? this.timeLeft,
      biome: biome ?? this.biome,
      altitude: altitude ?? this.altitude,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      spawnTime: spawnTime ?? this.spawnTime,
      despawnTime: despawnTime ?? this.despawnTime,
      isHarvestable: isHarvestable ?? this.isHarvestable,
      harvestAmount: harvestAmount ?? this.harvestAmount,
      harvestTime: harvestTime ?? this.harvestTime,
    );
  }

  // Helper methods
  String get displayName => name ?? type ?? 'Unknown Resource';

  String get typeEmoji {
    switch (type?.toLowerCase()) {
      case 'herb':
        return '🌿';
      case 'ore':
        return '⛏️';
      case 'wood':
        return '🪵';
      case 'gem':
        return '💎';
      case 'crystal':
        return '💠';
      case 'rune':
        return '🔮';
      default:
        return '📦';
    }
  }

  String get qualityEmoji {
    switch (quality?.toLowerCase()) {
      case 'poor':
        return '⚪';
      case 'common':
        return '🟢';
      case 'uncommon':
        return '🔵';
      case 'rare':
        return '🟣';
      case 'epic':
        return '🟡';
      case 'legendary':
        return '🔴';
      default:
        return '⚪';
    }
  }

  bool get canHarvest => (isHarvestable ?? true) && (quantity ?? 0) > 0;
}

@JsonSerializable(explicitToJson: true)
class MonsterStats extends INetworkModel<MonsterStats> {
  final int? health;
  final int? maxHealth;
  final int? attack;
  final int? defense;
  final int? speed;
  final int? experience;
  final List<String>? weaknesses;
  final List<String>? resistances;

  const MonsterStats({
    this.health,
    this.maxHealth,
    this.attack,
    this.defense,
    this.speed,
    this.experience,
    this.weaknesses,
    this.resistances,
  });

  factory MonsterStats.fromJson(Map<String, dynamic> json) =>
      _$MonsterStatsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MonsterStatsToJson(this);

  @override
  MonsterStats fromJson(Map<String, dynamic> json) =>
      _$MonsterStatsFromJson(json);

  MonsterStats copyWith({
    int? health,
    int? maxHealth,
    int? attack,
    int? defense,
    int? speed,
    int? experience,
    List<String>? weaknesses,
    List<String>? resistances,
  }) {
    return MonsterStats(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      experience: experience ?? this.experience,
      weaknesses: weaknesses ?? this.weaknesses,
      resistances: resistances ?? this.resistances,
    );
  }

  // Helper methods
  double get healthPercentage =>
      maxHealth != null && maxHealth! > 0 ? (health ?? 0) / maxHealth! : 0.0;

  bool get isAlive => (health ?? 0) > 0;
  bool get isDead => !isAlive;
}

@JsonSerializable(explicitToJson: true)
class SpawnDensityInfo extends INetworkModel<SpawnDensityInfo> {
  final double? monsterDensity;
  final double? resourceDensity;
  final int? nearbyMonsters;
  final int? nearbyResources;
  final String? biome;
  final double? spawnRate;
  final int? maxSpawns;

  const SpawnDensityInfo({
    this.monsterDensity,
    this.resourceDensity,
    this.nearbyMonsters,
    this.nearbyResources,
    this.biome,
    this.spawnRate,
    this.maxSpawns,
  });

  factory SpawnDensityInfo.fromJson(Map<String, dynamic> json) =>
      _$SpawnDensityInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SpawnDensityInfoToJson(this);

  @override
  SpawnDensityInfo fromJson(Map<String, dynamic> json) =>
      _$SpawnDensityInfoFromJson(json);

  SpawnDensityInfo copyWith({
    double? monsterDensity,
    double? resourceDensity,
    int? nearbyMonsters,
    int? nearbyResources,
    String? biome,
    double? spawnRate,
    int? maxSpawns,
  }) {
    return SpawnDensityInfo(
      monsterDensity: monsterDensity ?? this.monsterDensity,
      resourceDensity: resourceDensity ?? this.resourceDensity,
      nearbyMonsters: nearbyMonsters ?? this.nearbyMonsters,
      nearbyResources: nearbyResources ?? this.nearbyResources,
      biome: biome ?? this.biome,
      spawnRate: spawnRate ?? this.spawnRate,
      maxSpawns: maxSpawns ?? this.maxSpawns,
    );
  }
}
