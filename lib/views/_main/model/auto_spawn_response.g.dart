// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_spawn_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutoSpawnResponse _$AutoSpawnResponseFromJson(Map<String, dynamic> json) =>
    AutoSpawnResponse(
      success: json['success'] as bool?,
      spawned: (json['spawned'] as num?)?.toInt(),
      location: json['location'] == null
          ? null
          : AutoSpawnLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AutoSpawnResponseToJson(AutoSpawnResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'spawned': instance.spawned,
      'location': instance.location,
    };

AutoSpawnLocation _$AutoSpawnLocationFromJson(Map<String, dynamic> json) =>
    AutoSpawnLocation(biome: json['biome'] as String?);

Map<String, dynamic> _$AutoSpawnLocationToJson(AutoSpawnLocation instance) =>
    <String, dynamic>{'biome': instance.biome};
