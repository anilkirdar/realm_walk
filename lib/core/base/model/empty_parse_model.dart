import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'empty_parse_model.g.dart';

@JsonSerializable()
class EmptyParseModel extends INetworkModel<EmptyParseModel> {
  const EmptyParseModel();

  @override
  EmptyParseModel fromJson(Map<String, dynamic> json) =>
      EmptyParseModel.fromJson(json);

  factory EmptyParseModel.fromJson(Map<String, dynamic> json) =>
      _$EmptyParseModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$EmptyParseModelToJson(this);
}
