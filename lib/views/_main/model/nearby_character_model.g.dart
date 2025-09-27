// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyCharacter _$NearbyCharacterFromJson(Map<String, dynamic> json) =>
    NearbyCharacter(
      id: json['id'] as String,
      name: json['name'] as String,
      characterClass: json['characterClass'] as String?,
      level: (json['level'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      isOnline: json['isOnline'] as bool,
      currentActivity: json['currentActivity'] as String?,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      guild: json['guild'] as String?,
      prestigeLevel: (json['prestigeLevel'] as num?)?.toInt(),
      isFriend: json['isFriend'] as bool?,
      avatarUrl: json['avatarUrl'] as String?,
      publicStats: json['publicStats'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NearbyCharacterToJson(NearbyCharacter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'characterClass': instance.characterClass,
      'level': instance.level,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'isOnline': instance.isOnline,
      'currentActivity': instance.currentActivity,
      'lastSeen': instance.lastSeen.toIso8601String(),
      'guild': instance.guild,
      'prestigeLevel': instance.prestigeLevel,
      'isFriend': instance.isFriend,
      'avatarUrl': instance.avatarUrl,
      'publicStats': instance.publicStats,
    };

CharacterUpdateResponse _$CharacterUpdateResponseFromJson(
  Map<String, dynamic> json,
) => CharacterUpdateResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  nearbyCharacters: (json['nearbyCharacters'] as List<dynamic>?)
      ?.map((e) => NearbyCharacter.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentBiome: json['currentBiome'] as String?,
  locationInfo: json['locationInfo'] as Map<String, dynamic>?,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$CharacterUpdateResponseToJson(
  CharacterUpdateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'nearbyCharacters': instance.nearbyCharacters
      ?.map((e) => e.toJson())
      .toList(),
  'currentBiome': instance.currentBiome,
  'locationInfo': instance.locationInfo,
  'timestamp': instance.timestamp.toIso8601String(),
};
