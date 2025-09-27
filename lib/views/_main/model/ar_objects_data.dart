// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'ar_models.dart';

part 'ar_objects_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ARObjectsData extends INetworkModel<ARObjectsData> {
  final List<ARMonster> monsters;
  final List<ARResource> resources;
  final List<ARMonster> personalMonsters;
  final SpawnDensityInfo? spawnInfo;
  final String? biome;
  final DateTime? lastUpdate;
  final double? latitude;
  final double? longitude;
  final int? radius;

  const ARObjectsData({
    required this.monsters,
    required this.resources,
    required this.personalMonsters,
    this.spawnInfo,
    this.biome,
    this.lastUpdate,
    this.latitude,
    this.longitude,
    this.radius,
  });

  factory ARObjectsData.fromJson(Map<String, dynamic> json) =>
      _$ARObjectsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARObjectsDataToJson(this);

  @override
  ARObjectsData fromJson(Map<String, dynamic> json) =>
      _$ARObjectsDataFromJson(json);

  ARObjectsData copyWith({
    List<ARMonster>? monsters,
    List<ARResource>? resources,
    List<ARMonster>? personalMonsters,
    SpawnDensityInfo? spawnInfo,
    String? biome,
    DateTime? lastUpdate,
    double? latitude,
    double? longitude,
    int? radius,
  }) {
    return ARObjectsData(
      monsters: monsters ?? this.monsters,
      resources: resources ?? this.resources,
      personalMonsters: personalMonsters ?? this.personalMonsters,
      spawnInfo: spawnInfo ?? this.spawnInfo,
      biome: biome ?? this.biome,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
    );
  }

  // Helper methods
  List<ARMonster> get allMonsters => [...monsters, ...personalMonsters];

  int get totalMonsters => monsters.length + personalMonsters.length;
  int get totalResources => resources.length;
  int get totalObjects => totalMonsters + totalResources;

  List<ARMonster> get aliveMonsters =>
      allMonsters.where((monster) => monster.isAlive).toList();

  List<ARMonster> get deadMonsters =>
      allMonsters.where((monster) => monster.isDead).toList();

  List<ARResource> get harvestableResources =>
      resources.where((resource) => resource.canHarvest).toList();

  Map<String, int> get monstersByType {
    final Map<String, int> typeCount = {};
    for (final monster in allMonsters) {
      final type = monster.type ?? 'unknown';
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    return typeCount;
  }

  Map<String, int> get resourcesByType {
    final Map<String, int> typeCount = {};
    for (final resource in resources) {
      final type = resource.type ?? 'unknown';
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    return typeCount;
  }

  // Filtering methods
  List<ARMonster> getMonstersInRadius(double maxDistance) {
    return allMonsters
        .where(
          (monster) => (monster.distance ?? double.infinity) <= maxDistance,
        )
        .toList();
  }

  List<ARResource> getResourcesInRadius(double maxDistance) {
    return resources
        .where(
          (resource) => (resource.distance ?? double.infinity) <= maxDistance,
        )
        .toList();
  }

  List<ARMonster> getMonstersByLevel(int minLevel, int maxLevel) {
    return allMonsters.where((monster) {
      final level = monster.level ?? 1;
      return level >= minLevel && level <= maxLevel;
    }).toList();
  }

  List<ARMonster> getMonstersByRarity(String rarity) {
    return allMonsters
        .where(
          (monster) => monster.rarity?.toLowerCase() == rarity.toLowerCase(),
        )
        .toList();
  }

  List<ARResource> getResourcesByQuality(String quality) {
    return resources
        .where(
          (resource) =>
              resource.quality?.toLowerCase() == quality.toLowerCase(),
        )
        .toList();
  }

  // Statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalMonsters': totalMonsters,
      'totalResources': totalResources,
      'globalMonsters': monsters.length,
      'personalMonsters': personalMonsters.length,
      'aliveMonsters': aliveMonsters.length,
      'deadMonsters': deadMonsters.length,
      'harvestableResources': harvestableResources.length,
      'biome': biome,
      'lastUpdate': lastUpdate?.toIso8601String(),
      'monstersByType': monstersByType,
      'resourcesByType': resourcesByType,
    };
  }
}

@JsonSerializable(explicitToJson: true)
class PersonalSpawnData extends INetworkModel<PersonalSpawnData> {
  final List<ARMonster> monsters;
  final List<ARResource> resources;
  final String? playerId;
  final DateTime? spawnTime;
  final int? cooldownSeconds;
  final int? maxSpawns;
  final double? spawnRadius;

  const PersonalSpawnData({
    required this.monsters,
    required this.resources,
    this.playerId,
    this.spawnTime,
    this.cooldownSeconds,
    this.maxSpawns,
    this.spawnRadius,
  });

  factory PersonalSpawnData.fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonalSpawnDataToJson(this);

  @override
  PersonalSpawnData fromJson(Map<String, dynamic> json) =>
      _$PersonalSpawnDataFromJson(json);

  PersonalSpawnData copyWith({
    List<ARMonster>? monsters,
    List<ARResource>? resources,
    String? playerId,
    DateTime? spawnTime,
    int? cooldownSeconds,
    int? maxSpawns,
    double? spawnRadius,
  }) {
    return PersonalSpawnData(
      monsters: monsters ?? this.monsters,
      resources: resources ?? this.resources,
      playerId: playerId ?? this.playerId,
      spawnTime: spawnTime ?? this.spawnTime,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      maxSpawns: maxSpawns ?? this.maxSpawns,
      spawnRadius: spawnRadius ?? this.spawnRadius,
    );
  }

  // Helper methods
  bool get canSpawnMore => monsters.length < (maxSpawns ?? 5);

  Duration? get remainingCooldown {
    if (spawnTime == null || cooldownSeconds == null) return null;

    final elapsed = DateTime.now().difference(spawnTime!);
    final cooldown = Duration(seconds: cooldownSeconds!);

    if (elapsed >= cooldown) return null;
    return cooldown - elapsed;
  }

  bool get isOnCooldown => remainingCooldown != null;
}
