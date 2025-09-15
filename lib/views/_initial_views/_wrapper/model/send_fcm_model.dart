import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'send_fcm_model.g.dart';

@JsonSerializable()
class SendFCMTokenModel extends INetworkModel<SendFCMTokenModel> {
  final int userId;
  String? fcmToken;
  final String os;

  SendFCMTokenModel({
    required this.userId,
    required this.os,
    this.fcmToken,
  });

  @override
  SendFCMTokenModel fromJson(Map<String, dynamic> json) =>
      SendFCMTokenModel.fromJson(json);

  factory SendFCMTokenModel.fromJson(Map<String, dynamic> json) =>
      _$SendFCMTokenModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$SendFCMTokenModelToJson(this);
}
