// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponseModel _$SignInResponseModelFromJson(Map<String, dynamic> json) =>
    SignInResponseModel(
      isSuccess: json['isSuccess'] as bool?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      character: json['character'] == null
          ? null
          : CharacterModel.fromJson(json['character'] as Map<String, dynamic>),
      token: json['token'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SignInResponseModelToJson(
  SignInResponseModel instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'user': instance.user,
  'character': instance.character,
  'token': instance.token,
  'message': instance.message,
};
