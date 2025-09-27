// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'combat_rewards.g.dart';

@JsonSerializable(explicitToJson: true)
class CombatRewards extends INetworkModel<CombatRewards> {
  final int experience;
  final int gold;
  final List<LootItem>? loot;
  final bool? leveledUp;
  final int? newLevel;
  final List<String>? unlockedSkills;
  final List<Achievement>? achievements;
  final int? bonusExperience;
  final int? bonusGold;
  final String? performanceGrade;
  final Map<String, dynamic>? statistics;

  const CombatRewards({
    required this.experience,
    required this.gold,
    this.loot,
    this.leveledUp,
    this.newLevel,
    this.unlockedSkills,
    this.achievements,
    this.bonusExperience,
    this.bonusGold,
    this.performanceGrade,
    this.statistics,
  });

  factory CombatRewards.fromJson(Map<String, dynamic> json) =>
      _$CombatRewardsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatRewardsToJson(this);

  @override
  CombatRewards fromJson(Map<String, dynamic> json) =>
      _$CombatRewardsFromJson(json);

  CombatRewards copyWith({
    int? experience,
    int? gold,
    List<LootItem>? loot,
    bool? leveledUp,
    int? newLevel,
    List<String>? unlockedSkills,
    List<Achievement>? achievements,
    int? bonusExperience,
    int? bonusGold,
    String? performanceGrade,
    Map<String, dynamic>? statistics,
  }) {
    return CombatRewards(
      experience: experience ?? this.experience,
      gold: gold ?? this.gold,
      loot: loot ?? this.loot,
      leveledUp: leveledUp ?? this.leveledUp,
      newLevel: newLevel ?? this.newLevel,
      unlockedSkills: unlockedSkills ?? this.unlockedSkills,
      achievements: achievements ?? this.achievements,
      bonusExperience: bonusExperience ?? this.bonusExperience,
      bonusGold: bonusGold ?? this.bonusGold,
      performanceGrade: performanceGrade ?? this.performanceGrade,
      statistics: statistics ?? this.statistics,
    );
  }

  // Helper methods
  int get totalExperience => experience + (bonusExperience ?? 0);
  int get totalGold => gold + (bonusGold ?? 0);
  bool get hasLoot => loot != null && loot!.isNotEmpty;
  bool get hasAchievements => achievements != null && achievements!.isNotEmpty;
  bool get hasUnlockedSkills =>
      unlockedSkills != null && unlockedSkills!.isNotEmpty;

  List<LootItem> get rareLoot =>
      loot?.where((item) => item.isRare).toList() ?? [];

  List<LootItem> get epicLoot =>
      loot?.where((item) => item.isEpic).toList() ?? [];

  List<LootItem> get legendaryLoot =>
      loot?.where((item) => item.isLegendary).toList() ?? [];

  String get gradeEmoji {
    switch (performanceGrade?.toUpperCase()) {
      case 'S':
        return '🏆';
      case 'A':
        return '🥇';
      case 'B':
        return '🥈';
      case 'C':
        return '🥉';
      case 'D':
        return '📜';
      default:
        return '⭐';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class LootItem extends INetworkModel<LootItem> {
  final String itemId;
  final String name;
  final String type;
  final String rarity;
  final int quantity;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? properties;
  final int? value;

  const LootItem({
    required this.itemId,
    required this.name,
    required this.type,
    required this.rarity,
    required this.quantity,
    this.description,
    this.imageUrl,
    this.properties,
    this.value,
  });

  factory LootItem.fromJson(Map<String, dynamic> json) =>
      _$LootItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LootItemToJson(this);

  @override
  LootItem fromJson(Map<String, dynamic> json) => _$LootItemFromJson(json);

  LootItem copyWith({
    String? itemId,
    String? name,
    String? type,
    String? rarity,
    int? quantity,
    String? description,
    String? imageUrl,
    Map<String, dynamic>? properties,
    int? value,
  }) {
    return LootItem(
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      properties: properties ?? this.properties,
      value: value ?? this.value,
    );
  }

  // Helper methods
  bool get isCommon => rarity.toLowerCase() == 'common';
  bool get isUncommon => rarity.toLowerCase() == 'uncommon';
  bool get isRare => rarity.toLowerCase() == 'rare';
  bool get isEpic => rarity.toLowerCase() == 'epic';
  bool get isLegendary => rarity.toLowerCase() == 'legendary';
  bool get isMythic => rarity.toLowerCase() == 'mythic';

  String get rarityEmoji {
    switch (rarity.toLowerCase()) {
      case 'common':
        return '⚪';
      case 'uncommon':
        return '🟢';
      case 'rare':
        return '🔵';
      case 'epic':
        return '🟣';
      case 'legendary':
        return '🟡';
      case 'mythic':
        return '🔴';
      default:
        return '⚪';
    }
  }

  String get typeEmoji {
    switch (type.toLowerCase()) {
      case 'weapon':
        return '⚔️';
      case 'armor':
        return '🛡️';
      case 'accessory':
        return '💍';
      case 'consumable':
        return '🧪';
      case 'material':
        return '🔨';
      case 'gem':
        return '💎';
      case 'coin':
        return '🪙';
      default:
        return '📦';
    }
  }

  int get totalValue => (value ?? 0) * quantity;
}

@JsonSerializable(explicitToJson: true)
class Achievement extends INetworkModel<Achievement> {
  final String id;
  final String name;
  final String description;
  final String type;
  final String? iconUrl;
  final int points;
  final DateTime unlockedAt;
  final bool isRare;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.iconUrl,
    required this.points,
    required this.unlockedAt,
    this.isRare = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  @override
  Achievement fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? iconUrl,
    int? points,
    DateTime? unlockedAt,
    bool? isRare,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      points: points ?? this.points,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isRare: isRare ?? this.isRare,
    );
  }

  // Helper methods
  String get typeEmoji {
    switch (type.toLowerCase()) {
      case 'combat':
        return '⚔️';
      case 'exploration':
        return '🗺️';
      case 'collection':
        return '📚';
      case 'social':
        return '👥';
      case 'progression':
        return '📈';
      case 'special':
        return '⭐';
      default:
        return '🏆';
    }
  }

  String get rarityEmoji => isRare ? '🌟' : '🏆';
}
