abstract class ILocationProvider {
  Future<void> initialize();

  Future<void> startLocationTracking();

  void stopLocationTracking();

  Future<void> refreshNearbyCharacters();

  Future<bool> requestLocationPermission();

  Future<void> openLocationSettings();
}
