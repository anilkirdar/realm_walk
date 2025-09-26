// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterResponseModel _$CharacterResponseModelFromJson(
  Map<String, dynamic> json,
) => CharacterResponseModel(
  character: json['character'] == null
      ? null
      : CharacterModel.fromJson(json['character'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CharacterResponseModelToJson(
  CharacterResponseModel instance,
) => <String, dynamic>{'character': instance.character};
