import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'user_error_model.g.dart';

@JsonSerializable()
class UserErrorModel extends INetworkModel<UserErrorModel> with EquatableMixin {
  final String? error;

  UserErrorModel({
    this.error,
  });

  @override
  UserErrorModel fromJson(Map<String, dynamic> json) =>
      UserErrorModel.fromJson(json);

  factory UserErrorModel.fromJson(Map<String, dynamic> json) =>
      _$UserErrorModelFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$UserErrorModelToJson(this);

  @override
  List<Object?> get props => [error];

  UserErrorModel copyWith({
    String? error,
  }) {
    return UserErrorModel(
      error: error ?? this.error,
    );
  }
}
