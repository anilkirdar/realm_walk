// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends INetworkModel<AuthModel> {
  final String identifier;
  final String password;

  const AuthModel({required this.identifier, required this.password});

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$AuthModelToJson(this);

  @override
  AuthModel fromJson(Map<String, dynamic> json) => AuthModel.fromJson(json);

  AuthModel copyWith({
    String? identifier,
    String? password,
  }) {
    return AuthModel(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
    );
  }
}
