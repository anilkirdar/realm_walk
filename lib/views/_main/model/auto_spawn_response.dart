import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'auto_spawn_response.g.dart';

@JsonSerializable()
class AutoSpawnResponse extends INetworkModel<AutoSpawnResponse> {
  final bool? success;
  final int? spawned;
  final AutoSpawnLocation? location;

  const AutoSpawnResponse({this.success, this.spawned, this.location});

  factory AutoSpawnResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoSpawnResponseFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$AutoSpawnResponseToJson(this);

  @override
  AutoSpawnResponse fromJson(Map<String, dynamic> json) =>
      AutoSpawnResponse.fromJson(json);
}

@JsonSerializable()
class AutoSpawnLocation extends INetworkModel<AutoSpawnLocation> {
  final String? biome;

  const AutoSpawnLocation({this.biome});

  factory AutoSpawnLocation.fromJson(Map<String, dynamic> json) =>
      _$AutoSpawnLocationFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$AutoSpawnLocationToJson(this);

  @override
  AutoSpawnLocation fromJson(Map<String, dynamic> json) =>
      AutoSpawnLocation.fromJson(json);
}
