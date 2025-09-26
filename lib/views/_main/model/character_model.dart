// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel extends INetworkModel<CharacterModel> {
  final String? id;
  final String? name;
  final String? characterClass;
  final int? level;
  final int? experience;
  final CharacterStats? stats;
  final CharacterLocation? location;

  const CharacterModel({
    this.id,
    this.name,
    this.characterClass,
    this.level,
    this.experience,
    this.stats,
    this.location,
  });

  CharacterModel copyWith({
    String? id,
    String? name,
    String? characterClass,
    int? level,
    int? experience,
    CharacterStats? stats,
    CharacterLocation? location,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      stats: stats ?? this.stats,
      location: location ?? this.location,
    );
  }

  @override
  CharacterModel fromJson(Map<String, dynamic> json) {
    return CharacterModel.fromJson(json);
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return _$CharacterModelFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CharacterModelToJson(this);

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
}

@JsonSerializable()
class CharacterStats {
  final HealthStat? health;
  final ManaStat? mana;
  final int? attack;
  final int? defense;
  final int? speed;

  CharacterStats({
    this.health,
    this.mana,
    this.attack,
    this.defense,
    this.speed,
  });

  factory CharacterStats.fromJson(Map<String, dynamic> json) {
    return CharacterStats(
      health: HealthStat.fromJson(json['health']),
      mana: ManaStat.fromJson(json['mana']),
      attack: json['attack'],
      defense: json['defense'],
      speed: json['speed'],
    );
  }

  @override
  CharacterStats fromJson(Map<String, dynamic> json) {
    return CharacterStats.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CharacterStatsToJson(this);

  CharacterStats copyWith({
    HealthStat? health,
    ManaStat? mana,
    int? attack,
    int? defense,
    int? speed,
  }) {
    return CharacterStats(
      health: health ?? this.health,
      mana: mana ?? this.mana,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
    );
  }
}

@JsonSerializable()
class HealthStat {
  final int? current;
  final int? max;

  HealthStat({this.current, this.max});

  factory HealthStat.fromJson(Map<String, dynamic> json) {
    return HealthStat(current: json['current'], max: json['max']);
  }

  double? get percentage =>
      current != null && max != null ? current! / max! : null;

  HealthStat copyWith({int? current, int? max}) {
    return HealthStat(current: current ?? this.current, max: max ?? this.max);
  }

  @override
  HealthStat fromJson(Map<String, dynamic> json) {
    return HealthStat.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$HealthStatToJson(this);
}

@JsonSerializable()
class ManaStat {
  final int? current;
  final int? max;

  ManaStat({this.current, this.max});

  factory ManaStat.fromJson(Map<String, dynamic> json) {
    return ManaStat(current: json['current'], max: json['max']);
  }

  double? get percentage =>
      current != null && max != null ? current! / max! : null;

  ManaStat copyWith({int? current, int? max}) {
    return ManaStat(current: current ?? this.current, max: max ?? this.max);
  }

  @override
  ManaStat fromJson(Map<String, dynamic> json) {
    return ManaStat.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$ManaStatToJson(this);
}

@JsonSerializable()
class CharacterLocation {
  final double? latitude;
  final double? longitude;
  final DateTime? lastSeen;

  CharacterLocation({this.latitude, this.longitude, this.lastSeen});

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  CharacterLocation copyWith({
    double? latitude,
    double? longitude,
    DateTime? lastSeen,
  }) {
    return CharacterLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  CharacterLocation fromJson(Map<String, dynamic> json) {
    return CharacterLocation.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$CharacterLocationToJson(this);
}
