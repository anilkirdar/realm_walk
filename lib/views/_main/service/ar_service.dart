import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:vexana/vexana.dart';
import '../../../../core/constants/network/api_const.dart';
import '../../../../core/init/network/vexana_manager.dart';
import '../model/ar_models.dart';
import '../model/ar_objects_data.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';
import '../model/spawn_monster_response.dart';
import 'i_ar_service.dart';

class ARService extends IARService {
  final INetworkManager networkManager = VexanaManager.instance.networkManager;

  Timer? _refreshTimer;
  List<ARMonster> _nearbyMonsters = [];
  List<ARMonster> _personalMonsters = [];
  List<ARResource> _nearbyResources = [];
  Position? _lastPosition;
  bool _isEnabled = true;

  // Pokemon GO tarzı spawn ayarları
  final int _personalSpawnCooldown = 120; // 2 dakika
  final Map<String, DateTime> _lastPersonalSpawns = {};

  // Test mode
  bool isTestMode = false;

  // Get nearby AR objects (artık personal spawns dahil)
  @override
  Future<ARObjectsData> getNearbyObjects(
    Position position, {
    int radius = 200,
  }) async {
    try {
      final response = await networkManager.send<ARObjectsData, ARObjectsData>(
        APIConst.nearby(position, radius: radius),
        parseModel: ARObjectsData(
          monsters: [],
          resources: [],
          personalMonsters: [],
        ),
        method: RequestType.GET,
      );

      if (response.error != null) {
        print("❌ AR Service Error: ${response.error}");
        return ARObjectsData(
          monsters: _nearbyMonsters,
          resources: _nearbyResources,
          personalMonsters: _personalMonsters,
        );
      }

      final data = response.data;
      if (data != null) {
        // Global spawns
        _nearbyMonsters = data.monsters.where((m) => !m.isPersonal).toList();

        // Personal spawns
        _personalMonsters = data.monsters.where((m) => m.isPersonal).toList();

        _nearbyResources = data.resources;
        _lastPosition = position;

        print(
          "✅ Loaded ${_nearbyMonsters.length} global monsters, "
          "${_personalMonsters.length} personal monsters, "
          "${_nearbyResources.length} resources",
        );

        return ARObjectsData(
          monsters: _nearbyMonsters,
          resources: _nearbyResources,
          personalMonsters: _personalMonsters,
        );
      }

      return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
    } catch (e) {
      print("❌ AR Service Exception: $e");
      return ARObjectsData(
        monsters: _nearbyMonsters,
        resources: _nearbyResources,
        personalMonsters: _personalMonsters,
      );
    }
  }

  // Pokemon GO tarzı kişiye özel spawn sistemi
  @override
  Future<PersonalSpawnData> getPersonalSpawns(
    Position position, {
    int radius = 200,
    int maxSpawns = 8,
  }) async {
    try {
      final response = await networkManager
          .send<PersonalSpawnData, PersonalSpawnData>(
            APIConst.personalSpawns,
            parseModel: PersonalSpawnData(monsters: []),
            method: RequestType.POST,
            data: {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'radius': radius,
              'maxSpawns': maxSpawns,
              'altitude': position.altitude,
            },
          );

      if (response.error != null) {
        print("❌ Personal Spawn Error: ${response.error}");
        return PersonalSpawnData(monsters: []);
      }

      final data = response.data;
      if (data != null) {
        _personalMonsters = data.monsters;
        print("✅ Generated ${data.monsters.length} personal spawns");
        return data;
      }

      return PersonalSpawnData(monsters: []);
    } catch (e) {
      print("❌ Personal Spawn Exception: $e");
      return PersonalSpawnData(monsters: []);
    }
  }

  // Proximity-based spawning (hareket ettiğinde yeni spawn)
  @override
  Future<List<ARMonster>> getProximityBasedSpawns(
    Position position, {
    int movementRadius = 50,
  }) async {
    try {
      final response = await networkManager
          .send<ProximitySpawnData, ProximitySpawnData>(
            APIConst.proximitySpawns,
            parseModel: ProximitySpawnData(monsters: []),
            method: RequestType.POST,
            data: {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'movementRadius': movementRadius,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            },
          );

      if (response.error == null && response.data != null) {
        final newSpawns = response.data!.monsters;
        print("🎯 Proximity spawned ${newSpawns.length} monsters");
        return newSpawns;
      }

      return [];
    } catch (e) {
      print("❌ Proximity Spawn Exception: $e");
      return [];
    }
  }

  // Test monster spawning (geliştirilmiş)
  @override
  Future<ARMonster?> spawnTestMonster(
    Position userPosition,
    String monsterType, {
    int level = 5,
    bool isPersonal = false,
  }) async {
    try {
      final random = math.Random();
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = 5 + random.nextDouble() * 15; // 5-20m

      final latOffset = (distance * math.cos(angle)) / 111320;
      final lngOffset =
          (distance * math.sin(angle)) /
          (111320 * math.cos(userPosition.latitude * math.pi / 180));

      final spawnLat = userPosition.latitude + latOffset;
      final spawnLng = userPosition.longitude + lngOffset;

      final response = await networkManager
          .send<SpawnMonsterResponse, SpawnMonsterResponse>(
            APIConst.spawnTestMonster,
            parseModel: SpawnMonsterResponse(),
            method: RequestType.POST,
            data: {
              'monsterType': monsterType,
              'latitude': spawnLat,
              'longitude': spawnLng,
              'level': level,
              'isPersonal': isPersonal,
              'altitude': userPosition.altitude,
            },
          );

      if (response.error == null && response.data != null) {
        final data = response.data!;
        if (data.monster != null) {
          if (isPersonal) {
            _personalMonsters.add(data.monster!);
          } else {
            _nearbyMonsters.add(data.monster!);
          }
        }
        print(
          "✅ Test monster spawned: ${data.monster?.name} (Personal: $isPersonal)",
        );
        return data.monster;
      }
      return null;
    } catch (e) {
      print("❌ Test monster spawn error: $e");
      return null;
    }
  }

  // Biome-aware spawning
  Future<ARMonster?> spawnBiomeMonster(
    Position position,
    String biome, {
    int level = 5,
  }) async {
    try {
      final response = await networkManager
          .send<SpawnMonsterResponse, SpawnMonsterResponse>(
            APIConst.spawnBiomeMonster,
            parseModel: SpawnMonsterResponse(),
            method: RequestType.POST,
            data: {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'altitude': position.altitude,
              'biome': biome,
              'level': level,
            },
          );

      if (response.error == null && response.data != null) {
        final monster = response.data!.monster;
        if (monster != null) {
          _nearbyMonsters.add(monster);
          print("🌍 Biome monster spawned: ${monster.name} in $biome");
        }
        return monster;
      }
      return null;
    } catch (e) {
      print("❌ Biome monster spawn error: $e");
      return null;
    }
  }

  // Clear test monsters (geliştirilmiş)
  @override
  Future<void> clearTestMonsters() async {
    try {
      final response = await networkManager.send<EmptyModel, EmptyModel>(
        APIConst.clearTestMonster,
        parseModel: EmptyModel(),
        method: RequestType.POST,
      );

      if (response.error == null) {
        _nearbyMonsters.removeWhere(
          (monster) => monster.id?.startsWith('test_') ?? false,
        );
        _personalMonsters.removeWhere(
          (monster) => monster.id?.startsWith('test_') ?? false,
        );
        print("✅ Test monsters cleared (global + personal)");
      }
    } catch (e) {
      print("❌ Clear test monsters error: $e");
    }
  }

  // Pokemon GO tarzı spawn yoğunluğu kontrolü
  Future<SpawnDensityInfo> getSpawnDensity(Position position) async {
    try {
      final response = await networkManager
          .send<SpawnDensityInfo, SpawnDensityInfo>(
            APIConst.spawnDensity,
            parseModel: SpawnDensityInfo(),
            method: RequestType.POST,
            data: {
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
          );

      return response.data ?? SpawnDensityInfo();
    } catch (e) {
      print("❌ Spawn density error: $e");
      return SpawnDensityInfo();
    }
  }

  // Position validation (geliştirilmiş)
  @override
  bool isValidPosition(Position position) {
    final isLatValid = position.latitude.abs() <= 90;
    final isLngValid = position.longitude.abs() <= 180;
    final isAccuracyOk = position.accuracy <= 100;
    final isAltitudeReasonable =
        position.altitude > -1000 &&
        position.altitude < 9000; // -1000m to 9000m

    return isLatValid && isLngValid && isAccuracyOk && isAltitudeReasonable;
  }

  // Enhanced periodic refresh with personal spawns
  @override
  void startPeriodicRefresh(Stream<Position> positionStream) {
    positionStream.listen((position) async {
      if (!_isEnabled || !isValidPosition(position)) return;

      if (_shouldRefreshObjects(position)) {
        await getNearbyObjects(position);

        // Personal spawns için cooldown kontrol et
        if (_shouldGeneratePersonalSpawns()) {
          await getPersonalSpawns(position);
        }
      }
    });

    // Her 20 saniyede global refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (_lastPosition != null && _isEnabled) {
        await getNearbyObjects(_lastPosition!);
      }
    });

    // Her 2 dakikada personal spawns refresh
    Timer.periodic(const Duration(minutes: 2), (timer) async {
      if (_lastPosition != null && _isEnabled) {
        await getPersonalSpawns(_lastPosition!);
      }
    });
  }

  bool _shouldGeneratePersonalSpawns() {
    final lastSpawn = _lastPersonalSpawns['main'];
    if (lastSpawn == null) {
      _lastPersonalSpawns['main'] = DateTime.now();
      return true;
    }

    final cooldownPassed =
        DateTime.now().difference(lastSpawn).inSeconds > _personalSpawnCooldown;
    if (cooldownPassed) {
      _lastPersonalSpawns['main'] = DateTime.now();
    }

    return cooldownPassed;
  }

  @override
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  bool _shouldRefreshObjects(Position newPosition) {
    if (_lastPosition == null) return true;

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    return distance > 25; // 25m hareket ettiyse refresh
  }

  // Combat methods (unchanged but with better error handling)
  @override
  Future<CombatSession?> engageMonster(
    String monsterId,
    Position playerLocation,
  ) async {
    try {
      final response = await networkManager.send<CombatSession, CombatSession>(
        '/ar/monster/$monsterId/engage',
        parseModel: CombatSession(),
        method: RequestType.POST,
        data: {
          'playerLocation': {
            'latitude': playerLocation.latitude,
            'longitude': playerLocation.longitude,
            'altitude': playerLocation.altitude,
          },
        },
      );

      if (response.data != null) {
        print("⚔️ Combat engaged with monster: $monsterId");
      }

      return response.data;
    } catch (e) {
      print("❌ Engage monster error: $e");
      return null;
    }
  }

  @override
  Future<CombatRewards?> defeatMonster(
    String monsterId,
    String sessionId,
    int finalDamage,
  ) async {
    try {
      final response = await networkManager.send<CombatRewards, CombatRewards>(
        '/ar/monster/$monsterId/defeat',
        parseModel: CombatRewards(),
        method: RequestType.POST,
        data: {'sessionId': sessionId, 'finalDamage': finalDamage},
      );

      if (response.data != null) {
        print("🏆 Monster defeated: $monsterId");

        // Defeated monster'ı listelerden kaldır
        _nearbyMonsters.removeWhere((m) => m.id == monsterId);
        _personalMonsters.removeWhere((m) => m.id == monsterId);
      }

      return response.data;
    } catch (e) {
      print("❌ Defeat monster error: $e");
      return null;
    }
  }

  @override
  Future<HarvestResult?> harvestResource(
    String resourceId,
    Position playerLocation, {
    int harvestAmount = 1,
  }) async {
    try {
      final response = await networkManager.send<HarvestResult, HarvestResult>(
        '/ar/resource/$resourceId/harvest',
        parseModel: HarvestResult(),
        method: RequestType.POST,
        data: {
          'playerLocation': {
            'latitude': playerLocation.latitude,
            'longitude': playerLocation.longitude,
            'altitude': playerLocation.altitude,
          },
          'harvestAmount': harvestAmount,
        },
      );

      if (response.data != null) {
        print("🌿 Resource harvested: $resourceId");
      }

      return response.data;
    } catch (e) {
      print("❌ Harvest resource error: $e");
      return null;
    }
  }

  // Getters
  @override
  List<ARMonster> get cachedMonsters => _nearbyMonsters;
  @override
  List<ARMonster> get cachedPersonalMonsters => _personalMonsters;
  @override
  List<ARMonster> get allCachedMonsters => [
    ..._nearbyMonsters,
    ..._personalMonsters,
  ];
  @override
  List<ARResource> get cachedResources => _nearbyResources;

  @override
  void enableService() => _isEnabled = true;
  @override
  void disableService() => _isEnabled = false;

  // Pokemon GO tarzı istatistikler
  @override
  Map<String, dynamic> getServiceStats() {
    return {
      'cachedGlobalMonsters': _nearbyMonsters.length,
      'cachedPersonalMonsters': _personalMonsters.length,
      'cachedResources': _nearbyResources.length,
      'isEnabled': _isEnabled,
      'lastPosition': _lastPosition != null
          ? {
              'lat': _lastPosition!.latitude,
              'lng': _lastPosition!.longitude,
              'alt': _lastPosition!.altitude,
            }
          : null,
      'lastPersonalSpawn': _lastPersonalSpawns['main']?.toIso8601String(),
    };
  }
}
