// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'harvest_result.g.dart';

@JsonSerializable(explicitToJson: true)
class HarvestResult extends INetworkModel<HarvestResult> {
  final bool success;
  final String? message;
  final List<HarvestedItem> items;
  final int experience;
  final double duration;
  final String? resourceId;
  final String? resourceType;
  final int? bonusItems;
  final double? qualityBonus;
  final List<String>? achievements;
  final Map<String, dynamic>? statistics;

  const HarvestResult({
    required this.success,
    this.message,
    required this.items,
    this.experience = 0,
    this.duration = 0.0,
    this.resourceId,
    this.resourceType,
    this.bonusItems,
    this.qualityBonus,
    this.achievements,
    this.statistics,
  });

  factory HarvestResult.fromJson(Map<String, dynamic> json) =>
      _$HarvestResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HarvestResultToJson(this);

  @override
  HarvestResult fromJson(Map<String, dynamic> json) =>
      _$HarvestResultFromJson(json);

  HarvestResult copyWith({
    bool? success,
    String? message,
    List<HarvestedItem>? items,
    int? experience,
    double? duration,
    String? resourceId,
    String? resourceType,
    int? bonusItems,
    double? qualityBonus,
    List<String>? achievements,
    Map<String, dynamic>? statistics,
  }) {
    return HarvestResult(
      success: success ?? this.success,
      message: message ?? this.message,
      items: items ?? this.items,
      experience: experience ?? this.experience,
      duration: duration ?? this.duration,
      resourceId: resourceId ?? this.resourceId,
      resourceType: resourceType ?? this.resourceType,
      bonusItems: bonusItems ?? this.bonusItems,
      qualityBonus: qualityBonus ?? this.qualityBonus,
      achievements: achievements ?? this.achievements,
      statistics: statistics ?? this.statistics,
    );
  }

  // Helper methods
  bool get hasItems => items.isNotEmpty;
  bool get hasExperience => experience > 0;
  bool get hasBonusItems => bonusItems != null && bonusItems! > 0;
  bool get hasQualityBonus => qualityBonus != null && qualityBonus! > 0;
  bool get hasAchievements => achievements != null && achievements!.isNotEmpty;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  List<HarvestedItem> get rareItems =>
      items.where((item) => item.isRare).toList();

  List<HarvestedItem> get commonItems =>
      items.where((item) => item.isCommon).toList();

  String get resultEmoji => success ? '✅' : '❌';

  String get resourceTypeEmoji {
    switch (resourceType?.toLowerCase()) {
      case 'herb':
        return '🌿';
      case 'ore':
        return '⛏️';
      case 'wood':
        return '🪵';
      case 'gem':
        return '💎';
      case 'crystal':
        return '💠';
      case 'rune':
        return '🔮';
      case 'fish':
        return '🐟';
      case 'treasure':
        return '💰';
      default:
        return '📦';
    }
  }

  Duration get harvestDuration =>
      Duration(milliseconds: (duration * 1000).round());

  String get durationText {
    final dur = harvestDuration;
    if (dur.inMinutes > 0) {
      return '${dur.inMinutes}m ${dur.inSeconds % 60}s';
    } else {
      return '${dur.inSeconds}s';
    }
  }

  double get itemsPerSecond => duration > 0 ? totalItemCount / duration : 0.0;
  double get experiencePerSecond => duration > 0 ? experience / duration : 0.0;

  Map<String, int> get itemsByType {
    final Map<String, int> typeCount = {};
    for (final item in items) {
      final type = item.type ?? 'unknown';
      typeCount[type] = (typeCount[type] ?? 0) + item.quantity;
    }
    return typeCount;
  }

  Map<String, int> get itemsByRarity {
    final Map<String, int> rarityCount = {};
    for (final item in items) {
      final rarity = item.rarity ?? 'common';
      rarityCount[rarity] = (rarityCount[rarity] ?? 0) + item.quantity;
    }
    return rarityCount;
  }

  String get summaryText {
    if (!success) return message ?? 'Harvest failed';

    List<String> parts = [];

    if (hasItems) {
      parts.add('$totalItemCount item');
    }

    if (hasExperience) {
      parts.add('$experience XP');
    }

    if (hasBonusItems) {
      parts.add('+$bonusItems bonus');
    }

    if (hasQualityBonus) {
      parts.add('+${(qualityBonus! * 100).round()}% kalite');
    }

    return parts.join(', ');
  }
}

@JsonSerializable(explicitToJson: true)
class HarvestedItem extends INetworkModel<HarvestedItem> {
  final String itemId;
  final String name;
  final String? type;
  final String? rarity;
  final int quantity;
  final double? quality;
  final String? description;
  final String? imageUrl;
  final int? value;
  final Map<String, dynamic>? properties;
  final bool? isStackable;

  const HarvestedItem({
    required this.itemId,
    required this.name,
    this.type,
    this.rarity,
    required this.quantity,
    this.quality,
    this.description,
    this.imageUrl,
    this.value,
    this.properties,
    this.isStackable,
  });

  factory HarvestedItem.fromJson(Map<String, dynamic> json) =>
      _$HarvestedItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HarvestedItemToJson(this);

  @override
  HarvestedItem fromJson(Map<String, dynamic> json) =>
      _$HarvestedItemFromJson(json);

  HarvestedItem copyWith({
    String? itemId,
    String? name,
    String? type,
    String? rarity,
    int? quantity,
    double? quality,
    String? description,
    String? imageUrl,
    int? value,
    Map<String, dynamic>? properties,
    bool? isStackable,
  }) {
    return HarvestedItem(
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      quantity: quantity ?? this.quantity,
      quality: quality ?? this.quality,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      value: value ?? this.value,
      properties: properties ?? this.properties,
      isStackable: isStackable ?? this.isStackable,
    );
  }

  // Helper methods
  bool get isCommon => rarity?.toLowerCase() == 'common';
  bool get isUncommon => rarity?.toLowerCase() == 'uncommon';
  bool get isRare => rarity?.toLowerCase() == 'rare';
  bool get isEpic => rarity?.toLowerCase() == 'epic';
  bool get isLegendary => rarity?.toLowerCase() == 'legendary';

  String get rarityEmoji {
    switch (rarity?.toLowerCase()) {
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
    switch (type?.toLowerCase()) {
      case 'herb':
        return '🌿';
      case 'ore':
        return '⛏️';
      case 'wood':
        return '🪵';
      case 'gem':
        return '💎';
      case 'crystal':
        return '💠';
      case 'rune':
        return '🔮';
      case 'essence':
        return '✨';
      case 'potion':
        return '🧪';
      case 'scroll':
        return '📜';
      case 'tool':
        return '🔨';
      default:
        return '📦';
    }
  }

  String get qualityText {
    if (quality == null) return '';

    if (quality! >= 0.9) return 'Mükemmel';
    if (quality! >= 0.8) return 'Yüksek';
    if (quality! >= 0.6) return 'İyi';
    if (quality! >= 0.4) return 'Orta';
    if (quality! >= 0.2) return 'Düşük';
    return 'Kötü';
  }

  String get qualityEmoji {
    if (quality == null) return '';

    if (quality! >= 0.9) return '⭐⭐⭐';
    if (quality! >= 0.8) return '⭐⭐';
    if (quality! >= 0.6) return '⭐';
    return '';
  }

  int get totalValue => (value ?? 0) * quantity;

  bool get hasHighQuality => quality != null && quality! >= 0.8;
  bool get canStack => isStackable ?? true;

  String get displayName {
    String display = name;

    if (quantity > 1) {
      display = '${quantity}x $display';
    }

    if (quality != null && quality! > 0) {
      display += ' $qualityEmoji';
    }

    return display;
  }

  String get fullDescription {
    List<String> parts = [displayName];

    if (description != null && description!.isNotEmpty) {
      parts.add(description!);
    }

    if (quality != null) {
      parts.add('Kalite: $qualityText');
    }

    if (value != null && value! > 0) {
      parts.add('Değer: $totalValue altın');
    }

    return parts.join('\n');
  }
}
