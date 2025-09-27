// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_rewards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatRewards _$CombatRewardsFromJson(Map<String, dynamic> json) =>
    CombatRewards(
      experience: (json['experience'] as num).toInt(),
      gold: (json['gold'] as num).toInt(),
      loot: (json['loot'] as List<dynamic>?)
          ?.map((e) => LootItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      leveledUp: json['leveledUp'] as bool?,
      newLevel: (json['newLevel'] as num?)?.toInt(),
      unlockedSkills: (json['unlockedSkills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      bonusExperience: (json['bonusExperience'] as num?)?.toInt(),
      bonusGold: (json['bonusGold'] as num?)?.toInt(),
      performanceGrade: json['performanceGrade'] as String?,
      statistics: json['statistics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CombatRewardsToJson(CombatRewards instance) =>
    <String, dynamic>{
      'experience': instance.experience,
      'gold': instance.gold,
      'loot': instance.loot?.map((e) => e.toJson()).toList(),
      'leveledUp': instance.leveledUp,
      'newLevel': instance.newLevel,
      'unlockedSkills': instance.unlockedSkills,
      'achievements': instance.achievements?.map((e) => e.toJson()).toList(),
      'bonusExperience': instance.bonusExperience,
      'bonusGold': instance.bonusGold,
      'performanceGrade': instance.performanceGrade,
      'statistics': instance.statistics,
    };

LootItem _$LootItemFromJson(Map<String, dynamic> json) => LootItem(
  itemId: json['itemId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  rarity: json['rarity'] as String,
  quantity: (json['quantity'] as num).toInt(),
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  properties: json['properties'] as Map<String, dynamic>?,
  value: (json['value'] as num?)?.toInt(),
);

Map<String, dynamic> _$LootItemToJson(LootItem instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'name': instance.name,
  'type': instance.type,
  'rarity': instance.rarity,
  'quantity': instance.quantity,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'properties': instance.properties,
  'value': instance.value,
};

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  iconUrl: json['iconUrl'] as String?,
  points: (json['points'] as num).toInt(),
  unlockedAt: DateTime.parse(json['unlockedAt'] as String),
  isRare: json['isRare'] as bool? ?? false,
);

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'iconUrl': instance.iconUrl,
      'points': instance.points,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'isRare': instance.isRare,
    };
