// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'loot_item.g.dart';

@JsonSerializable()
class LootItem {
  final String itemId;
  final int quantity;

  LootItem({required this.itemId, required this.quantity});

  factory LootItem.fromJson(Map<String, dynamic> json) =>
      _$LootItemFromJson(json);

  Map<String, dynamic> toJson() => _$LootItemToJson(this);
}
