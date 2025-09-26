// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_with_email_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpWithEmailModel _$SignUpWithEmailModelFromJson(
  Map<String, dynamic> json,
) => SignUpWithEmailModel(
  email: json['email'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  characterName: json['characterName'] as String,
  characterClass: json['characterClass'] as String,
);

Map<String, dynamic> _$SignUpWithEmailModelToJson(
  SignUpWithEmailModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'username': instance.username,
  'password': instance.password,
  'characterName': instance.characterName,
  'characterClass': instance.characterClass,
};
