// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'base_response_model.g.dart';

@JsonSerializable()
class BaseResponseModel extends INetworkModel<BaseResponseModel> {
  final String? message;
  final bool isSuccess;

  const BaseResponseModel({this.message, this.isSuccess = false});

  const BaseResponseModel.error(this.message) : isSuccess = false;

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$BaseResponseModelToJson(this);

  @override
  BaseResponseModel fromJson(Map<String, dynamic> json) =>
      BaseResponseModel.fromJson(json);

  BaseResponseModel copyWith({String? message, bool? isSuccess}) {
    return BaseResponseModel(
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
