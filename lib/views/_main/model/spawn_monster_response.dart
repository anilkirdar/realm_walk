import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'ar_models.dart';

part 'spawn_monster_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SpawnMonsterResponse extends INetworkModel<SpawnMonsterResponse> {
  final bool success;
  final String? message;
  final ARMonster? monster;

  const SpawnMonsterResponse({
    this.success = false,
    this.message,
    this.monster,
  });

  factory SpawnMonsterResponse.fromJson(Map<String, dynamic> json) =>
      _$SpawnMonsterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpawnMonsterResponseToJson(this);

  @override
  SpawnMonsterResponse fromJson(Map<String, dynamic> json) =>
      _$SpawnMonsterResponseFromJson(json);
}
