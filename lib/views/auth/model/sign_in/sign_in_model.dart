import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel extends INetworkModel<SignInModel> with EquatableMixin {
  String? email;
  String? password;

  SignInModel({
    this.email,
    this.password,
  });

  @override
  SignInModel fromJson(Map<String, dynamic> json) => SignInModel.fromJson(json);

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$SignInModelToJson(this);

  @override
  List<Object?> get props => [email, password];

  SignInModel copyWith({
    String? email,
    String? password,
  }) {
    return SignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
