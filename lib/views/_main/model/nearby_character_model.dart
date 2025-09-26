// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'character_model.dart';

part 'nearby_character_model.g.dart';

@JsonSerializable()
class NearbyCharacter extends INetworkModel<NearbyCharacter> {
  final String? id;
  final String? name;
  final String? username;
  final String? characterClass;
  final int? level;
  final double? distance; // in meters
  final CharacterLocation? location;

  const NearbyCharacter({
    this.id,
    this.name,
    this.username,
    this.characterClass,
    this.level,
    this.distance,
    this.location,
  });

  factory NearbyCharacter.fromJson(Map<String, dynamic> json) {
    return NearbyCharacter(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      characterClass: json['class'],
      level: json['level'],
      distance: json['distance'].toDouble(),
      location: CharacterLocation.fromJson(json['location']),
    );
  }

  String? get classDisplayName {
    switch (characterClass) {
      case 'warrior':
        return 'Savaşçı';
      case 'mage':
        return 'Büyücü';
      case 'archer':
        return 'Okçu';
      default:
        return characterClass;
    }
  }

  String get classEmoji {
    switch (characterClass) {
      case 'warrior':
        return '⚔️';
      case 'mage':
        return '🔮';
      case 'archer':
        return '🏹';
      default:
        return '🎮';
    }
  }

  String? get distanceFormatted {
    if (distance == null) return null;
    if (distance! < 1000) {
      return '${distance!.toInt()}m';
    } else {
      return '${(distance! / 1000).toStringAsFixed(1)}km';
    }
  }

  @override
  NearbyCharacter fromJson(Map<String, dynamic> json) {
    return NearbyCharacter.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$NearbyCharacterToJson(this);

  NearbyCharacter copyWith({
    String? id,
    String? name,
    String? username,
    String? characterClass,
    int? level,
    double? distance,
    CharacterLocation? location,
  }) {
    return NearbyCharacter(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      distance: distance ?? this.distance,
      location: location ?? this.location,
    );
  }
}
