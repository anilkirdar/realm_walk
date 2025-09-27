// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'character_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterModel extends INetworkModel<CharacterModel> {
  final String? id;
  final String? userId;
  final String? name;
  final String? characterClass;
  final int? level;
  final int? experience;
  final int? experienceToNextLevel;
  final CharacterStats? stats;
  final CharacterLocation? location;
  final CharacterAppearance? appearance;
  final List<String>? skills;
  final Map<String, dynamic>? equipment;
  final List<String>? achievements;
  final DateTime? createdAt;
  final DateTime? lastActive;
  final bool? isOnline;
  final String? currentActivity;
  final int? prestigeLevel;
  final String? guild;

  const CharacterModel({
    this.id,
    this.userId,
    this.name,
    this.characterClass,
    this.level,
    this.experience,
    this.experienceToNextLevel,
    this.stats,
    this.location,
    this.appearance,
    this.skills,
    this.equipment,
    this.achievements,
    this.createdAt,
    this.lastActive,
    this.isOnline,
    this.currentActivity,
    this.prestigeLevel,
    this.guild,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  @override
  CharacterModel fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  CharacterModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? characterClass,
    int? level,
    int? experience,
    int? experienceToNextLevel,
    CharacterStats? stats,
    CharacterLocation? location,
    CharacterAppearance? appearance,
    List<String>? skills,
    Map<String, dynamic>? equipment,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isOnline,
    String? currentActivity,
    int? prestigeLevel,
    String? guild,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNextLevel:
          experienceToNextLevel ?? this.experienceToNextLevel,
      stats: stats ?? this.stats,
      location: location ?? this.location,
      appearance: appearance ?? this.appearance,
      skills: skills ?? this.skills,
      equipment: equipment ?? this.equipment,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      currentActivity: currentActivity ?? this.currentActivity,
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      guild: guild ?? this.guild,
    );
  }

  // Helper methods
  String? get classDisplayName {
    switch (characterClass?.toLowerCase()) {
      case 'warrior':
        return 'Savaşçı';
      case 'mage':
        return 'Büyücü';
      case 'archer':
        return 'Okçu';
      case 'rogue':
        return 'Hırsız';
      case 'paladin':
        return 'Paladin';
      case 'necromancer':
        return 'Ölüçağıran';
      default:
        return characterClass;
    }
  }

  String get classEmoji {
    switch (characterClass?.toLowerCase()) {
      case 'warrior':
        return '⚔️';
      case 'mage':
        return '🔮';
      case 'archer':
        return '🏹';
      case 'rogue':
        return '🗡️';
      case 'paladin':
        return '🛡️';
      case 'necromancer':
        return '💀';
      default:
        return '🎮';
    }
  }

  double get experienceProgress {
    if (experience == null || experienceToNextLevel == null) return 0.0;
    if (experienceToNextLevel! <= 0) return 1.0;
    return (experience! / experienceToNextLevel!).clamp(0.0, 1.0);
  }

  int get totalAchievements => achievements?.length ?? 0;
  int get totalSkills => skills?.length ?? 0;

  bool get hasPrestige => (prestigeLevel ?? 0) > 0;
  bool get hasGuild => guild != null && guild!.isNotEmpty;

  String get statusEmoji {
    if (isOnline == true) {
      switch (currentActivity?.toLowerCase()) {
        case 'combat':
          return '⚔️';
        case 'exploring':
          return '🗺️';
        case 'trading':
          return '💰';
        case 'crafting':
          return '🔨';
        default:
          return '🟢';
      }
    }
    return '🔴';
  }

  Duration? get timeSinceLastActive {
    if (lastActive == null) return null;
    return DateTime.now().difference(lastActive!);
  }
}

@JsonSerializable(explicitToJson: true)
class CharacterStats extends INetworkModel<CharacterStats> {
  final HealthStat? health;
  final ManaStat? mana;
  final EnergyStat? energy;
  final int? attack;
  final int? defense;
  final int? speed;
  final int? intelligence;
  final int? luck;
  final double? criticalChance;
  final double? accuracy;
  final double? dodgeChance;
  final int? totalCombats;
  final int? victories;
  final int? defeats;

  const CharacterStats({
    this.health,
    this.mana,
    this.energy,
    this.attack,
    this.defense,
    this.speed,
    this.intelligence,
    this.luck,
    this.criticalChance,
    this.accuracy,
    this.dodgeChance,
    this.totalCombats,
    this.victories,
    this.defeats,
  });

  factory CharacterStats.fromJson(Map<String, dynamic> json) =>
      _$CharacterStatsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterStatsToJson(this);

  @override
  CharacterStats fromJson(Map<String, dynamic> json) =>
      _$CharacterStatsFromJson(json);

  CharacterStats copyWith({
    HealthStat? health,
    ManaStat? mana,
    EnergyStat? energy,
    int? attack,
    int? defense,
    int? speed,
    int? intelligence,
    int? luck,
    double? criticalChance,
    double? accuracy,
    double? dodgeChance,
    int? totalCombats,
    int? victories,
    int? defeats,
  }) {
    return CharacterStats(
      health: health ?? this.health,
      mana: mana ?? this.mana,
      energy: energy ?? this.energy,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      intelligence: intelligence ?? this.intelligence,
      luck: luck ?? this.luck,
      criticalChance: criticalChance ?? this.criticalChance,
      accuracy: accuracy ?? this.accuracy,
      dodgeChance: dodgeChance ?? this.dodgeChance,
      totalCombats: totalCombats ?? this.totalCombats,
      victories: victories ?? this.victories,
      defeats: defeats ?? this.defeats,
    );
  }

  // Helper methods
  double get winRate {
    if (totalCombats == null || totalCombats! <= 0) return 0.0;
    return (victories ?? 0) / totalCombats!;
  }

  int get powerLevel {
    return (attack ?? 0) +
        (defense ?? 0) +
        (speed ?? 0) +
        (intelligence ?? 0) +
        (luck ?? 0);
  }

  bool get isHealthy =>
      health?.current != null && health!.current > health!.max * 0.25;
  bool get hasMana => mana?.current != null && mana!.current > 0;
  bool get hasEnergy => energy?.current != null && energy!.current > 0;
}

@JsonSerializable(explicitToJson: true)
class HealthStat extends INetworkModel<HealthStat> {
  final int current;
  final int max;
  final int regeneration;

  const HealthStat({
    required this.current,
    required this.max,
    this.regeneration = 0,
  });

  factory HealthStat.fromJson(Map<String, dynamic> json) =>
      _$HealthStatFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HealthStatToJson(this);

  @override
  HealthStat fromJson(Map<String, dynamic> json) => _$HealthStatFromJson(json);

  HealthStat copyWith({int? current, int? max, int? regeneration}) {
    return HealthStat(
      current: current ?? this.current,
      max: max ?? this.max,
      regeneration: regeneration ?? this.regeneration,
    );
  }

  double get percentage => max > 0 ? current / max : 0.0;
  bool get isFull => current >= max;
  bool get isLow => percentage < 0.25;
  bool get isCritical => percentage < 0.1;
}

@JsonSerializable(explicitToJson: true)
class ManaStat extends INetworkModel<ManaStat> {
  final int current;
  final int max;
  final int regeneration;

  const ManaStat({
    required this.current,
    required this.max,
    this.regeneration = 0,
  });

  factory ManaStat.fromJson(Map<String, dynamic> json) =>
      _$ManaStatFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ManaStatToJson(this);

  @override
  ManaStat fromJson(Map<String, dynamic> json) => _$ManaStatFromJson(json);

  ManaStat copyWith({int? current, int? max, int? regeneration}) {
    return ManaStat(
      current: current ?? this.current,
      max: max ?? this.max,
      regeneration: regeneration ?? this.regeneration,
    );
  }

  double get percentage => max > 0 ? current / max : 0.0;
  bool get isFull => current >= max;
  bool get isLow => percentage < 0.25;
}

@JsonSerializable(explicitToJson: true)
class EnergyStat extends INetworkModel<EnergyStat> {
  final int current;
  final int max;
  final int regeneration;

  const EnergyStat({
    required this.current,
    required this.max,
    this.regeneration = 0,
  });

  factory EnergyStat.fromJson(Map<String, dynamic> json) =>
      _$EnergyStatFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EnergyStatToJson(this);

  @override
  EnergyStat fromJson(Map<String, dynamic> json) => _$EnergyStatFromJson(json);

  EnergyStat copyWith({int? current, int? max, int? regeneration}) {
    return EnergyStat(
      current: current ?? this.current,
      max: max ?? this.max,
      regeneration: regeneration ?? this.regeneration,
    );
  }

  double get percentage => max > 0 ? current / max : 0.0;
  bool get isFull => current >= max;
  bool get isLow => percentage < 0.25;
}

@JsonSerializable(explicitToJson: true)
class CharacterLocation extends INetworkModel<CharacterLocation> {
  final double latitude;
  final double longitude;
  final double? altitude;
  final String? region;
  final String? biome;
  final DateTime? lastUpdate;

  const CharacterLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.region,
    this.biome,
    this.lastUpdate,
  });

  factory CharacterLocation.fromJson(Map<String, dynamic> json) =>
      _$CharacterLocationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterLocationToJson(this);

  @override
  CharacterLocation fromJson(Map<String, dynamic> json) =>
      _$CharacterLocationFromJson(json);

  CharacterLocation copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    String? region,
    String? biome,
    DateTime? lastUpdate,
  }) {
    return CharacterLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      region: region ?? this.region,
      biome: biome ?? this.biome,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  String get biomeEmoji {
    switch (biome?.toLowerCase()) {
      case 'forest':
        return '🌲';
      case 'urban':
        return '🏙️';
      case 'desert':
        return '🏜️';
      case 'mountain':
        return '🏔️';
      case 'water':
        return '🌊';
      case 'ice':
        return '❄️';
      default:
        return '🌍';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class CharacterAppearance extends INetworkModel<CharacterAppearance> {
  final String? gender;
  final String? skinColor;
  final String? hairColor;
  final String? hairStyle;
  final String? eyeColor;
  final String? faceStyle;
  final Map<String, String>? customization;

  const CharacterAppearance({
    this.gender,
    this.skinColor,
    this.hairColor,
    this.hairStyle,
    this.eyeColor,
    this.faceStyle,
    this.customization,
  });

  factory CharacterAppearance.fromJson(Map<String, dynamic> json) =>
      _$CharacterAppearanceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterAppearanceToJson(this);

  @override
  CharacterAppearance fromJson(Map<String, dynamic> json) =>
      _$CharacterAppearanceFromJson(json);

  CharacterAppearance copyWith({
    String? gender,
    String? skinColor,
    String? hairColor,
    String? hairStyle,
    String? eyeColor,
    String? faceStyle,
    Map<String, String>? customization,
  }) {
    return CharacterAppearance(
      gender: gender ?? this.gender,
      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      hairStyle: hairStyle ?? this.hairStyle,
      eyeColor: eyeColor ?? this.eyeColor,
      faceStyle: faceStyle ?? this.faceStyle,
      customization: customization ?? this.customization,
    );
  }

  String get genderEmoji {
    switch (gender?.toLowerCase()) {
      case 'male':
        return '♂️';
      case 'female':
        return '♀️';
      default:
        return '👤';
    }
  }
}
