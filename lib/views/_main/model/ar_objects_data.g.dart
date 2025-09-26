// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_objects_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ARObjectsData _$ARObjectsDataFromJson(Map<String, dynamic> json) =>
    ARObjectsData(
      monsters:
          (json['monsters'] as List<dynamic>?)
              ?.map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      resources:
          (json['resources'] as List<dynamic>?)
              ?.map((e) => ARResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      personalMonsters:
          (json['personalMonsters'] as List<dynamic>?)
              ?.map((e) => ARMonster.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ARObjectsDataToJson(
  ARObjectsData instance,
) => <String, dynamic>{
  'monsters': instance.monsters.map((e) => e.toJson()).toList(),
  'resources': instance.resources.map((e) => e.toJson()).toList(),
  'personalMonsters': instance.personalMonsters.map((e) => e.toJson()).toList(),
};
