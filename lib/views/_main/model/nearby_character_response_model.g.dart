// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_character_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyCharacterResponseModel _$NearbyCharacterResponseModelFromJson(
  Map<String, dynamic> json,
) => NearbyCharacterResponseModel(
  nearbyCharacters: (json['nearbyCharacters'] as List<dynamic>?)
      ?.map((e) => NearbyCharacter.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NearbyCharacterResponseModelToJson(
  NearbyCharacterResponseModel instance,
) => <String, dynamic>{'nearbyCharacters': instance.nearbyCharacters};
