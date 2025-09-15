// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_fcm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendFCMTokenModel _$SendFCMTokenModelFromJson(Map<String, dynamic> json) =>
    SendFCMTokenModel(
      userId: (json['userId'] as num).toInt(),
      os: json['os'] as String,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$SendFCMTokenModelToJson(SendFCMTokenModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fcmToken': instance.fcmToken,
      'os': instance.os,
    };
