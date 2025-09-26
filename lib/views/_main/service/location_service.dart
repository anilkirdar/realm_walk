import 'package:geolocator/geolocator.dart';

import 'i_location_service.dart';

class LocationService extends ILocationService {
  static bool _isTracking = false;
  static Position? _lastKnownPosition;

  // Get current position
  @override
  Future<Position?> getCurrentPosition() async {
    try {
      // Check permissions
      if (!await _checkPermissions()) {
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _lastKnownPosition = position;
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return _lastKnownPosition; // Return last known if available
    }
  }

  // Start location tracking
  @override
  Stream<Position> startLocationTracking({
    int distanceFilter = 10, // meters
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    _isTracking = true;

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: const Duration(seconds: 15),
      ),
    ).where((position) => _isTracking);
  }

  // Stop location tracking
  @override
  void stopLocationTracking() {
    _isTracking = false;
  }

  // Check location permissions
  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Open settings
      await Geolocator.openAppSettings();
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // Check if location services are enabled
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Calculate distance between two points
  @override
  double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Get last known position
  @override
  Position? getLastKnownPosition() {
    return _lastKnownPosition;
  }

  // Get location settings dialog
  @override
  Future<bool> showLocationSettingsDialog() async {
    return await Geolocator.openLocationSettings();
  }
}
