import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vexana/vexana.dart';

import '../../../../core/constants/network/api_const.dart';
import '../../../../core/init/cache/local_manager.dart';
import '../../../../core/init/network/vexana_manager.dart';
import '../../../../product/enum/local_keys_enum.dart';
import '../model/auto_spawn_response.dart';
import '../model/nearby_character_model.dart';
import '../service/character_service.dart';
import '../service/location_service.dart';
import 'i_location_provider.dart';

class LocationProvider with ChangeNotifier implements ILocationProvider {
  LocationService locationService = LocationService();
  CharacterService characterService = CharacterService(
    VexanaManager.instance.networkManager,
  );

  Position? _currentPosition;
  List<NearbyCharacter> _nearbyCharacters = [];
  bool _isLocationEnabled = false;
  bool _isTracking = false;
  String? _locationError;
  DateTime? _lastUpdate;

  // Getters
  Position? get currentPosition => _currentPosition;
  List<NearbyCharacter> get nearbyCharacters => _nearbyCharacters;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get isTracking => _isTracking;
  String? get locationError => _locationError;
  DateTime? get lastUpdate => _lastUpdate;

  // Initialize location services
  @override
  Future<void> initialize() async {
    _isLocationEnabled = await locationService.isLocationServiceEnabled();

    if (_isLocationEnabled) {
      await _getCurrentLocation();
    }

    notifyListeners();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      _locationError = null;
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        _currentPosition = position;
        _lastUpdate = DateTime.now();

        // Update server with new location
        await characterService.updateLocation(
          position.latitude,
          position.longitude,
        );

        // Get nearby characters
        await _updateNearbyCharacters();
      }
    } catch (e) {
      _locationError = 'Location error: $e';
    }

    notifyListeners();
  }

  // Start location tracking
  @override
  Future<void> startLocationTracking() async {
    if (_isTracking) return;

    _isTracking = true;
    _locationError = null;

    locationService
        .startLocationTracking(distanceFilter: 10)
        .listen(
          (position) async {
            _currentPosition = position;
            _lastUpdate = DateTime.now();

            // Update server every 30 seconds or significant movement
            if (_shouldUpdateServer()) {
              await characterService.updateLocation(
                position.latitude,
                position.longitude,
              );

              // Update nearby characters periodically
              if (_lastUpdate != null &&
                  DateTime.now().difference(_lastUpdate!).inMinutes >= 1) {
                await _updateNearbyCharacters();
              }
            }

            notifyListeners();
          },
          onError: (error) {
            _locationError = 'Tracking error: $error';
            _isTracking = false;
            notifyListeners();
          },
        );
  }

  // Stop location tracking
  @override
  void stopLocationTracking() {
    if (!_isTracking) return;

    _isTracking = false;
    locationService.stopLocationTracking();
    notifyListeners();
  }

  // Update nearby characters
  Future<void> _updateNearbyCharacters() async {
    try {
      final characters = await characterService.getNearbyCharacters(
        radius: 1000,
      );
      _nearbyCharacters = characters;
    } catch (e) {
      print('Error updating nearby characters: $e');
    }
  }

  // Refresh nearby characters manually
  @override
  Future<void> refreshNearbyCharacters() async {
    await _updateNearbyCharacters();
    notifyListeners();
  }

  // Check if should update server (rate limiting)
  bool _shouldUpdateServer() {
    return _lastUpdate == null ||
        DateTime.now().difference(_lastUpdate!).inSeconds >= 30;
  }

  // Request location permission
  @override
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    _isLocationEnabled =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    if (_isLocationEnabled) {
      await _getCurrentLocation();
    }

    notifyListeners();
    return _isLocationEnabled;
  }

  // Open location settings
  @override
  Future<void> openLocationSettings() async {
    await locationService.showLocationSettingsDialog();
  }

  // Auto-spawn objects when location changes significantly
  Future<void> autoSpawnObjectsIfNeeded() async {
    if (_currentPosition == null) return;

    try {
      final token = LocalManager.instance.getStringValue(
        LocalManagerKeys.token,
      );
      if (token == '') return;

      final response = await VexanaManager.instance.networkManager
          .send<AutoSpawnResponse, AutoSpawnResponse>(
            APIConst.autoSpawn,
            parseModel: AutoSpawnResponse(),
            method: RequestType.POST,
            data: {
              'latitude': _currentPosition!.latitude,
              'longitude': _currentPosition!.longitude,
              'radius': 1000,
              'count': 8,
            },
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

      if (response.data?.success == true) {
        print('🌍 Auto-spawned objects: ${response.data?.spawned}');
        print('🏞️ Biome: ${response.data?.location?.biome}');
      }
    } catch (e) {
      print('❌ Auto-spawn error: $e');
    }
  }
}
