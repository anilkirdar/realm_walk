import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:vexana/vexana.dart';

import '../../../../core/base/service/base_service.dart';
import '../model/ar_models.dart';
import '../model/ar_objects_data.dart';
import '../model/combat_models.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';
import '../model/spawn_monster_response.dart';
import 'i_ar_service.dart';

enum _ARAPI {
  nearby('/ar/nearby'),
  personalSpawns('/ar/personal-spawns'),
  spawnDensity('/ar/spawn-density'),
  engageMonster('/ar/monster/{monsterId}/engage'),
  defeatMonster('/ar/monster/{monsterId}/defeat'),
  completeCombat('/ar/combat/{sessionId}/complete'),
  abandonCombat('/ar/combat/{sessionId}/abandon'),
  harvestResource('/ar/resource/{resourceId}/harvest'),
  requestSpawn('/ar/spawn/request'),
  removeObject('/ar/object/{objectId}/remove'),
  reportObject('/ar/object/{objectId}/report');

  const _ARAPI(this.apiPath);
  final String apiPath;

  String withId(String id) => apiPath.replaceAll(RegExp(r'\{.*?\}'), id);
}

class ARService extends IARService with BaseService {
  ARService(super.manager);

  Timer? _refreshTimer;
  List<ARMonster> _nearbyMonsters = [];
  List<ARMonster> _personalMonsters = [];
  List<ARResource> _nearbyResources = [];
  Position? _lastPosition;
  bool _isEnabled = true;

  // Pokemon GO tarzı spawn ayarları
  final int _personalSpawnCooldown = 120; // 2 dakika
  final Map<String, DateTime> _lastPersonalSpawns = {};

  // Test mode for development
  bool isTestMode = false;

  @override
  Future<ARObjectsData> getNearbyObjects(
    Position position, {
    int radius = 200,
  }) async {
    try {
      printDev.debug(
        'AR Service: Getting nearby objects at ${position.latitude}, ${position.longitude}',
      );

      final response = await manager.send<ARObjectsData, ARObjectsData>(
        _ARAPI.nearby.apiPath,
        parseModel: ARObjectsData(
          monsters: [],
          resources: [],
          personalMonsters: [],
        ),
        method: RequestType.GET,
        queryParameters: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'radius': radius.toString(),
        },
      );

      if (response.error != null) {
        printDev.exception(
          'AR Service getNearbyObjects Error: ${response.error}',
        );
        await crashlyticsManager.sendACrash(
          error: response.error.toString(),
          stackTrace: StackTrace.current,
          reason: 'AR Service getNearbyObjects Error',
        );

        // Return cached data if available
        return ARObjectsData(
          monsters: _nearbyMonsters,
          resources: _nearbyResources,
          personalMonsters: _personalMonsters,
        );
      }

      final data = response.data;
      if (data != null) {
        // Separate global and personal monsters
        _nearbyMonsters = data.monsters.where((m) => !m.isPersonal).toList();
        _personalMonsters = data.monsters.where((m) => m.isPersonal).toList();
        _nearbyResources = data.resources;
        _lastPosition = position;

        printDev.debug(
          'AR Service: Loaded ${_nearbyMonsters.length} global monsters, '
          '${_personalMonsters.length} personal monsters, '
          '${_nearbyResources.length} resources',
        );

        return ARObjectsData(
          monsters: _nearbyMonsters,
          resources: _nearbyResources,
          personalMonsters: _personalMonsters,
        );
      }

      return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
    } catch (e) {
      printDev.exception('AR Service Exception: $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'AR Service Exception',
      );

      // Test mode fallback
      if (isTestMode) {
        return _generateTestObjects(position);
      }

      return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
    }
  }

  @override
  Future<ARObjectsData> getPersonalSpawns(
    Position position, {
    int radius = 100,
    int maxSpawns = 5,
  }) async {
    try {
      if (!_shouldGeneratePersonalSpawns()) {
        return ARObjectsData(
          monsters: [],
          resources: [],
          personalMonsters: _personalMonsters,
        );
      }

      printDev.debug('AR Service: Generating personal spawns');

      final response = await manager.send<ARObjectsData, ARObjectsData>(
        _ARAPI.personalSpawns.apiPath,
        parseModel: ARObjectsData(
          monsters: [],
          resources: [],
          personalMonsters: [],
        ),
        method: RequestType.POST,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'radius': radius,
          'maxSpawns': maxSpawns,
        },
      );

      if (response.error != null) {
        printDev.exception('Personal spawns error: ${response.error}');
        return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
      }

      final data = response.data;
      if (data != null) {
        _personalMonsters.addAll(data.personalMonsters);
        printDev.debug(
          'Generated ${data.personalMonsters.length} personal spawns',
        );

        return ARObjectsData(
          monsters: [],
          resources: [],
          personalMonsters: data.personalMonsters,
        );
      }

      return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
    } catch (e) {
      printDev.exception('Personal spawns exception: $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Personal Spawns Error',
      );
      return ARObjectsData(monsters: [], resources: [], personalMonsters: []);
    }
  }

  @override
  Future<SpawnDensityInfo> getSpawnDensity(Position position) async {
    try {
      final response = await manager.send<SpawnDensityInfo, SpawnDensityInfo>(
        _ARAPI.spawnDensity.apiPath,
        parseModel: SpawnDensityInfo(),
        method: RequestType.GET,
        queryParameters: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );

      return response.data ?? SpawnDensityInfo();
    } catch (e) {
      printDev.exception('Spawn density error: $e');
      return SpawnDensityInfo();
    }
  }

  @override
  bool isValidPosition(Position position) {
    final isLatValid = position.latitude.abs() <= 90;
    final isLngValid = position.longitude.abs() <= 180;
    final isAccuracyOk = position.accuracy <= 100;
    final isAltitudeReasonable =
        position.altitude > -1000 && position.altitude < 9000;

    return isLatValid && isLngValid && isAccuracyOk && isAltitudeReasonable;
  }

  @override
  void startPeriodicRefresh(Stream<Position> positionStream) {
    positionStream.listen((position) async {
      if (!_isEnabled || !isValidPosition(position)) return;

      if (_shouldRefreshObjects(position)) {
        await getNearbyObjects(position);

        if (_shouldGeneratePersonalSpawns()) {
          await getPersonalSpawns(position);
        }
      }
    });

    // Global refresh every 20 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (_lastPosition != null && _isEnabled) {
        await getNearbyObjects(_lastPosition!);
      }
    });

    // Personal spawns refresh every 2 minutes
    Timer.periodic(const Duration(minutes: 2), (timer) async {
      if (_lastPosition != null && _isEnabled) {
        await getPersonalSpawns(_lastPosition!);
      }
    });
  }

  @override
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<CombatSession?> engageMonster(
    String monsterId,
    Position playerLocation,
  ) async {
    try {
      printDev.debug('AR Service: Engaging monster $monsterId');

      final response = await manager.send<CombatSession, CombatSession>(
        _ARAPI.engageMonster.withId(monsterId),
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

      if (response.error != null) {
        printDev.exception('Engage monster error: ${response.error}');
        return null;
      }

      if (response.data != null) {
        printDev.debug('Combat engaged with monster: $monsterId');
      }

      return response.data;
    } catch (e) {
      printDev.exception('Engage monster exception: $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Engage Monster Error',
      );
      return null;
    }
  }

  @override
  Future<CombatRewards?> completeCombat(
    String sessionId,
    CombatResult result,
  ) async {
    try {
      final response = await manager.send<CombatRewards, CombatRewards>(
        _ARAPI.completeCombat.withId(sessionId),
        parseModel: CombatRewards(),
        method: RequestType.POST,
        data: result.toJson(),
      );

      if (response.error != null) {
        printDev.exception('Complete combat error: ${response.error}');
        return null;
      }

      return response.data;
    } catch (e) {
      printDev.exception('Complete combat exception: $e');
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
      final response = await manager.send<CombatRewards, CombatRewards>(
        _ARAPI.defeatMonster.withId(monsterId),
        parseModel: CombatRewards(),
        method: RequestType.POST,
        data: {'sessionId': sessionId, 'finalDamage': finalDamage},
      );

      if (response.data != null) {
        printDev.debug('Monster defeated: $monsterId');

        // Remove defeated monster from cache
        _nearbyMonsters.removeWhere((m) => m.id == monsterId);
        _personalMonsters.removeWhere((m) => m.id == monsterId);
      }

      return response.data;
    } catch (e) {
      printDev.exception('Defeat monster error: $e');
      return null;
    }
  }

  @override
  Future<bool> abandonCombat(String sessionId) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _ARAPI.abandonCombat.withId(sessionId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('Abandon combat exception: $e');
      return false;
    }
  }

  @override
  Future<HarvestResult?> harvestResource(
    String resourceId,
    Position playerLocation, {
    int harvestAmount = 1,
  }) async {
    try {
      final response = await manager.send<HarvestResult, HarvestResult>(
        _ARAPI.harvestResource.withId(resourceId),
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
        printDev.debug('Resource harvested: $resourceId');
      }

      return response.data;
    } catch (e) {
      printDev.exception('Harvest resource error: $e');
      return null;
    }
  }

  @override
  Future<SpawnMonsterResponse?> requestMonsterSpawn(
    Position position,
    String? monsterType,
  ) async {
    try {
      final response = await manager
          .send<SpawnMonsterResponse, SpawnMonsterResponse>(
            _ARAPI.requestSpawn.apiPath,
            parseModel: SpawnMonsterResponse(),
            method: RequestType.POST,
            data: {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'monsterType': monsterType,
            },
          );

      return response.data;
    } catch (e) {
      printDev.exception('Request monster spawn exception: $e');
      return null;
    }
  }

  @override
  Future<bool> removeARObject(String objectId) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _ARAPI.removeObject.withId(objectId),
        parseModel: EmptyModel(),
        method: RequestType.DELETE,
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('Remove AR object exception: $e');
      return false;
    }
  }

  @override
  Future<bool> reportARObject(String objectId, String reason) async {
    try {
      final response = await manager.send<EmptyModel, EmptyModel>(
        _ARAPI.reportObject.withId(objectId),
        parseModel: EmptyModel(),
        method: RequestType.POST,
        data: {'reason': reason},
      );

      return response.error == null;
    } catch (e) {
      printDev.exception('Report AR object exception: $e');
      return false;
    }
  }

  @override
  void enableService() => _isEnabled = true;

  @override
  void disableService() => _isEnabled = false;

  @override
  Map<String, dynamic> getServiceStats() {
    return {
      'cachedGlobalMonsters': _nearbyMonsters.length,
      'cachedPersonalMonsters': _personalMonsters.length,
      'cachedResources': _nearbyResources.length,
      'isEnabled': _isEnabled,
      'lastPosition': _lastPosition != null
          ? '${_lastPosition!.latitude.toStringAsFixed(4)}, ${_lastPosition!.longitude.toStringAsFixed(4)}'
          : 'Unknown',
      'lastRefresh': DateTime.now().toIso8601String(),
    };
  }

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

  // Private helper methods
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

  bool _shouldRefreshObjects(Position newPosition) {
    if (_lastPosition == null) return true;

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    return distance > 25; // Refresh if moved 25m
  }

  ARObjectsData _generateTestObjects(Position position) {
    final random = math.Random();
    final testMonsters = List.generate(
      3,
      (index) => ARMonster(
        id: 'test_monster_$index',
        name: 'Test Monster $index',
        type: 'goblin',
        level: random.nextInt(10) + 1,
        health: 100,
        maxHealth: 100,
        latitude: position.latitude + (random.nextDouble() - 0.5) * 0.01,
        longitude: position.longitude + (random.nextDouble() - 0.5) * 0.01,
        distance: random.nextDouble() * 200,
        isPersonal: false,
      ),
    );

    final testResources = List.generate(
      2,
      (index) => ARResource(
        id: 'test_resource_$index',
        name: 'Test Resource $index',
        type: 'herb',
        latitude: position.latitude + (random.nextDouble() - 0.5) * 0.01,
        longitude: position.longitude + (random.nextDouble() - 0.5) * 0.01,
        distance: random.nextDouble() * 150,
      ),
    );

    printDev.debug('Generated test AR objects');
    return ARObjectsData(
      monsters: testMonsters,
      resources: testResources,
      personalMonsters: [],
    );
  }
}
