// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestResult _$HarvestResultFromJson(Map<String, dynamic> json) =>
    HarvestResult(
      type: json['type'] as String?,
      quality: json['quality'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      experienceGained: (json['experienceGained'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HarvestResultToJson(HarvestResult instance) =>
    <String, dynamic>{
      'type': instance.type,
      'quality': instance.quality,
      'quantity': instance.quantity,
      'experienceGained': instance.experienceGained,
    };
