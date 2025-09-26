// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_rewards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatRewards _$CombatRewardsFromJson(Map<String, dynamic> json) =>
    CombatRewards(
      experience: (json['experience'] as num?)?.toInt(),
      leveledUp: json['leveledUp'] as bool? ?? false,
      newLevel: (json['newLevel'] as num?)?.toInt(),
      loot:
          (json['loot'] as List<dynamic>?)
              ?.map((e) => LootItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      character: json['character'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CombatRewardsToJson(CombatRewards instance) =>
    <String, dynamic>{
      'experience': instance.experience,
      'leveledUp': instance.leveledUp,
      'newLevel': instance.newLevel,
      'loot': instance.loot.map((e) => e.toJson()).toList(),
      'character': instance.character,
    };
