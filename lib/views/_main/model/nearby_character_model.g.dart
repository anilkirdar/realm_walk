// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyCharacter _$NearbyCharacterFromJson(Map<String, dynamic> json) =>
    NearbyCharacter(
      id: json['id'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      characterClass: json['characterClass'] as String?,
      level: (json['level'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      location: json['location'] == null
          ? null
          : CharacterLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$NearbyCharacterToJson(NearbyCharacter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'characterClass': instance.characterClass,
      'level': instance.level,
      'distance': instance.distance,
      'location': instance.location,
    };
