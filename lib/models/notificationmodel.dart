// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromMap(jsonString);

import 'dart:convert';

class NotificationModel {
  NotificationModel(
      {this.id,
      this.title,
      this.desc,
      this.view,
      this.userId,
      this.status,
      this.orderId});

  int id;
  String title;
  String desc;
  int view;
  int status;
  int userId;
  int orderId;

  factory NotificationModel.fromJson(String str) =>
      NotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? "" : json["title"],
        desc: json["desc"] == null ? "" : json["desc"],
        view: json["view"] == null ? 1 : json["view"],
        userId: json["user_id"] == null ? null : json["user_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "desc": desc == null ? null : desc,
        "view": view == null ? null : view,
        "user_id": userId == null ? null : userId,
      };
}
