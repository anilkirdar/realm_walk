import 'package:geolocator/geolocator.dart';

import '../model/nearby_character_model.dart';

abstract class ILocationProvider {
  // State getters
  Position? get currentPosition;
  List<NearbyCharacter> get nearbyCharacters;
  bool get isLocationEnabled;
  bool get isTracking;
  String? get locationError;
  DateTime? get lastUpdate;

  // Initialization
  Future<void> initialize();

  // Permission management
  Future<bool> requestLocationPermission();
  Future<bool> hasLocationPermission();

  // Location tracking
  Future<void> startLocationTracking();
  Future<void> stopLocationTracking();
  Future<void> getCurrentLocation();

  // Nearby features
  Future<void> updateNearbyCharacters();
  Future<void> updateLocationOnServer();

  // Settings
  void setTrackingInterval(Duration interval);
  void setDistanceFilter(double distance);

  // Background location
  Future<void> enableBackgroundLocation();
  Future<void> disableBackgroundLocation();

  // Utility methods
  double getDistanceToCharacter(NearbyCharacter character);
  bool isCharacterInRange(NearbyCharacter character, double maxDistance);
}
