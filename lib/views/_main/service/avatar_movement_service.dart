import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../enum/movement_state_enum.dart';
import '../model/character_avatar.dart';
import 'i_avatar_movement_service.dart';

class AvatarMovementService extends IAvatarMovementService {
  Position? _lastPosition;
  DateTime? _lastPositionTime;
  double _currentHeading = 0.0;
  MovementState _currentState = MovementState.idle;
  Timer? _movementTimer;

  // Movement calculation constants
  final double _walkingSpeedThreshold = 1.0; // m/s
  final double _runningSpeedThreshold = 3.0; // m/s
  final double _teleportThreshold = 20.0; // m/s (GPS jumps)
  final Duration _idleTimeout = Duration(seconds: 5);

  @override
  void startTracking(Stream<Position> positionStream) {
    positionStream.listen((position) {
      _updateMovement(position);
    });

    // Check for idle state periodically
    _movementTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkIdleState();
    });
  }

  @override
  void stopTracking() {
    _movementTimer?.cancel();
    _movementTimer = null;
  }

  void _updateMovement(Position newPosition) {
    final now = DateTime.now();

    if (_lastPosition != null && _lastPositionTime != null) {
      // Calculate movement
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      final timeDiff = now.difference(_lastPositionTime!).inSeconds;
      final speed = timeDiff > 0 ? distance / timeDiff : 0.0;

      // Calculate heading (bearing)
      _currentHeading = Geolocator.bearingBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // Normalize heading to 0-360
      if (_currentHeading < 0) _currentHeading += 360;

      // Determine movement state
      if (speed > _teleportThreshold) {
        _currentState = MovementState.teleporting;
      } else if (speed > _runningSpeedThreshold) {
        _currentState = MovementState.running;
      } else if (speed > _walkingSpeedThreshold) {
        _currentState = MovementState.walking;
      } else {
        _currentState = MovementState.idle;
      }

      print(
        '🏃 Movement: ${speed.toStringAsFixed(1)} m/s, ${_currentHeading.toStringAsFixed(0)}°, $_currentState',
      );
    }

    _lastPosition = newPosition;
    _lastPositionTime = now;
  }

  void _checkIdleState() {
    if (_lastPositionTime != null &&
        DateTime.now().difference(_lastPositionTime!) > _idleTimeout) {
      _currentState = MovementState.idle;
    }
  }

  @override
  CharacterMovement getCurrentMovement() {
    return CharacterMovement(
      speed: _calculateCurrentSpeed(),
      heading: _currentHeading,
      state: _currentState,
      lastMovement: _lastPositionTime ?? DateTime.now(),
    );
  }

  double _calculateCurrentSpeed() {
    if (_lastPosition == null || _lastPositionTime == null) return 0.0;

    final timeDiff = DateTime.now().difference(_lastPositionTime!).inSeconds;
    if (timeDiff > _idleTimeout.inSeconds) return 0.0;

    // Return last calculated speed based on movement state
    switch (_currentState) {
      case MovementState.idle:
        return 0.0;
      case MovementState.walking:
        return 2.0; // Average walking speed
      case MovementState.running:
        return 4.5; // Average running speed
      case MovementState.teleporting:
        return 0.0; // Don't show teleporting speed
    }
  }

  // Get movement animation frame for character avatar
  @override
  String getMovementAnimation() {
    switch (_currentState) {
      case MovementState.idle:
        return 'idle';
      case MovementState.walking:
        return 'walking';
      case MovementState.running:
        return 'running';
      case MovementState.teleporting:
        return 'teleport_effect';
    }
  }

  // Calculate smoothed position for animation
  @override
  Position getSmoothedPosition(Position targetPosition) {
    if (_lastPosition == null) return targetPosition;

    // Smooth movement to prevent jittery GPS updates
    final lerpFactor = _currentState == MovementState.teleporting ? 1.0 : 0.3;

    final smoothLat =
        _lastPosition!.latitude +
        (targetPosition.latitude - _lastPosition!.latitude) * lerpFactor;
    final smoothLng =
        _lastPosition!.longitude +
        (targetPosition.longitude - _lastPosition!.longitude) * lerpFactor;

    return Position(
      latitude: smoothLat,
      longitude: smoothLng,
      timestamp: targetPosition.timestamp,
      accuracy: targetPosition.accuracy,
      altitude: targetPosition.altitude,
      altitudeAccuracy: targetPosition.altitudeAccuracy,
      heading: targetPosition.heading,
      speed: targetPosition.speed,
      speedAccuracy: targetPosition.speedAccuracy,
      headingAccuracy: targetPosition.headingAccuracy,
    );
  }
}
