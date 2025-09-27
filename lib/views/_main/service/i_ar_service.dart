import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:vexana/vexana.dart';

import '../../../../core/init/firebase/crashlytics/crashlytics_manager.dart';
import '../../../../core/init/network/model/error_model_custom.dart';
import '../model/ar_models.dart';
import '../model/ar_objects_data.dart';
import '../model/combat_models.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';
import '../model/spawn_monster_response.dart';

abstract class IARService {
  IARService(this.manager);

  final INetworkManager<ErrorModelCustom> manager;
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  final CrashlyticsMessages crashlyticsMessages = CrashlyticsMessages.instance;

  // Core AR object management
  Future<ARObjectsData> getNearbyObjects(Position position, {int radius = 200});
  Future<ARObjectsData> getPersonalSpawns(
    Position position, {
    int radius = 100,
    int maxSpawns = 5,
  });
  Future<SpawnDensityInfo> getSpawnDensity(Position position);

  // Position validation and refresh system
  bool isValidPosition(Position position);
  void startPeriodicRefresh(Stream<Position> positionStream);
  void stopPeriodicRefresh();

  // Combat methods
  Future<CombatSession?> engageMonster(
    String monsterId,
    Position playerLocation,
  );
  Future<CombatRewards?> completeCombat(String sessionId, CombatResult result);
  Future<CombatRewards?> defeatMonster(
    String monsterId,
    String sessionId,
    int finalDamage,
  );
  Future<bool> abandonCombat(String sessionId);

  // Resource harvesting
  Future<HarvestResult?> harvestResource(
    String resourceId,
    Position playerLocation, {
    int harvestAmount = 1,
  });

  // Monster spawning and management
  Future<SpawnMonsterResponse?> requestMonsterSpawn(
    Position position,
    String? monsterType,
  );
  Future<bool> removeARObject(String objectId);
  Future<bool> reportARObject(String objectId, String reason);

  // Service state management
  void enableService();
  void disableService();
  Map<String, dynamic> getServiceStats();

  // Cached data getters
  List<ARMonster> get cachedMonsters;
  List<ARMonster> get cachedPersonalMonsters;
  List<ARMonster> get allCachedMonsters;
  List<ARResource> get cachedResources;
}
