// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import '../enum/movement_state_enum.dart';

part 'character_avatar.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterMovement extends INetworkModel<CharacterMovement> {
  final double speed;
  final double heading;
  final MovementState state;
  final DateTime lastMovement;
  final double? acceleration;
  final double? previousSpeed;
  final double? previousHeading;

  const CharacterMovement({
    required this.speed,
    required this.heading,
    required this.state,
    required this.lastMovement,
    this.acceleration,
    this.previousSpeed,
    this.previousHeading,
  });

  factory CharacterMovement.fromJson(Map<String, dynamic> json) =>
      _$CharacterMovementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterMovementToJson(this);

  @override
  CharacterMovement fromJson(Map<String, dynamic> json) =>
      _$CharacterMovementFromJson(json);

  CharacterMovement copyWith({
    double? speed,
    double? heading,
    MovementState? state,
    DateTime? lastMovement,
    double? acceleration,
    double? previousSpeed,
    double? previousHeading,
  }) {
    return CharacterMovement(
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      state: state ?? this.state,
      lastMovement: lastMovement ?? this.lastMovement,
      acceleration: acceleration ?? this.acceleration,
      previousSpeed: previousSpeed ?? this.previousSpeed,
      previousHeading: previousHeading ?? this.previousHeading,
    );
  }

  // Helper methods
  bool get isMoving => state != MovementState.idle && speed > 0;
  bool get isIdle => state == MovementState.idle;
  bool get isWalking => state == MovementState.walking;
  bool get isRunning => state == MovementState.running;
  bool get isTeleporting => state == MovementState.teleporting;

  double get speedKmh => speed * 3.6; // m/s to km/h

  String get speedText {
    if (speed < 0.1) return 'Durgun';
    if (speedKmh < 1) return '${(speed * 100).round()} cm/s';
    if (speedKmh < 10) return '${speedKmh.toStringAsFixed(1)} km/h';
    return '${speedKmh.round()} km/h';
  }

  String get directionText {
    if (heading >= 337.5 || heading < 22.5) return 'Kuzey';
    if (heading >= 22.5 && heading < 67.5) return 'Kuzeydoğu';
    if (heading >= 67.5 && heading < 112.5) return 'Doğu';
    if (heading >= 112.5 && heading < 157.5) return 'Güneydoğu';
    if (heading >= 157.5 && heading < 202.5) return 'Güney';
    if (heading >= 202.5 && heading < 247.5) return 'Güneybatı';
    if (heading >= 247.5 && heading < 292.5) return 'Batı';
    if (heading >= 292.5 && heading < 337.5) return 'Kuzeybatı';
    return 'Bilinmeyen';
  }

  String get stateEmoji {
    switch (state) {
      case MovementState.idle:
        return '🧍';
      case MovementState.walking:
        return '🚶';
      case MovementState.running:
        return '🏃';
      case MovementState.teleporting:
        return '⚡';
    }
  }

  String get directionEmoji {
    if (heading >= 337.5 || heading < 22.5) return '⬆️';
    if (heading >= 22.5 && heading < 67.5) return '↗️';
    if (heading >= 67.5 && heading < 112.5) return '➡️';
    if (heading >= 112.5 && heading < 157.5) return '↘️';
    if (heading >= 157.5 && heading < 202.5) return '⬇️';
    if (heading >= 202.5 && heading < 247.5) return '↙️';
    if (heading >= 247.5 && heading < 292.5) return '⬅️';
    if (heading >= 292.5 && heading < 337.5) return '↖️';
    return '🧭';
  }

  Duration get timeSinceMovement => DateTime.now().difference(lastMovement);

  bool get isRecentMovement => timeSinceMovement.inSeconds < 5;

  double? get headingChange {
    if (previousHeading == null) return null;
    double change = heading - previousHeading!;

    // Normalize to -180 to 180 range
    while (change > 180) change -= 360;
    while (change < -180) change += 360;

    return change;
  }

  bool get isTurning {
    final change = headingChange;
    return change != null && change.abs() > 10; // 10 degrees threshold
  }

  String get movementDescription {
    if (isIdle) return 'Duruyor';

    String description = state.name;
    if (isTurning) {
      final change = headingChange!;
      if (change > 0) {
        description += ' (sağa dönüyor)';
      } else {
        description += ' (sola dönüyor)';
      }
    }

    return '$description $directionText yönünde';
  }
}

@JsonSerializable(explicitToJson: true)
class AvatarAnimation extends INetworkModel<AvatarAnimation> {
  final String animationId;
  final String animationType;
  final double duration;
  final bool isLooping;
  final double playbackSpeed;
  final Map<String, dynamic>? parameters;
  final DateTime startTime;
  final DateTime? endTime;

  const AvatarAnimation({
    required this.animationId,
    required this.animationType,
    required this.duration,
    this.isLooping = false,
    this.playbackSpeed = 1.0,
    this.parameters,
    required this.startTime,
    this.endTime,
  });

  factory AvatarAnimation.fromJson(Map<String, dynamic> json) =>
      _$AvatarAnimationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AvatarAnimationToJson(this);

  @override
  AvatarAnimation fromJson(Map<String, dynamic> json) =>
      _$AvatarAnimationFromJson(json);

  AvatarAnimation copyWith({
    String? animationId,
    String? animationType,
    double? duration,
    bool? isLooping,
    double? playbackSpeed,
    Map<String, dynamic>? parameters,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return AvatarAnimation(
      animationId: animationId ?? this.animationId,
      animationType: animationType ?? this.animationType,
      duration: duration ?? this.duration,
      isLooping: isLooping ?? this.isLooping,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      parameters: parameters ?? this.parameters,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  // Helper methods
  bool get isFinished {
    if (isLooping) return false;
    if (endTime != null) return DateTime.now().isAfter(endTime!);
    return DateTime.now().difference(startTime).inMilliseconds >
        (duration * 1000);
  }

  bool get isPlaying => !isFinished;

  double get progress {
    if (isLooping) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final cycleDuration = duration * 1000;
      return (elapsed % cycleDuration) / cycleDuration;
    }

    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final totalDuration = duration * 1000;
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  Duration get remainingTime {
    if (isLooping) return Duration.zero;
    final elapsed = DateTime.now().difference(startTime);
    final totalDuration = Duration(milliseconds: (duration * 1000).round());
    final remaining = totalDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get typeEmoji {
    switch (animationType.toLowerCase()) {
      case 'movement':
        return '🚶';
      case 'combat':
        return '⚔️';
      case 'idle':
        return '🧍';
      case 'gesture':
        return '👋';
      case 'emote':
        return '😊';
      case 'skill':
        return '✨';
      default:
        return '🎭';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class AvatarState extends INetworkModel<AvatarState> {
  final String avatarId;
  final CharacterMovement movement;
  final AvatarAnimation? currentAnimation;
  final List<AvatarAnimation> animationQueue;
  final Map<String, dynamic>? visualEffects;
  final bool isVisible;
  final double opacity;
  final DateTime lastUpdate;

  const AvatarState({
    required this.avatarId,
    required this.movement,
    this.currentAnimation,
    this.animationQueue = const [],
    this.visualEffects,
    this.isVisible = true,
    this.opacity = 1.0,
    required this.lastUpdate,
  });

  factory AvatarState.fromJson(Map<String, dynamic> json) =>
      _$AvatarStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AvatarStateToJson(this);

  @override
  AvatarState fromJson(Map<String, dynamic> json) =>
      _$AvatarStateFromJson(json);

  AvatarState copyWith({
    String? avatarId,
    CharacterMovement? movement,
    AvatarAnimation? currentAnimation,
    List<AvatarAnimation>? animationQueue,
    Map<String, dynamic>? visualEffects,
    bool? isVisible,
    double? opacity,
    DateTime? lastUpdate,
  }) {
    return AvatarState(
      avatarId: avatarId ?? this.avatarId,
      movement: movement ?? this.movement,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      animationQueue: animationQueue ?? this.animationQueue,
      visualEffects: visualEffects ?? this.visualEffects,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  // Helper methods
  bool get hasActiveAnimation =>
      currentAnimation != null && currentAnimation!.isPlaying;
  bool get hasQueuedAnimations => animationQueue.isNotEmpty;
  bool get hasVisualEffects =>
      visualEffects != null && visualEffects!.isNotEmpty;

  int get totalAnimations =>
      animationQueue.length + (hasActiveAnimation ? 1 : 0);

  Duration get timeSinceUpdate => DateTime.now().difference(lastUpdate);
  bool get isRecentlyUpdated => timeSinceUpdate.inSeconds < 1;

  String get statusSummary {
    List<String> status = [];

    if (!isVisible) {
      status.add('Görünmez');
    } else if (opacity < 1.0) {
      status.add('Şeffaf');
    }

    if (hasActiveAnimation) {
      status.add('Animasyon: ${currentAnimation!.animationType}');
    }

    if (hasQueuedAnimations) {
      status.add('Sırada: ${animationQueue.length}');
    }

    status.add('Hareket: ${movement.state.name}');

    return status.join(', ');
  }

  // Animation management helpers
  AvatarAnimation? get nextAnimation =>
      animationQueue.isNotEmpty ? animationQueue.first : null;

  bool get canPlayAnimation =>
      !hasActiveAnimation || currentAnimation!.isFinished;

  List<String> get queuedAnimationTypes =>
      animationQueue.map((anim) => anim.animationType).toList();
}
