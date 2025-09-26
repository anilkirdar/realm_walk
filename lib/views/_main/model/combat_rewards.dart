// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'loot_item.dart';

part 'combat_rewards.g.dart';

@JsonSerializable(explicitToJson: true)
class CombatRewards extends INetworkModel<CombatRewards> {
  final int? experience;
  final bool leveledUp;
  final int? newLevel;
  final List<LootItem> loot;
  final Map<String, dynamic>? character;

  const CombatRewards({
    this.experience,
    this.leveledUp = false,
    this.newLevel,
    this.loot = const [],
    this.character,
  });

  factory CombatRewards.fromJson(Map<String, dynamic> json) =>
      _$CombatRewardsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatRewardsToJson(this);

  @override
  CombatRewards fromJson(Map<String, dynamic> json) =>
      _$CombatRewardsFromJson(json);
}
