import 'package:geolocator/geolocator.dart';

abstract class ILocationService {
  Future<Position?> getCurrentPosition();

  Stream<Position> startLocationTracking({
    int distanceFilter = 10, // meters
    LocationAccuracy accuracy = LocationAccuracy.high,
  });

  void stopLocationTracking();

  Future<bool> isLocationServiceEnabled();

  double distanceBetween(double lat1, double lon1, double lat2, double lon2);

  Position? getLastKnownPosition();

  Future<bool> showLocationSettingsDialog();
}
