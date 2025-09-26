// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'sign_up_with_email_model.g.dart';

@JsonSerializable()
class SignUpWithEmailModel extends INetworkModel<SignUpWithEmailModel> {
  final String email;
  final String username;
  final String password;
  final String characterName;
  final String characterClass;

  const SignUpWithEmailModel({
    required this.email,
    required this.username,
    required this.password,
    required this.characterName,
    required this.characterClass,
  });

  @override
  SignUpWithEmailModel fromJson(Map<String, dynamic> json) =>
      SignUpWithEmailModel.fromJson(json);

  factory SignUpWithEmailModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpWithEmailModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$SignUpWithEmailModelToJson(this);

  SignUpWithEmailModel copyWith({
    String? email,
    String? username,
    String? password,
    String? characterName,
    String? characterClass,
  }) {
    return SignUpWithEmailModel(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      characterName: characterName ?? this.characterName,
      characterClass: characterClass ?? this.characterClass,
    );
  }
}
