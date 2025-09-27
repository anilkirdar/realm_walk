// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'nearby_character_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NearbyCharacter extends INetworkModel<NearbyCharacter> {
  final String id;
  final String name;
  final String? characterClass;
  final int level;
  final double latitude;
  final double longitude;
  final double distance;
  final bool isOnline;
  final String? currentActivity;
  final DateTime lastSeen;
  final String? guild;
  final int? prestigeLevel;
  final bool? isFriend;
  final String? avatarUrl;
  final Map<String, dynamic>? publicStats;

  const NearbyCharacter({
    required this.id,
    required this.name,
    this.characterClass,
    required this.level,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.isOnline,
    this.currentActivity,
    required this.lastSeen,
    this.guild,
    this.prestigeLevel,
    this.isFriend,
    this.avatarUrl,
    this.publicStats,
  });

  factory NearbyCharacter.fromJson(Map<String, dynamic> json) =>
      _$NearbyCharacterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NearbyCharacterToJson(this);

  @override
  NearbyCharacter fromJson(Map<String, dynamic> json) =>
      _$NearbyCharacterFromJson(json);

  NearbyCharacter copyWith({
    String? id,
    String? name,
    String? characterClass,
    int? level,
    double? latitude,
    double? longitude,
    double? distance,
    bool? isOnline,
    String? currentActivity,
    DateTime? lastSeen,
    String? guild,
    int? prestigeLevel,
    bool? isFriend,
    String? avatarUrl,
    Map<String, dynamic>? publicStats,
  }) {
    return NearbyCharacter(
      id: id ?? this.id,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      level: level ?? this.level,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      isOnline: isOnline ?? this.isOnline,
      currentActivity: currentActivity ?? this.currentActivity,
      lastSeen: lastSeen ?? this.lastSeen,
      guild: guild ?? this.guild,
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      isFriend: isFriend ?? this.isFriend,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      publicStats: publicStats ?? this.publicStats,
    );
  }

  // Helper methods
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

  String get statusEmoji {
    if (isOnline) {
      switch (currentActivity?.toLowerCase()) {
        case 'combat':
          return '⚔️';
        case 'exploring':
          return '🗺️';
        case 'trading':
          return '💰';
        case 'crafting':
          return '🔨';
        case 'idle':
          return '😴';
        default:
          return '🟢';
      }
    }
    return '🔴';
  }

  String get friendStatusEmoji {
    if (isFriend == true) return '👥';
    return '👤';
  }

  String get prestigeEmoji {
    if (prestigeLevel == null || prestigeLevel! <= 0) return '';
    return '⭐' * (prestigeLevel! > 5 ? 5 : prestigeLevel!);
  }

  String get distanceText {
    if (distance < 1) {
      return '${(distance * 1000).round()}m';
    } else if (distance < 10) {
      return '${distance.toStringAsFixed(1)}km';
    } else {
      return '${distance.round()}km';
    }
  }

  Duration get timeSinceLastSeen => DateTime.now().difference(lastSeen);

  String get lastSeenText {
    final duration = timeSinceLastSeen;

    if (isOnline) return 'Şu anda aktif';

    if (duration.inMinutes < 1) {
      return 'Az önce';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes} dakika önce';
    } else if (duration.inDays < 1) {
      return '${duration.inHours} saat önce';
    } else if (duration.inDays < 7) {
      return '${duration.inDays} gün önce';
    } else {
      return '${(duration.inDays / 7).floor()} hafta önce';
    }
  }

  bool get isVeryClose => distance < 0.1; // 100m'den yakın
  bool get isClose => distance < 0.5; // 500m'den yakın
  bool get isNearby => distance < 2.0; // 2km'den yakın

  bool get hasGuild => guild != null && guild!.isNotEmpty;
  bool get hasPrestige => prestigeLevel != null && prestigeLevel! > 0;

  // Combat-related helpers
  int? get totalCombats => publicStats?['totalCombats'] as int?;
  int? get victories => publicStats?['victories'] as int?;
  double? get winRate {
    final total = totalCombats;
    final wins = victories;
    if (total == null || total <= 0 || wins == null) return null;
    return wins / total;
  }

  String? get winRateText {
    final rate = winRate;
    if (rate == null) return null;
    return '${(rate * 100).toStringAsFixed(1)}%';
  }

  bool get isFormidableOpponent {
    final rate = winRate;
    return level >= 10 && rate != null && rate > 0.7;
  }
}

@JsonSerializable(explicitToJson: true)
class CharacterUpdateResponse extends INetworkModel<CharacterUpdateResponse> {
  final bool success;
  final String? message;
  final List<NearbyCharacter>? nearbyCharacters;
  final String? currentBiome;
  final Map<String, dynamic>? locationInfo;
  final DateTime timestamp;

  const CharacterUpdateResponse({
    required this.success,
    this.message,
    this.nearbyCharacters,
    this.currentBiome,
    this.locationInfo,
    required this.timestamp,
  });

  factory CharacterUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterUpdateResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterUpdateResponseToJson(this);

  @override
  CharacterUpdateResponse fromJson(Map<String, dynamic> json) =>
      _$CharacterUpdateResponseFromJson(json);

  CharacterUpdateResponse copyWith({
    bool? success,
    String? message,
    List<NearbyCharacter>? nearbyCharacters,
    String? currentBiome,
    Map<String, dynamic>? locationInfo,
    DateTime? timestamp,
  }) {
    return CharacterUpdateResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      nearbyCharacters: nearbyCharacters ?? this.nearbyCharacters,
      currentBiome: currentBiome ?? this.currentBiome,
      locationInfo: locationInfo ?? this.locationInfo,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper methods
  int get nearbyCharacterCount => nearbyCharacters?.length ?? 0;
  bool get hasNearbyCharacters => nearbyCharacterCount > 0;

  List<NearbyCharacter> get onlineCharacters =>
      nearbyCharacters?.where((char) => char.isOnline).toList() ?? [];

  List<NearbyCharacter> get friends =>
      nearbyCharacters?.where((char) => char.isFriend == true).toList() ?? [];

  List<NearbyCharacter> get closeCharacters =>
      nearbyCharacters?.where((char) => char.isClose).toList() ?? [];

  String get biomeEmoji {
    switch (currentBiome?.toLowerCase()) {
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
