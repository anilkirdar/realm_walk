import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:vexana/vexana.dart';

import '../../../../core/init/firebase/crashlytics/crashlytics_manager.dart';
import '../../../../core/init/network/model/error_model_custom.dart';

abstract class ILocationService {
  ILocationService(this.manager);

  final INetworkManager<ErrorModelCustom> manager;
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  final CrashlyticsMessages crashlyticsMessages = CrashlyticsMessages.instance;

  // Permission management
  Future<bool> requestLocationPermission();
  Future<bool> hasLocationPermission();
  Future<bool> isLocationServiceEnabled();

  // Location tracking
  Future<Position?> getCurrentPosition();
  Stream<Position> startLocationTracking({int distanceFilter = 10});
  void stopLocationTracking();

  // Distance calculations
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );

  // Location validation
  bool isValidLocation(double latitude, double longitude);

  // Background location
  Future<bool> enableBackgroundLocation();
  Future<bool> disableBackgroundLocation();
}
