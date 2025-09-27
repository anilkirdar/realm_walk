import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../../../../core/base/service/base_service.dart';
import 'i_location_service.dart';

class LocationService extends ILocationService with BaseService {
  LocationService(super.manager);

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamController<Position>? _locationStreamController;
  Position? _lastKnownPosition;
  bool _isTracking = false;

  @override
  Future<bool> requestLocationPermission() async {
    try {
      printDev.debug('LocationService: Requesting location permission');

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          printDev.exception(
            'LocationService: Location permissions are denied',
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        printDev.exception(
          'LocationService: Location permissions are permanently denied',
        );
        return false;
      }

      printDev.debug('LocationService: Location permission granted');
      return true;
    } catch (e) {
      printDev.exception('LocationService: Permission request error - $e');
      // crashlyticsManager.sendACrash(
      //   'Location Permission Error',
      //   e.toString(),
      // );
      return false;
    }
  }

  @override
  Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      printDev.exception('LocationService: Check permission error - $e');
      return false;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      printDev.exception('LocationService: Service enabled check error - $e');
      return false;
    }
  }

  @override
  Future<Position?> getCurrentPosition() async {
    try {
      printDev.debug('LocationService: Getting current position');

      if (!await hasLocationPermission()) {
        final permissionGranted = await requestLocationPermission();
        if (!permissionGranted) {
          printDev.exception('LocationService: No permission for location');
          return null;
        }
      }

      if (!await isLocationServiceEnabled()) {
        printDev.exception('LocationService: Location service is disabled');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _lastKnownPosition = position;

      printDev.debug(
        'LocationService: Position obtained - '
        'Lat: ${position.latitude}, Lng: ${position.longitude}, '
        'Accuracy: ${position.accuracy}m',
      );

      return position;
    } catch (e) {
      printDev.exception('LocationService: Get current position error - $e');
      await crashlyticsManager.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'Get Current Position Error',
      );
      return _lastKnownPosition; // Return last known position as fallback
    }
  }

  @override
  Stream<Position> startLocationTracking({int distanceFilter = 10}) {
    if (_isTracking) {
      return _locationStreamController!.stream;
    }

    printDev.debug(
      'LocationService: Starting location tracking with distance filter: ${distanceFilter}m',
    );

    _isTracking = true;
    _locationStreamController = StreamController<Position>.broadcast();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      timeLimit: Duration(seconds: 30),
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _lastKnownPosition = position;

            if (isValidLocation(position.latitude, position.longitude)) {
              _locationStreamController?.add(position);

              printDev.debug(
                'LocationService: New position - '
                'Lat: ${position.latitude}, Lng: ${position.longitude}, '
                'Accuracy: ${position.accuracy}m',
              );
            }
          },
          onError: (error) {
            printDev.exception(
              'LocationService: Position stream error - $error',
            );
            crashlyticsManager.sendACrash(
              error: error.toString(),
              stackTrace: StackTrace.current,
              reason: 'Location Stream Error',
            );
            _locationStreamController?.addError(error);
          },
        );

    return _locationStreamController!.stream;
  }

  @override
  void stopLocationTracking() {
    if (!_isTracking) return;

    printDev.debug('LocationService: Stopping location tracking');

    _isTracking = false;
    _positionStreamSubscription?.cancel();
    _locationStreamController?.close();

    _positionStreamSubscription = null;
    _locationStreamController = null;
  }

  @override
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e) {
      printDev.exception('LocationService: Calculate distance error - $e');
      return double.infinity;
    }
  }

  @override
  bool isValidLocation(double latitude, double longitude) {
    // Basic location validation
    if (latitude < -90 || latitude > 90) return false;
    if (longitude < -180 || longitude > 180) return false;

    // Check for invalid coordinates (0,0 - Gulf of Guinea)
    if (latitude == 0 && longitude == 0) return false;

    return true;
  }

  @override
  Future<bool> enableBackgroundLocation() async {
    try {
      printDev.debug('LocationService: Enabling background location');

      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always) {
        // Background location için always permission gerekli
        final newPermission = await Geolocator.requestPermission();
        return newPermission == LocationPermission.always;
      }

      return true;
    } catch (e) {
      printDev.exception(
        'LocationService: Enable background location error - $e',
      );
      return false;
    }
  }

  @override
  Future<bool> disableBackgroundLocation() async {
    try {
      printDev.debug('LocationService: Disabling background location');
      stopLocationTracking();
      return true;
    } catch (e) {
      printDev.exception(
        'LocationService: Disable background location error - $e',
      );
      return false;
    }
  }

  // Cleanup method
  void dispose() {
    stopLocationTracking();
    printDev.debug('LocationService: Disposed');
  }
}
