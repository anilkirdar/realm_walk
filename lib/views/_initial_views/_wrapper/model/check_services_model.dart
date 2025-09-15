import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'check_services_model.g.dart';

@JsonSerializable()
class CheckServicesModel extends INetworkModel<CheckServicesModel> {
  bool? isLinqiAppComEnabled, isGoogleComEnabled;
  String? linqiAppMessage, googleComMessage;

  CheckServicesModel({
    this.isLinqiAppComEnabled,
    this.isGoogleComEnabled,
    this.linqiAppMessage,
    this.googleComMessage,
  });

  @override
  CheckServicesModel fromJson(Map<String, dynamic> json) =>
      CheckServicesModel.fromJson(json);

  factory CheckServicesModel.fromJson(Map<String, dynamic> json) =>
      _$CheckServicesModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CheckServicesModelToJson(this);
}
