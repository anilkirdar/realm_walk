import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';
import 'nearby_character_model.dart';

part 'nearby_character_response_model.g.dart';

@JsonSerializable()
class NearbyCharacterResponseModel
    extends INetworkModel<NearbyCharacterResponseModel> {
  final List<NearbyCharacter>? nearbyCharacters;

  const NearbyCharacterResponseModel({this.nearbyCharacters});

  @override
  NearbyCharacterResponseModel fromJson(Map<String, dynamic> json) =>
      _$NearbyCharacterResponseModelFromJson(json);

  factory NearbyCharacterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NearbyCharacterResponseModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$NearbyCharacterResponseModelToJson(this);

  NearbyCharacterResponseModel copyWith({
    List<NearbyCharacter>? nearbyCharacters,
  }) {
    return NearbyCharacterResponseModel(
      nearbyCharacters: nearbyCharacters ?? this.nearbyCharacters,
    );
  }
}
