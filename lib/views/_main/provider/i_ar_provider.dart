import 'package:geolocator/geolocator.dart';

import '../model/ar_models.dart';
import '../model/combat_models.dart';
import '../model/combat_sessions.dart';

abstract class IARProvider {
  // State getters
  bool get isLoading;
  bool get isEnabled;
  String? get error;
  Position? get currentPosition;
  bool get isCameraActive;

  // AR Objects
  List<ARMonster> get nearbyMonsters;
  List<ARMonster> get personalMonsters;
  List<ARMonster> get allMonsters;
  List<ARResource> get nearbyResources;

  // Selected objects
  ARMonster? get selectedMonster;
  ARResource? get selectedResource;

  // Combat
  CombatSession? get activeCombatSession;
  bool get isInCombat;

  // Core AR methods
  Future<void> initialize();
  Future<void> refreshARObjects();
  void enableAR();
  void disableAR();

  // Camera methods
  void startARCamera();
  void stopARCamera();

  // Object selection
  void selectMonster(ARMonster monster);
  void selectResource(ARResource resource);
  void clearSelection();

  // Combat methods
  Future<bool> engageMonster(ARMonster monster);
  Future<void> completeCombat(CombatResult result);
  Future<void> abandonCombat();

  // Resource methods
  Future<bool> harvestResource(ARResource resource);

  // Personal spawns
  Future<void> generatePersonalSpawns();
  void enablePersonalSpawns(bool enabled);

  // Location updates
  void updateLocation(Position position);

  // AR Object management
  Future<void> removeARObject(String objectId);
  Future<void> reportARObject(String objectId, String reason);
}
