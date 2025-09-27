import 'package:geolocator/geolocator.dart';

import '../enum/movement_state_enum.dart';
import '../model/character_avatar.dart';

abstract class IAvatarMovementService {
  // Movement tracking
  void startTracking(Stream<Position> positionStream);
  void stopTracking();
  bool get isTracking;

  // Movement data
  CharacterMovement getCurrentMovement();
  MovementState get currentState;
  double get currentSpeed;
  double get currentHeading;

  // Animation and visual
  String getMovementAnimation();
  Position getSmoothedPosition(Position targetPosition);

  // Movement calculations
  double calculateSpeed(Position from, Position to, Duration timeDiff);
  double calculateHeading(Position from, Position to);
  MovementState determineMovementState(double speed);

  // Settings
  void setSpeedThresholds({
    double? walkingThreshold,
    double? runningThreshold,
    double? teleportThreshold,
  });

  void setIdleTimeout(Duration timeout);
  Duration get idleTimeout;

  // State queries
  bool get isIdle;
  bool get isWalking;
  bool get isRunning;
  bool get isTeleporting;
  DateTime? get lastMovementTime;
}
