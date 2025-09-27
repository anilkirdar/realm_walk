import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/init/network/vexana_manager.dart';
import '../model/ar_models.dart';
import '../model/combat_models.dart';
import '../model/combat_sessions.dart';
import '../service/ar_service.dart';
import '../service/i_ar_service.dart';
import '../service/i_location_service.dart';
import '../service/location_service.dart';
import 'i_ar_provider.dart';

class ARProvider with ChangeNotifier implements IARProvider {
  // Services
  late IARService _arService;
  late ILocationService _locationService;

  // State variables
  bool _isLoading = false;
  bool _isEnabled = false;
  String? _error;
  Position? _currentPosition;
  bool _isCameraActive = false;

  // AR Objects
  List<ARMonster> _nearbyMonsters = [];
  List<ARMonster> _personalMonsters = [];
  List<ARResource> _nearbyResources = [];

  // Selected objects
  ARMonster? _selectedMonster;
  ARResource? _selectedResource;

  // Combat
  CombatSession? _activeCombatSession;
  bool _isInCombat = false;

  // Personal spawns settings
  bool _personalSpawnsEnabled = true;
  Timer? _personalSpawnTimer;
  final int _personalSpawnRadius = 100;
  final int _maxPersonalSpawns = 5;

  // Refresh timer
  Timer? _refreshTimer;

  // Constructor
  ARProvider() {
    _arService = ARService(VexanaManager.instance.networkManager);
    _locationService = LocationService(VexanaManager.instance.networkManager);
  }

  // Getters implementation
  @override
  bool get isLoading => _isLoading;

  @override
  bool get isEnabled => _isEnabled;

  @override
  String? get error => _error;

  @override
  Position? get currentPosition => _currentPosition;

  @override
  bool get isCameraActive => _isCameraActive;

  @override
  List<ARMonster> get nearbyMonsters => _nearbyMonsters;

  @override
  List<ARMonster> get personalMonsters => _personalMonsters;

  @override
  List<ARMonster> get allMonsters => [..._nearbyMonsters, ..._personalMonsters];

  @override
  List<ARResource> get nearbyResources => _nearbyResources;

  @override
  ARMonster? get selectedMonster => _selectedMonster;

  @override
  ARResource? get selectedResource => _selectedResource;

  @override
  CombatSession? get activeCombatSession => _activeCombatSession;

  @override
  bool get isInCombat => _isInCombat;

  @override
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔄 ARProvider: Initializing AR system');

      // Get current location
      _currentPosition = await _locationService.getCurrentPosition();

      if (_currentPosition != null) {
        await _refreshARObjects();

        if (_personalSpawnsEnabled) {
          await _generatePersonalSpawns();
          _startPersonalSpawnSystem();
        }

        _startPeriodicRefresh();
        _isEnabled = true;

        debugPrint('✅ ARProvider: Initialization successful');
      } else {
        _error = 'Location not available';
        debugPrint('❌ ARProvider: Location not available');
      }
    } catch (e) {
      _error = 'Failed to initialize AR: $e';
      debugPrint('❌ ARProvider: Initialization failed - $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> refreshARObjects() async {
    if (_currentPosition == null) return;
    await _refreshARObjects();
  }

  @override
  void enableAR() {
    _isEnabled = true;
    debugPrint('🔛 ARProvider: AR enabled');
    notifyListeners();
  }

  @override
  void disableAR() {
    _isEnabled = false;
    _stopPeriodicRefresh();
    debugPrint('🔲 ARProvider: AR disabled');
    notifyListeners();
  }

  @override
  void startARCamera() {
    _isCameraActive = true;
    debugPrint('📷 ARProvider: AR camera started');
    notifyListeners();
  }

  @override
  void stopARCamera() {
    _isCameraActive = false;
    _selectedMonster = null;
    _selectedResource = null;
    debugPrint('📷 ARProvider: AR camera stopped');
    notifyListeners();
  }

  @override
  void selectMonster(ARMonster monster) {
    _selectedMonster = monster;
    _selectedResource = null;
    debugPrint('🎯 ARProvider: Monster selected - ${monster.name}');
    notifyListeners();
  }

  @override
  void selectResource(ARResource resource) {
    _selectedResource = resource;
    _selectedMonster = null;
    debugPrint('🎯 ARProvider: Resource selected - ${resource.name}');
    notifyListeners();
  }

  @override
  void clearSelection() {
    _selectedMonster = null;
    _selectedResource = null;
    debugPrint('🎯 ARProvider: Selection cleared');
    notifyListeners();
  }

  @override
  Future<bool> engageMonster(ARMonster monster) async {
    if (_currentPosition == null || _isInCombat) return false;

    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('⚔️ ARProvider: Engaging monster ${monster.name}');

      final session = await _arService.engageMonster(
        monster.id ?? '',
        _currentPosition!,
      );

      if (session != null) {
        _activeCombatSession = session;
        _isInCombat = true;

        debugPrint('✅ ARProvider: Combat session started');
        return true;
      } else {
        debugPrint('❌ ARProvider: Failed to start combat session');
        return false;
      }
    } catch (e) {
      _error = 'Failed to engage monster: $e';
      debugPrint('❌ ARProvider: Engage monster error - $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> completeCombat(CombatResult result) async {
    if (_activeCombatSession == null) return;

    try {
      debugPrint(
        '🏆 ARProvider: Completing combat with result: ${result.isVictory ? "Victory" : "Defeat"}',
      );

      final rewards = await _arService.completeCombat(
        _activeCombatSession!.id,
        result,
      );

      if (rewards != null) {
        debugPrint('🎁 ARProvider: Combat rewards received');
        // Handle rewards here if needed
      }

      _activeCombatSession = null;
      _isInCombat = false;
      _selectedMonster = null;

      // Refresh AR objects to update monster status
      await _refreshARObjects();

      debugPrint('✅ ARProvider: Combat completed');
    } catch (e) {
      _error = 'Failed to complete combat: $e';
      debugPrint('❌ ARProvider: Complete combat error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> abandonCombat() async {
    if (_activeCombatSession == null) return;

    try {
      debugPrint('🏃 ARProvider: Abandoning combat');

      await _arService.abandonCombat(_activeCombatSession!.id);

      _activeCombatSession = null;
      _isInCombat = false;
      _selectedMonster = null;

      debugPrint('✅ ARProvider: Combat abandoned');
    } catch (e) {
      _error = 'Failed to abandon combat: $e';
      debugPrint('❌ ARProvider: Abandon combat error - $e');
    }

    notifyListeners();
  }

  @override
  Future<bool> harvestResource(ARResource resource) async {
    if (_currentPosition == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('🌿 ARProvider: Harvesting resource ${resource.name}');

      final result = await _arService.harvestResource(
        resource.id ?? '',
        _currentPosition!,
      );

      if (result != null) {
        // Remove harvested resource from list
        _nearbyResources.removeWhere((r) => r.id == resource.id);
        _selectedResource = null;

        debugPrint('✅ ARProvider: Resource harvested successfully');
        return true;
      } else {
        debugPrint('❌ ARProvider: Failed to harvest resource');
        return false;
      }
    } catch (e) {
      _error = 'Failed to harvest resource: $e';
      debugPrint('❌ ARProvider: Harvest resource error - $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> generatePersonalSpawns() async {
    await _generatePersonalSpawns();
  }

  @override
  void enablePersonalSpawns(bool enabled) {
    _personalSpawnsEnabled = enabled;

    if (enabled) {
      _startPersonalSpawnSystem();
    } else {
      _personalSpawnTimer?.cancel();
      _personalSpawnTimer = null;
    }

    debugPrint(
      '🎮 ARProvider: Personal spawns ${enabled ? "enabled" : "disabled"}',
    );
    notifyListeners();
  }

  @override
  void updateLocation(Position position) {
    _currentPosition = position;

    // Auto-refresh if location changed significantly
    if (_shouldRefreshForLocation(position)) {
      _refreshARObjects();
    }

    notifyListeners();
  }

  @override
  Future<void> removeARObject(String objectId) async {
    try {
      final success = await _arService.removeARObject(objectId);

      if (success) {
        _nearbyMonsters.removeWhere((m) => m.id == objectId);
        _personalMonsters.removeWhere((m) => m.id == objectId);
        _nearbyResources.removeWhere((r) => r.id == objectId);

        if (_selectedMonster?.id == objectId) _selectedMonster = null;
        if (_selectedResource?.id == objectId) _selectedResource = null;

        debugPrint('🗑️ ARProvider: AR object removed - $objectId');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ ARProvider: Remove AR object error - $e');
    }
  }

  @override
  Future<void> reportARObject(String objectId, String reason) async {
    try {
      await _arService.reportARObject(objectId, reason);
      debugPrint(
        '🚨 ARProvider: AR object reported - $objectId, reason: $reason',
      );
    } catch (e) {
      debugPrint('❌ ARProvider: Report AR object error - $e');
    }
  }

  // Private methods
  Future<void> _refreshARObjects() async {
    if (_currentPosition == null || !_isEnabled) return;

    try {
      final data = await _arService.getNearbyObjects(_currentPosition!);

      _nearbyMonsters = data.monsters;
      _nearbyResources = data.resources;

      debugPrint(
        '🔄 ARProvider: Objects refreshed - ${_nearbyMonsters.length} monsters, ${_nearbyResources.length} resources',
      );

      notifyListeners();
    } catch (e) {
      debugPrint('❌ ARProvider: Refresh objects error - $e');
    }
  }

  Future<void> _generatePersonalSpawns() async {
    if (_currentPosition == null || !_personalSpawnsEnabled) return;

    try {
      final data = await _arService.getPersonalSpawns(
        _currentPosition!,
        radius: _personalSpawnRadius,
        maxSpawns: _maxPersonalSpawns,
      );

      _personalMonsters.addAll(data.personalMonsters);

      debugPrint(
        '🎯 ARProvider: Generated ${data.personalMonsters.length} personal spawns',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('❌ ARProvider: Generate personal spawns error - $e');
    }
  }

  void _startPersonalSpawnSystem() {
    _personalSpawnTimer?.cancel();

    // Her 2 dakikada bir personal spawn'ları kontrol et
    _personalSpawnTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (_personalSpawnsEnabled) {
        _generatePersonalSpawns();
      }
    });

    debugPrint('⏰ ARProvider: Personal spawn system started');
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();

    // Her 30 saniyede bir refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isEnabled && _currentPosition != null) {
        _refreshARObjects();
      }
    });

    debugPrint('⏰ ARProvider: Periodic refresh started');
  }

  void _stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    debugPrint('⏰ ARProvider: Periodic refresh stopped');
  }

  bool _shouldRefreshForLocation(Position newPosition) {
    if (_currentPosition == null) return true;

    final distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    return distance > 50; // 50m hareket ettiyse refresh
  }

  @override
  void dispose() {
    _stopPeriodicRefresh();
    _personalSpawnTimer?.cancel();
    debugPrint('🔚 ARProvider: Disposed');
    super.dispose();
  }
}
