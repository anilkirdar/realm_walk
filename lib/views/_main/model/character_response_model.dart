import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';
import 'character_model.dart';

part 'character_response_model.g.dart';

@JsonSerializable()
class CharacterResponseModel extends INetworkModel<CharacterResponseModel> {
  final CharacterModel? character;

  const CharacterResponseModel({this.character});

  @override
  CharacterResponseModel fromJson(Map<String, dynamic> json) =>
      _$CharacterResponseModelFromJson(json);

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterResponseModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CharacterResponseModelToJson(this);

  CharacterResponseModel copyWith({CharacterModel? character}) {
    return CharacterResponseModel(character: character ?? this.character);
  }
}
