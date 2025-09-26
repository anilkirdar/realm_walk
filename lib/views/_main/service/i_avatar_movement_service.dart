import 'package:geolocator/geolocator.dart';

import '../model/character_avatar.dart';

abstract class IAvatarMovementService {
  void startTracking(Stream<Position> positionStream);

  void stopTracking();

  CharacterMovement getCurrentMovement();

  String getMovementAnimation();

  Position getSmoothedPosition(Position targetPosition);
}
