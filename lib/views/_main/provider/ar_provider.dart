import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/ar_models.dart';
import '../model/combat_rewards.dart';
import '../model/combat_sessions.dart';
import '../model/harvest_result.dart';
import '../service/ar_service.dart';
import '../service/location_service.dart';
import 'i_ar_provider.dart';

class ARProvider with ChangeNotifier implements IARProvider {
  ARService arService = ARService();
  LocationService locationService = LocationService();

  List<ARMonster> _nearbyMonsters = [];
  List<ARResource> _nearbyResources = [];
  List<ARMonster> _personalMonsters = []; // Kişiye özel yaratıklar
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  Timer? _refreshTimer;
  Timer? _personalSpawnTimer; // Kişiye özel spawn timer

  // AR Camera state
  bool _isCameraActive = false;
  ARMonster? _selectedMonster;
  ARResource? _selectedResource;

  // Combat state
  CombatSession? _activeCombatSession;
  bool _isInCombat = false;

  bool _personalSpawnsEnabled = true;
  int _personalSpawnRadius = 200; // 200m çevre
  int _maxPersonalSpawns = 8;

  // Getters
  @override
  List<ARMonster> get nearbyMonsters => _nearbyMonsters;
  @override
  List<ARResource> get nearbyResources => _nearbyResources;
  @override
  List<ARMonster> get personalMonsters => _personalMonsters;
  @override
  List<ARMonster> get allMonsters => [..._nearbyMonsters, ..._personalMonsters];
  @override
  bool get isLoading => _isLoading;
  @override
  String? get error => _error;
  @override
  Position? get currentPosition => _currentPosition;
  @override
  bool get isCameraActive => _isCameraActive;
  @override
  ARMonster? get selectedMonster => _selectedMonster;
  @override
  ARResource? get selectedResource => _selectedResource;
  @override
  CombatSession? get activeCombatSession => _activeCombatSession;
  @override
  bool get isInCombat => _isInCombat;

  // Initialize AR system with personal spawns
  @override
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPosition = await locationService.getCurrentPosition();
      if (_currentPosition != null) {
        await _refreshARObjects();
        await _generatePersonalSpawns();
        _startPeriodicRefresh();
        _startPersonalSpawnSystem();
      }
    } catch (e) {
      _error = 'Failed to initialize AR: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  //  kişiye özel spawn sistemi
  Future<void> _generatePersonalSpawns() async {
    if (_currentPosition == null || !_personalSpawnsEnabled) return;

    try {
      final personalSpawns = await arService.getPersonalSpawns(
        _currentPosition!,
        radius: _personalSpawnRadius,
        maxSpawns: _maxPersonalSpawns,
      );

      _personalMonsters = personalSpawns.monsters;
      print("✅ Generated ${_personalMonsters.length} personal spawns");
    } catch (e) {
      print("❌ Personal spawn error: $e");
    }
  }

  // Kişiye özel spawn timer'ı başlat
  void _startPersonalSpawnSystem() {
    // Her 2 dakikada bir kişiye özel spawn'ları kontrol et
    _personalSpawnTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _generatePersonalSpawns();
    });
  }

  // Start AR camera
  @override
  void startARCamera() {
    _isCameraActive = true;
    notifyListeners();
  }

  // Stop AR camera
  @override
  void stopARCamera() {
    _isCameraActive = false;
    _selectedMonster = null;
    _selectedResource = null;
    notifyListeners();
  }

  // Select AR object for interaction
  @override
  void selectMonster(ARMonster monster) {
    _selectedMonster = monster;
    _selectedResource = null;
    notifyListeners();
  }

  @override
  void selectResource(ARResource resource) {
    _selectedResource = resource;
    _selectedMonster = null;
    notifyListeners();
  }

  @override
  void clearSelection() {
    _selectedMonster = null;
    _selectedResource = null;
    notifyListeners();
  }

  // Combat methods with personal spawn support
  @override
  Future<bool> engageMonster(ARMonster monster) async {
    if (_currentPosition == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final session = await arService.engageMonster(
        monster.id ?? '',
        _currentPosition!,
      );

      if (session != null) {
        _activeCombatSession = session;
        _isInCombat = true;
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to engage monster: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<CombatRewards?> defeatMonster(int finalDamage) async {
    if (_activeCombatSession == null) return null;

    try {
      _isLoading = true;
      notifyListeners();

      final rewards = await arService.defeatMonster(
        _activeCombatSession!.monsterId ?? '',
        _activeCombatSession!.id ?? '',
        finalDamage,
      );

      if (rewards != null) {
        // Hem normal hem personal listeden kaldır
        _nearbyMonsters.removeWhere(
          (m) => m.id == _activeCombatSession!.monsterId,
        );
        _personalMonsters.removeWhere(
          (m) => m.id == _activeCombatSession!.monsterId,
        );

        _endCombat();

        Future.delayed(Duration(seconds: 5), () {
          _generatePersonalSpawns();
        });

        return rewards;
      }
      return null;
    } catch (e) {
      _error = 'Failed to defeat monster: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _endCombat() {
    _activeCombatSession = null;
    _isInCombat = false;
    _selectedMonster = null;
  }

  // Resource harvesting (unchanged)
  @override
  Future<HarvestResult?> harvestResource(ARResource resource) async {
    if (_currentPosition == null) return null;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await arService.harvestResource(
        resource.id ?? '',
        _currentPosition!,
      );

      if (result != null) {
        final resourceIndex = _nearbyResources.indexWhere(
          (r) => r.id == resource.id,
        );
        if (resourceIndex != -1) {
          _nearbyResources.removeAt(resourceIndex);
        }

        _selectedResource = null;
        return result;
      }
      return null;
    } catch (e) {
      _error = 'Failed to harvest resource: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh both global and personal spawns
  @override
  Future<void> refreshARObjects() async {
    await _refreshARObjects();
    await _generatePersonalSpawns();
  }

  Future<void> _refreshARObjects() async {
    if (_currentPosition == null) return;

    try {
      final objectsData = await arService.getNearbyObjects(_currentPosition!);
      _nearbyMonsters = objectsData.monsters
          .where((m) => !m.isPersonal)
          .toList();
      _nearbyResources = objectsData.resources;

      // Personal spawns'ları ayrı güncelle
      if (objectsData.personalMonsters.isNotEmpty) {
        _personalMonsters = objectsData.personalMonsters;
      }

      _error = null;
      print(
        "✅ Refreshed: ${_nearbyMonsters.length} global monsters, ${_personalMonsters.length} personal monsters",
      );
    } catch (e) {
      _error = 'Failed to refresh AR objects: $e';
    }

    notifyListeners();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshARObjects();
    });
  }

  // proximity-based spawn
  @override
  Future<void> checkProximitySpawns() async {
    if (_currentPosition == null) return;

    // Oyuncu hareket ettiğinde yeni spawn'lar kontrol et
    final proximitySpawns = await arService.getProximityBasedSpawns(
      _currentPosition!,
      movementRadius: 50, // 50m hareket ettiyse yeni spawn kontrol et
    );

    if (proximitySpawns.isNotEmpty) {
      _personalMonsters.addAll(proximitySpawns);
      notifyListeners();
      print("🎯 Proximity spawned ${proximitySpawns.length} new monsters");
    }
  }

  // Update position with proximity spawn check
  @override
  void updatePosition(Position position) {
    final oldPosition = _currentPosition;
    _currentPosition = position;

    // Eğer 50m+ hareket ettiyse proximity spawn kontrol et
    if (oldPosition != null) {
      final distance = Geolocator.distanceBetween(
        oldPosition.latitude,
        oldPosition.longitude,
        position.latitude,
        position.longitude,
      );

      if (distance > 50) {
        checkProximitySpawns();
      }
    }

    notifyListeners();
  }

  // Calculate distance to any monster (global or personal)
  @override
  double distanceToMonster(ARMonster monster) {
    if (_currentPosition == null) return double.infinity;

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      monster.location?.latitude ?? 0,
      monster.location?.longitude ?? 0,
    );
  }

  @override
  double distanceToResource(ARResource resource) {
    if (_currentPosition == null) return double.infinity;

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      resource.location?.latitude ?? 0,
      resource.location?.longitude ?? 0,
    );
  }

  @override
  bool isMonsterInRange(ARMonster monster) {
    final distance = distanceToMonster(monster);

    // Personal spawns biraz daha uzaktan engage edilebilir
    if (monster.isPersonal) {
      return distance <= 80; // 80m personal spawns için
    }

    return distance <= 50; // 50m global spawns için
  }

  @override
  bool isResourceInRange(ARResource resource) {
    return distanceToResource(resource) <= 30; // 30 meters
  }

  List<ARMonster> getNearbyMonstersInRange() {
    return allMonsters.where((monster) => isMonsterInRange(monster)).toList();
  }

  List<ARMonster> getVisibleMonsters() {
    // AR Camera'da görünür olan yaratıklar (200m içinde)
    return allMonsters
        .where((monster) => distanceToMonster(monster) <= 200)
        .toList();
  }

  // Personal spawn ayarları
  @override
  bool get personalSpawnsEnabled => _personalSpawnsEnabled;

  @override
  void enablePersonalSpawns() {
    _personalSpawnsEnabled = true;
    _generatePersonalSpawns();
    notifyListeners();
  }

  @override
  void disablePersonalSpawns() {
    _personalSpawnsEnabled = false;
    _personalMonsters.clear();
    notifyListeners();
  }

  void setPersonalSpawnRadius(int radius) {
    _personalSpawnRadius = radius;
    _generatePersonalSpawns();
  }

  void setMaxPersonalSpawns(int count) {
    _maxPersonalSpawns = count;
    _generatePersonalSpawns();
  }

  @override
  Future<bool> spawnTestMonster({
    required String monsterType,
    double? latitude,
    double? longitude,
    int level = 5,
    bool isPersonal = false,
  }) async {
    if (_currentPosition == null && latitude == null && longitude == null) {
      return false;
    }

    final spawnLat = latitude ?? _currentPosition!.latitude;
    final spawnLng = longitude ?? _currentPosition!.longitude;

    try {
      final monster = await arService.spawnTestMonster(
        Position(
          latitude: spawnLat,
          longitude: spawnLng,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        ),
        monsterType,
        level: level,
        isPersonal: isPersonal,
      );

      if (monster != null) {
        if (isPersonal) {
          _personalMonsters.add(monster);
        } else {
          _nearbyMonsters.add(monster);
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to spawn test monster: $e';
    }

    return false;
  }

  // Clear all test monsters
  @override
  Future<void> clearTestMonsters() async {
    try {
      await arService.clearTestMonsters();
      _nearbyMonsters.removeWhere((m) => m.id?.startsWith('test_') ?? false);
      _personalMonsters.removeWhere((m) => m.id?.startsWith('test_') ?? false);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear test monsters: $e';
    }
  }

  @override
  Map<String, dynamic> getSpawnStats() {
    return {
      'globalMonsters': _nearbyMonsters.length,
      'personalMonsters': _personalMonsters.length,
      'totalMonsters': allMonsters.length,
      'monstersInRange': getNearbyMonstersInRange().length,
      'visibleMonsters': getVisibleMonsters().length,
      'resources': _nearbyResources.length,
      'personalSpawnsEnabled': _personalSpawnsEnabled,
      'spawnRadius': _personalSpawnRadius,
      'maxPersonalSpawns': _maxPersonalSpawns,
    };
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _personalSpawnTimer?.cancel();
    super.dispose();
  }
}
