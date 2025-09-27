// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestResult _$HarvestResultFromJson(Map<String, dynamic> json) =>
    HarvestResult(
      success: json['success'] as bool,
      message: json['message'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => HarvestedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      resourceId: json['resourceId'] as String?,
      resourceType: json['resourceType'] as String?,
      bonusItems: (json['bonusItems'] as num?)?.toInt(),
      qualityBonus: (json['qualityBonus'] as num?)?.toDouble(),
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      statistics: json['statistics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HarvestResultToJson(HarvestResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'experience': instance.experience,
      'duration': instance.duration,
      'resourceId': instance.resourceId,
      'resourceType': instance.resourceType,
      'bonusItems': instance.bonusItems,
      'qualityBonus': instance.qualityBonus,
      'achievements': instance.achievements,
      'statistics': instance.statistics,
    };

HarvestedItem _$HarvestedItemFromJson(Map<String, dynamic> json) =>
    HarvestedItem(
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      rarity: json['rarity'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      quality: (json['quality'] as num?)?.toDouble(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      value: (json['value'] as num?)?.toInt(),
      properties: json['properties'] as Map<String, dynamic>?,
      isStackable: json['isStackable'] as bool?,
    );

Map<String, dynamic> _$HarvestedItemToJson(HarvestedItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'name': instance.name,
      'type': instance.type,
      'rarity': instance.rarity,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'value': instance.value,
      'properties': instance.properties,
      'isStackable': instance.isStackable,
    };
