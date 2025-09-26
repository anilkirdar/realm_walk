// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spawn_monster_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpawnMonsterResponse _$SpawnMonsterResponseFromJson(
  Map<String, dynamic> json,
) => SpawnMonsterResponse(
  success: json['success'] as bool? ?? false,
  message: json['message'] as String?,
  monster: json['monster'] == null
      ? null
      : ARMonster.fromJson(json['monster'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SpawnMonsterResponseToJson(
  SpawnMonsterResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'monster': instance.monster?.toJson(),
};
