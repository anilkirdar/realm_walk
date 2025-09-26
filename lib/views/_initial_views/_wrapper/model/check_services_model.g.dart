// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckServicesModel _$CheckServicesModelFromJson(Map<String, dynamic> json) =>
    CheckServicesModel(
      isGoogleComEnabled: json['isGoogleComEnabled'] as bool?,
      googleComMessage: json['googleComMessage'] as String?,
    );

Map<String, dynamic> _$CheckServicesModelToJson(CheckServicesModel instance) =>
    <String, dynamic>{
      'isGoogleComEnabled': instance.isGoogleComEnabled,
      'googleComMessage': instance.googleComMessage,
    };
