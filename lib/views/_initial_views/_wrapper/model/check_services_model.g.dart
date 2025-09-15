// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckServicesModel _$CheckServicesModelFromJson(Map<String, dynamic> json) =>
    CheckServicesModel(
      isLinqiAppComEnabled: json['isLinqiAppComEnabled'] as bool?,
      isGoogleComEnabled: json['isGoogleComEnabled'] as bool?,
      linqiAppMessage: json['linqiAppMessage'] as String?,
      googleComMessage: json['googleComMessage'] as String?,
    );

Map<String, dynamic> _$CheckServicesModelToJson(CheckServicesModel instance) =>
    <String, dynamic>{
      'isLinqiAppComEnabled': instance.isLinqiAppComEnabled,
      'isGoogleComEnabled': instance.isGoogleComEnabled,
      'linqiAppMessage': instance.linqiAppMessage,
      'googleComMessage': instance.googleComMessage,
    };
