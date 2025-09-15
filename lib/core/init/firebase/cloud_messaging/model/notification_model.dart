import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  String? id, title, description, imageUrl, type;
  dynamic variables;

  NotificationModel(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.type,
      this.variables
      // this.click_action,
      ///FLUTTER_NOTIFICATION_CLICK
      });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic>? toJson() => _$NotificationModelToJson(this);
}
