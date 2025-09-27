import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/init/network/vexana_manager.dart';
import '../model/nearby_character_model.dart';
import '../service/character_service.dart';
import '../service/i_character_service.dart';
import '../service/i_location_service.dart';
import '../service/location_service.dart';
import 'i_location_provider.dart';

class LocationProvider with ChangeNotifier implements ILocationProvider {
  // Services
  late ILocationService _locationService;
  late ICharacterService _characterService;

  // State variables
  Position? _currentPosition;
  List<NearbyCharacter> _nearbyCharacters = [];
  bool _isLocationEnabled = false;
  bool _isTracking = false;
  String? _locationError;
  DateTime? _lastUpdate;
  DateTime? _lastServerUpdate;

  // Settings
  Duration _trackingInterval = const Duration(seconds: 30);
  double _distanceFilter = 10.0;
  bool _backgroundLocationEnabled = false;

  // Streams
  StreamSubscription<Position>? _positionStreamSubscription;

  // Constructor
  LocationProvider() {
    _locationService = LocationService(VexanaManager.instance.networkManager);
    _characterService = CharacterService(VexanaManager.instance.networkManager);
  }

  // Getters implementation
  @override
  Position? get currentPosition => _currentPosition;

  @override
  List<NearbyCharacter> get nearbyCharacters => _nearbyCharacters;

  @override
  bool get isLocationEnabled => _isLocationEnabled;

  @override
  bool get isTracking => _isTracking;

  @override
  String? get locationError => _locationError;

  @override
  DateTime? get lastUpdate => _lastUpdate;

  @override
  Future<void> initialize() async {
    try {
      debugPrint('🔄 LocationProvider: Initializing location services');

      _isLocationEnabled = await _locationService.isLocationServiceEnabled();

      if (_isLocationEnabled) {
        final hasPermission = await _locationService.hasLocationPermission();

        if (hasPermission) {
          await getCurrentLocation();
          debugPrint('✅ LocationProvider: Initialization successful');
        } else {
          _locationError = 'Location permission required';
          debugPrint('❌ LocationProvider: No location permission');
        }
      } else {
        _locationError = 'Location service disabled';
        debugPrint('❌ LocationProvider: Location service disabled');
      }
    } catch (e) {
      _locationError = 'Failed to initialize location: $e';
      debugPrint('❌ LocationProvider: Initialization error - $e');
    }

    notifyListeners();
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      debugPrint('🔐 LocationProvider: Requesting location permission');

      final granted = await _locationService.requestLocationPermission();

      if (granted) {
        _locationError = null;
        _isLocationEnabled = await _locationService.isLocationServiceEnabled();
        debugPrint('✅ LocationProvider: Permission granted');
      } else {
        _locationError = 'Location permission denied';
        debugPrint('❌ LocationProvider: Permission denied');
      }

      notifyListeners();
      return granted;
    } catch (e) {
      _locationError = 'Permission request failed: $e';
      debugPrint('❌ LocationProvider: Permission request error - $e');
      notifyListeners();
      return false;
    }
  }

  @override
  Future<bool> hasLocationPermission() async {
    try {
      return await _locationService.hasLocationPermission();
    } catch (e) {
      debugPrint('❌ LocationProvider: Check permission error - $e');
      return false;
    }
  }

  @override
  Future<void> startLocationTracking() async {
    if (_isTracking || !_isLocationEnabled) return;

    try {
      debugPrint('🎯 LocationProvider: Starting location tracking');

      if (!await hasLocationPermission()) {
        final permissionGranted = await requestLocationPermission();
        if (!permissionGranted) {
          _locationError = 'Cannot start tracking without permission';
          notifyListeners();
          return;
        }
      }

      _isTracking = true;
      _locationError = null;

      final positionStream = _locationService.startLocationTracking(
        distanceFilter: _distanceFilter.toInt(),
      );

      _positionStreamSubscription = positionStream.listen(
        (position) async {
          _currentPosition = position;
          _lastUpdate = DateTime.now();

          debugPrint(
            '📍 LocationProvider: New position - ${position.latitude}, ${position.longitude}',
          );

          // Update server periodically
          if (_shouldUpdateServer()) {
            await updateLocationOnServer();
            await updateNearbyCharacters();
          }

          notifyListeners();
        },
        onError: (error) {
          _locationError = 'Location tracking error: $error';
          debugPrint('❌ LocationProvider: Tracking error - $error');
          notifyListeners();
        },
      );

      debugPrint('✅ LocationProvider: Location tracking started');
    } catch (e) {
      _locationError = 'Failed to start tracking: $e';
      _isTracking = false;
      debugPrint('❌ LocationProvider: Start tracking error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> stopLocationTracking() async {
    if (!_isTracking) return;

    debugPrint('⏹️ LocationProvider: Stopping location tracking');

    _isTracking = false;
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _locationService.stopLocationTracking();

    debugPrint('✅ LocationProvider: Location tracking stopped');
    notifyListeners();
  }

  @override
  Future<void> getCurrentLocation() async {
    try {
      debugPrint('📍 LocationProvider: Getting current location');

      _locationError = null;

      final position = await _locationService.getCurrentPosition();

      if (position != null) {
        _currentPosition = position;
        _lastUpdate = DateTime.now();

        // Update server with new location
        await updateLocationOnServer();
        await updateNearbyCharacters();

        debugPrint('✅ LocationProvider: Current location obtained');
      } else {
        _locationError = 'Could not get current location';
        debugPrint('❌ LocationProvider: Could not get location');
      }
    } catch (e) {
      _locationError = 'Get location error: $e';
      debugPrint('❌ LocationProvider: Get location error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> updateNearbyCharacters() async {
    if (_currentPosition == null) return;

    try {
      debugPrint('👥 LocationProvider: Updating nearby characters');

      final characters = await _characterService.getNearbyCharacters(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        radius: 500, // 500m radius
      );

      _nearbyCharacters = characters;

      debugPrint(
        '✅ LocationProvider: Found ${characters.length} nearby characters',
      );
    } catch (e) {
      debugPrint('❌ LocationProvider: Update nearby characters error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> updateLocationOnServer() async {
    if (_currentPosition == null) return;

    try {
      debugPrint('🌐 LocationProvider: Updating location on server');

      final response = await _characterService.updateLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (response != null) {
        _lastServerUpdate = DateTime.now();
        debugPrint('✅ LocationProvider: Server location updated');
      } else {
        debugPrint('❌ LocationProvider: Failed to update server location');
      }
    } catch (e) {
      debugPrint('❌ LocationProvider: Update server location error - $e');
    }
  }

  @override
  void setTrackingInterval(Duration interval) {
    _trackingInterval = interval;
    debugPrint(
      '⏱️ LocationProvider: Tracking interval set to ${interval.inSeconds}s',
    );

    // Restart tracking with new interval if currently tracking
    if (_isTracking) {
      stopLocationTracking().then((_) => startLocationTracking());
    }
  }

  @override
  void setDistanceFilter(double distance) {
    _distanceFilter = distance;
    debugPrint('📏 LocationProvider: Distance filter set to ${distance}m');

    // Restart tracking with new distance filter if currently tracking
    if (_isTracking) {
      stopLocationTracking().then((_) => startLocationTracking());
    }
  }

  @override
  Future<void> enableBackgroundLocation() async {
    try {
      debugPrint('🔋 LocationProvider: Enabling background location');

      final success = await _locationService.enableBackgroundLocation();

      if (success) {
        _backgroundLocationEnabled = true;
        debugPrint('✅ LocationProvider: Background location enabled');
      } else {
        debugPrint('❌ LocationProvider: Failed to enable background location');
      }
    } catch (e) {
      debugPrint('❌ LocationProvider: Enable background location error - $e');
    }

    notifyListeners();
  }

  @override
  Future<void> disableBackgroundLocation() async {
    try {
      debugPrint('🔋 LocationProvider: Disabling background location');

      await _locationService.disableBackgroundLocation();
      _backgroundLocationEnabled = false;

      debugPrint('✅ LocationProvider: Background location disabled');
    } catch (e) {
      debugPrint('❌ LocationProvider: Disable background location error - $e');
    }

    notifyListeners();
  }

  @override
  double getDistanceToCharacter(NearbyCharacter character) {
    if (_currentPosition == null) return double.infinity;

    return _locationService.calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      character.latitude,
      character.longitude,
    );
  }

  @override
  bool isCharacterInRange(NearbyCharacter character, double maxDistance) {
    return getDistanceToCharacter(character) <= maxDistance;
  }

  // Helper methods
  bool _shouldUpdateServer() {
    if (_lastServerUpdate == null) return true;

    final timeSinceLastUpdate = DateTime.now().difference(_lastServerUpdate!);
    return timeSinceLastUpdate >= _trackingInterval;
  }

  // Public getters for settings
  Duration get trackingInterval => _trackingInterval;
  double get distanceFilter => _distanceFilter;
  bool get isBackgroundLocationEnabled => _backgroundLocationEnabled;

  @override
  void dispose() {
    stopLocationTracking();
    debugPrint('🔚 LocationProvider: Disposed');
    super.dispose();
  }
}
