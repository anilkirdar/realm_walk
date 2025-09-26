import 'package:geolocator/geolocator.dart';

import '../model/ar_models.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';

abstract class IARProvider {
  List<ARMonster> get nearbyMonsters;
  List<ARResource> get nearbyResources;
  List<ARMonster> get personalMonsters;
  List<ARMonster> get allMonsters;
  bool get isLoading;
  String? get error;
  Position? get currentPosition;
  bool get isCameraActive;
  ARMonster? get selectedMonster;
  ARResource? get selectedResource;
  CombatSession? get activeCombatSession;
  bool get isInCombat;
  bool get personalSpawnsEnabled;

  Future<void> initialize();
  void startARCamera();
  void stopARCamera();
  void selectMonster(ARMonster monster);
  void selectResource(ARResource resource);
  void clearSelection();
  Future<bool> engageMonster(ARMonster monster);
  Future<CombatRewards?> defeatMonster(int finalDamage);
  Future<HarvestResult?> harvestResource(ARResource resource);
  Future<void> refreshARObjects();
  void updatePosition(Position position);
  double distanceToMonster(ARMonster monster);
  double distanceToResource(ARResource resource);
  bool isMonsterInRange(ARMonster monster);
  bool isResourceInRange(ARResource resource);

  void enablePersonalSpawns();
  void disablePersonalSpawns();
  Future<void> checkProximitySpawns();
  Future<bool> spawnTestMonster({
    required String monsterType,
    double? latitude,
    double? longitude,
    int level = 5,
    bool isPersonal = false,
  });
  Future<void> clearTestMonsters();
  Map<String, dynamic> getSpawnStats();
}
