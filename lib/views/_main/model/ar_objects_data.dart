// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import 'ar_models.dart';

part 'ar_objects_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ARObjectsData extends INetworkModel<ARObjectsData> {
  final List<ARMonster> monsters;
  final List<ARResource> resources;
  final List<ARMonster> personalMonsters; // Kişiye özel spawns

  const ARObjectsData({
    this.monsters = const [],
    this.resources = const [],
    this.personalMonsters = const [],
  });

  factory ARObjectsData.fromJson(Map<String, dynamic> json) =>
      _$ARObjectsDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARObjectsDataToJson(this);

  @override
  ARObjectsData fromJson(Map<String, dynamic> json) =>
      _$ARObjectsDataFromJson(json);
}
