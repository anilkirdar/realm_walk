import 'package:geolocator/geolocator.dart';

import '../model/ar_models.dart';
import '../model/ar_objects_data.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';

abstract class IARService {
  Future<ARObjectsData> getNearbyObjects(Position position, {int radius = 200});
  Future<PersonalSpawnData> getPersonalSpawns(
    Position position, {
    int radius = 200,
    int maxSpawns = 8,
  });
  Future<List<ARMonster>> getProximityBasedSpawns(
    Position position, {
    int movementRadius = 50,
  });
  Future<ARMonster?> spawnTestMonster(
    Position userPosition,
    String monsterType, {
    int level = 5,
    bool isPersonal = false,
  });
  Future<void> clearTestMonsters();
  Future<CombatSession?> engageMonster(
    String monsterId,
    Position playerLocation,
  );
  Future<CombatRewards?> defeatMonster(
    String monsterId,
    String sessionId,
    int finalDamage,
  );
  Future<HarvestResult?> harvestResource(
    String resourceId,
    Position playerLocation, {
    int harvestAmount = 1,
  });

  List<ARMonster> get cachedMonsters;
  List<ARMonster> get cachedPersonalMonsters;
  List<ARMonster> get allCachedMonsters;
  List<ARResource> get cachedResources;

  void enableService();
  void disableService();
  bool isValidPosition(Position position);
  void startPeriodicRefresh(Stream<Position> positionStream);
  void stopPeriodicRefresh();
  Map<String, dynamic> getServiceStats();
}
