// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

import '../../../_main/model/character_model.dart';
import '../../../_main/model/user_model.dart';

part 'sign_in_response_model.g.dart';

@JsonSerializable()
class SignInResponseModel extends INetworkModel<SignInResponseModel> {
  final bool? isSuccess;
  final UserModel? user;
  final CharacterModel? character;
  final String? token;
  final String? message;

  const SignInResponseModel({
    this.isSuccess,
    this.user,
    this.character,
    this.token,
    this.message,
  });

  factory SignInResponseModel.success({
    required UserModel user,
    CharacterModel? character,
    required String token,
    String? message,
  }) {
    return SignInResponseModel(
      isSuccess: true,
      user: user,
      character: character,
      token: token,
      message: message ?? 'Success',
    );
  }

  factory SignInResponseModel.error(String message) {
    return SignInResponseModel(isSuccess: false, message: message);
  }

  @override
  SignInResponseModel fromJson(Map<String, dynamic> json) =>
      SignInResponseModel.fromJson(json);

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$SignInResponseModelToJson(this);

  SignInResponseModel copyWith({
    bool? isSuccess,
    UserModel? user,
    CharacterModel? character,
    String? token,
    String? message,
  }) {
    return SignInResponseModel(
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
      character: character ?? this.character,
      token: token ?? this.token,
      message: message ?? this.message,
    );
  }
}
