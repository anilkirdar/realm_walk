// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enum/movement_state_enum.dart';

part 'character_avatar.g.dart';

@JsonSerializable()
class CharacterAvatar {
  final String? characterId;
  final String? name;
  final String? characterClass;
  final int? level;
  @JsonKey(fromJson: _positionFromJson, toJson: _positionToJson)
  final Position? position;
  final CharacterMovement? movement;
  final CharacterAppearance? appearance;
  final DateTime? lastSeen;
  final bool? isOnline;

  const CharacterAvatar({
    this.characterId,
    this.name,
    this.characterClass,
    this.level,
    this.position,
    this.movement,
    this.appearance,
    this.lastSeen,
    this.isOnline,
  });

  factory CharacterAvatar.fromJson(Map<String, dynamic> json) =>
      _$CharacterAvatarFromJson(json);

  @override
  CharacterAvatar fromJson(Map<String, dynamic> json) =>
      CharacterAvatar.fromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CharacterAvatarToJson(this);

  CharacterAvatar copyWith({
    String? characterId,
    String? name,
    String? characterClass,
    int? level,
    Position? position,
    CharacterMovement? movement,
    CharacterAppearance? appearance,
    DateTime? lastSeen,
    bool? isOnline,
  }) {
    return CharacterAvatar(
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      position: position ?? this.position,
      movement: movement ?? this.movement,
      appearance: appearance ?? this.appearance,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  // Custom converters
  static Position? _positionFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Position(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      accuracy: (json['accuracy'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      speedAccuracy: (json['speedAccuracy'] as num).toDouble(),
      headingAccuracy: ((json['headingAccuracy'] as num?)?.toDouble()) ?? 0.0,
      altitudeAccuracy: ((json['altitudeAccuracy'] as num?)?.toDouble()) ?? 0.0,
    );
  }

  static Map<String, dynamic>? _positionToJson(Position? pos) {
    if (pos == null) return null;
    return {
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'timestamp': pos.timestamp?.toIso8601String(),
      'accuracy': pos.accuracy,
      'altitude': pos.altitude,
      'heading': pos.heading,
      'speed': pos.speed,
      'speedAccuracy': pos.speedAccuracy,
      'headingAccuracy': pos.headingAccuracy,
      'altitudeAccuracy': pos.altitudeAccuracy,
    };
  }
}

@JsonSerializable()
class CharacterMovement {
  final double? speed; // m/s
  final double? heading; // degrees (0-360)
  final MovementState? state;
  final DateTime? lastMovement;

  CharacterMovement({this.speed, this.heading, this.state, this.lastMovement});

  factory CharacterMovement.fromJson(Map<String, dynamic> json) =>
      _$CharacterMovementFromJson(json);

  @override
  CharacterMovement fromJson(Map<String, dynamic> json) =>
      CharacterMovement.fromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CharacterMovementToJson(this);

  CharacterMovement copyWith({
    double? speed,
    double? heading,
    MovementState? state,
    DateTime? lastMovement,
  }) {
    return CharacterMovement(
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      state: state ?? this.state,
      lastMovement: lastMovement ?? this.lastMovement,
    );
  }
}

@JsonSerializable()
class CharacterAppearance {
  final String? classEmoji;
  final String? outfitColor;
  final String? weaponType;
  @JsonKey(defaultValue: [])
  final List<String> equippedItems;
  final String? guildEmblem;

  CharacterAppearance({
    this.classEmoji,
    this.outfitColor,
    this.weaponType,
    this.equippedItems = const [],
    this.guildEmblem,
  });

  factory CharacterAppearance.fromJson(Map<String, dynamic> json) =>
      _$CharacterAppearanceFromJson(json);

  @override
  CharacterAppearance fromJson(Map<String, dynamic> json) =>
      CharacterAppearance.fromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CharacterAppearanceToJson(this);

  CharacterAppearance copyWith({
    String? classEmoji,
    String? outfitColor,
    String? weaponType,
    List<String>? equippedItems,
    String? guildEmblem,
  }) {
    return CharacterAppearance(
      classEmoji: classEmoji ?? this.classEmoji,
      outfitColor: outfitColor ?? this.outfitColor,
      weaponType: weaponType ?? this.weaponType,
      equippedItems: equippedItems ?? this.equippedItems,
      guildEmblem: guildEmblem ?? this.guildEmblem,
    );
  }
}
