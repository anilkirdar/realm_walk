// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'harvest_result.g.dart';

@JsonSerializable()
class HarvestResult extends INetworkModel<HarvestResult> {
  final String? type;
  final String? quality;
  final int? quantity;
  final int? experienceGained;

  const HarvestResult({
    this.type,
    this.quality,
    this.quantity,
    this.experienceGained,
  });

  factory HarvestResult.fromJson(Map<String, dynamic> json) =>
      _$HarvestResultFromJson(json);

  Map<String, dynamic> toJson() => _$HarvestResultToJson(this);

  @override
  HarvestResult fromJson(Map<String, dynamic> json) =>
      _$HarvestResultFromJson(json);
}
