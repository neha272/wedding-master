import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  NotificationModel({
    required this.marriageId,
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationBody,
    required this.createdDateTime,
  });

  final String marriageId;
  final String notificationId;
  final String notificationTitle;
  final String notificationBody;
  final DateTime createdDateTime;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    marriageId: json["marriage_id"],
    notificationId: json["notification_id"],
    notificationTitle: json["notification_title"],
    notificationBody: json["notification_body"],
    createdDateTime: DateTime.parse(json["created_date_time"]),
  );

  Map<String, dynamic> toJson() => {
    "marriage_id": marriageId,
    "notification_id": notificationId,
    "notification_title": notificationTitle,
    "notification_body": notificationBody,
    "created_date_time": createdDateTime.toIso8601String(),
  };
}
