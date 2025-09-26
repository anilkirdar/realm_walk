// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends INetworkModel<UserModel> {
  final String? id;
  final String? email;
  final String? username;
  final DateTime? lastLogin;

  const UserModel({this.id, this.email, this.username, this.lastLogin});

  String get displayName => username ?? email ?? 'User';

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson() => _$UserModelToJson(this);
}
