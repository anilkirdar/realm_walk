import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'error_model_custom.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class ErrorModelCustom extends INetworkModel<ErrorModelCustom> {
  int? statusCode;
  dynamic message;

  ErrorModelCustom({
    this.statusCode,
    this.message,
  });

  @override
  ErrorModelCustom fromJson(Map<String, dynamic> json) =>
      ErrorModelCustom.fromJson(json);

  factory ErrorModelCustom.fromJson(Map<String, dynamic> json) {
    return _$ErrorModelCustomFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$ErrorModelCustomToJson(this);
}
