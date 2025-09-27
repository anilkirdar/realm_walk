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
  double _currentSpeed = 0.0;
  Timer? _movementTimer;
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;

  // Movement calculation constants
  double _walkingSpeedThreshold = 1.0; // m/s
  double _runningSpeedThreshold = 3.0; // m/s
  double _teleportThreshold = 20.0; // m/s (GPS jumps)
  Duration _idleTimeout = const Duration(seconds: 5);

  @override
  bool get isTracking => _isTracking;

  @override
  MovementState get currentState => _currentState;

  @override
  double get currentSpeed => _currentSpeed;

  @override
  double get currentHeading => _currentHeading;

  @override
  Duration get idleTimeout => _idleTimeout;

  @override
  bool get isIdle => _currentState == MovementState.idle;

  @override
  bool get isWalking => _currentState == MovementState.walking;

  @override
  bool get isRunning => _currentState == MovementState.running;

  @override
  bool get isTeleporting => _currentState == MovementState.teleporting;

  @override
  DateTime? get lastMovementTime => _lastPositionTime;

  @override
  void startTracking(Stream<Position> positionStream) {
    if (_isTracking) return;

    print('🏃 AvatarMovementService: Starting movement tracking');

    _isTracking = true;
    _positionSubscription = positionStream.listen(
      _updateMovement,
      onError: (error) {
        print('❌ AvatarMovementService: Position stream error - $error');
      },
    );

    // Check for idle state periodically
    _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkIdleState();
    });

    print('✅ AvatarMovementService: Movement tracking started');
  }

  @override
  void stopTracking() {
    if (!_isTracking) return;

    print('⏹️ AvatarMovementService: Stopping movement tracking');

    _isTracking = false;
    _positionSubscription?.cancel();
    _movementTimer?.cancel();

    _positionSubscription = null;
    _movementTimer = null;

    print('✅ AvatarMovementService: Movement tracking stopped');
  }

  @override
  CharacterMovement getCurrentMovement() {
    return CharacterMovement(
      speed: _currentSpeed,
      heading: _currentHeading,
      state: _currentState,
      lastMovement: _lastPositionTime ?? DateTime.now(),
    );
  }

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

  @override
  double calculateSpeed(Position from, Position to, Duration timeDiff) {
    if (timeDiff.inSeconds <= 0) return 0.0;

    final distance = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );

    return distance / timeDiff.inSeconds;
  }

  @override
  double calculateHeading(Position from, Position to) {
    final bearing = Geolocator.bearingBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );

    // Normalize heading to 0-360
    return bearing < 0 ? bearing + 360 : bearing;
  }

  @override
  MovementState determineMovementState(double speed) {
    if (speed > _teleportThreshold) {
      return MovementState.teleporting;
    } else if (speed > _runningSpeedThreshold) {
      return MovementState.running;
    } else if (speed > _walkingSpeedThreshold) {
      return MovementState.walking;
    } else {
      return MovementState.idle;
    }
  }

  @override
  void setSpeedThresholds({
    double? walkingThreshold,
    double? runningThreshold,
    double? teleportThreshold,
  }) {
    if (walkingThreshold != null) {
      _walkingSpeedThreshold = walkingThreshold;
      print(
        '🚶 AvatarMovementService: Walking threshold set to ${walkingThreshold}m/s',
      );
    }
    if (runningThreshold != null) {
      _runningSpeedThreshold = runningThreshold;
      print(
        '🏃 AvatarMovementService: Running threshold set to ${runningThreshold}m/s',
      );
    }
    if (teleportThreshold != null) {
      _teleportThreshold = teleportThreshold;
      print(
        '⚡ AvatarMovementService: Teleport threshold set to ${teleportThreshold}m/s',
      );
    }
  }

  @override
  void setIdleTimeout(Duration timeout) {
    _idleTimeout = timeout;
    print(
      '⏱️ AvatarMovementService: Idle timeout set to ${timeout.inSeconds}s',
    );
  }

  // Private methods
  void _updateMovement(Position newPosition) {
    final now = DateTime.now();

    if (_lastPosition != null && _lastPositionTime != null) {
      // Calculate movement metrics
      final timeDiff = now.difference(_lastPositionTime!);
      _currentSpeed = calculateSpeed(_lastPosition!, newPosition, timeDiff);
      _currentHeading = calculateHeading(_lastPosition!, newPosition);
      _currentState = determineMovementState(_currentSpeed);

      print(
        '🏃 AvatarMovementService: Speed: ${_currentSpeed.toStringAsFixed(1)}m/s, '
        'Heading: ${_currentHeading.toStringAsFixed(0)}°, '
        'State: ${_currentState.name}',
      );
    }

    _lastPosition = newPosition;
    _lastPositionTime = now;
  }

  void _checkIdleState() {
    if (_lastPositionTime != null &&
        DateTime.now().difference(_lastPositionTime!) > _idleTimeout) {
      if (_currentState != MovementState.idle) {
        _currentState = MovementState.idle;
        _currentSpeed = 0.0;
        print('😴 AvatarMovementService: Character became idle');
      }
    }
  }
}
