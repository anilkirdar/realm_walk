// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterMovement _$CharacterMovementFromJson(Map<String, dynamic> json) =>
    CharacterMovement(
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      state: $enumDecode(_$MovementStateEnumMap, json['state']),
      lastMovement: DateTime.parse(json['lastMovement'] as String),
      acceleration: (json['acceleration'] as num?)?.toDouble(),
      previousSpeed: (json['previousSpeed'] as num?)?.toDouble(),
      previousHeading: (json['previousHeading'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CharacterMovementToJson(CharacterMovement instance) =>
    <String, dynamic>{
      'speed': instance.speed,
      'heading': instance.heading,
      'state': _$MovementStateEnumMap[instance.state]!,
      'lastMovement': instance.lastMovement.toIso8601String(),
      'acceleration': instance.acceleration,
      'previousSpeed': instance.previousSpeed,
      'previousHeading': instance.previousHeading,
    };

const _$MovementStateEnumMap = {
  MovementState.idle: 'idle',
  MovementState.walking: 'walking',
  MovementState.running: 'running',
  MovementState.teleporting: 'teleporting',
};

AvatarAnimation _$AvatarAnimationFromJson(Map<String, dynamic> json) =>
    AvatarAnimation(
      animationId: json['animationId'] as String,
      animationType: json['animationType'] as String,
      duration: (json['duration'] as num).toDouble(),
      isLooping: json['isLooping'] as bool? ?? false,
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      parameters: json['parameters'] as Map<String, dynamic>?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$AvatarAnimationToJson(AvatarAnimation instance) =>
    <String, dynamic>{
      'animationId': instance.animationId,
      'animationType': instance.animationType,
      'duration': instance.duration,
      'isLooping': instance.isLooping,
      'playbackSpeed': instance.playbackSpeed,
      'parameters': instance.parameters,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };

AvatarState _$AvatarStateFromJson(Map<String, dynamic> json) => AvatarState(
  avatarId: json['avatarId'] as String,
  movement: CharacterMovement.fromJson(
    json['movement'] as Map<String, dynamic>,
  ),
  currentAnimation: json['currentAnimation'] == null
      ? null
      : AvatarAnimation.fromJson(
          json['currentAnimation'] as Map<String, dynamic>,
        ),
  animationQueue:
      (json['animationQueue'] as List<dynamic>?)
          ?.map((e) => AvatarAnimation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  visualEffects: json['visualEffects'] as Map<String, dynamic>?,
  isVisible: json['isVisible'] as bool? ?? true,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
  lastUpdate: DateTime.parse(json['lastUpdate'] as String),
);

Map<String, dynamic> _$AvatarStateToJson(AvatarState instance) =>
    <String, dynamic>{
      'avatarId': instance.avatarId,
      'movement': instance.movement.toJson(),
      'currentAnimation': instance.currentAnimation?.toJson(),
      'animationQueue': instance.animationQueue.map((e) => e.toJson()).toList(),
      'visualEffects': instance.visualEffects,
      'isVisible': instance.isVisible,
      'opacity': instance.opacity,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
