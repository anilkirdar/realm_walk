// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LootItem _$LootItemFromJson(Map<String, dynamic> json) => LootItem(
  itemId: json['itemId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$LootItemToJson(LootItem instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'quantity': instance.quantity,
};
