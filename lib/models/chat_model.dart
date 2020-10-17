// To parse this JSON data, do
//
//     final chatModel = chatModelFromMap(jsonString);

import 'dart:convert';

class ChatModel {
  ChatModel({
    this.id,
    this.massage,
    this.file,
    this.type,
    this.serviceId,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.receiver,
//      this.lastChat
  });

  int id;
  String massage;
  String file;
  int type;
  dynamic serviceId;
  int conversationId;
  int senderId;
  int receiverId;
  DateTime createdAt;
  DateTime updatedAt;
  Receiver sender;
//  dynamic lastChat;
  Receiver receiver;

  factory ChatModel.fromJson(String str) => ChatModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
        id: json["id"] == null ? null : json["id"],
        massage: json["massage"] == null ? null : json["massage"],
        file: json["file"] == null ? null : json["file"],
        type: json["type"] == null ? null : json["type"],
//        lastChat: json["lastchat"] == null ? null : json["lastchat"],
        serviceId: json["service_id"],
        conversationId:
            json["conversation_id"] == null ? null : json["conversation_id"],
        senderId: json["sender_id"] == null ? null : json["sender_id"],
        receiverId: json["receiver_id"] == null ? null : json["receiver_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        sender:
            json["sender"] == null ? null : Receiver.fromMap(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : Receiver.fromMap(json["receiver"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "massage": massage == null ? null : massage,
        "file": file == null ? null : file,
        "type": type == null ? null : type,
        "service_id": serviceId,
        "conversation_id": conversationId == null ? null : conversationId,
        "sender_id": senderId == null ? null : senderId,
        "receiver_id": receiverId == null ? null : receiverId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "sender": sender == null ? null : sender.toMap(),
        "receiver": receiver == null ? null : receiver.toMap(),
      };
}

class Receiver {
  Receiver({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.avatar,
    this.gender,
    this.typeUser,
    this.emailVerifiedAt,
    this.phone,
    this.phone2,
    this.code,
    this.activate,
    this.approved,
    this.cityId,
    this.deviceToken,
    this.settings,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int roleId;
  String name;
  String email;
  String avatar;
  dynamic gender;
  String typeUser;
  dynamic emailVerifiedAt;
  String phone;
  dynamic phone2;
  dynamic code;
  dynamic activate;
  int approved;
  int cityId;
  dynamic deviceToken;
  List<dynamic> settings;
  int rate;
  DateTime createdAt;
  DateTime updatedAt;

  factory Receiver.fromJson(String str) => Receiver.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Receiver.fromMap(Map<String, dynamic> json) => Receiver(
        id: json["id"] == null ? null : json["id"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        gender: json["gender"],
        typeUser: json["type_user"] == null ? null : json["type_user"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"] == null ? null : json["phone"],
        phone2: json["phone2"],
        code: json["code"],
        activate: json["activate"],
        approved: json["approved"] == null ? null : json["approved"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        deviceToken: json["device_token"],
        settings: json["settings"] == null
            ? null
            : List<dynamic>.from(json["settings"].map((x) => x)),
        rate: json["rate"] == null ? null : json["rate"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "role_id": roleId == null ? null : roleId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "avatar": avatar == null ? null : avatar,
        "gender": gender,
        "type_user": typeUser == null ? null : typeUser,
        "email_verified_at": emailVerifiedAt,
        "phone": phone == null ? null : phone,
        "phone2": phone2,
        "code": code,
        "activate": activate,
        "approved": approved == null ? null : approved,
        "city_id": cityId == null ? null : cityId,
        "device_token": deviceToken,
        "settings": settings == null
            ? null
            : List<dynamic>.from(settings.map((x) => x)),
        "rate": rate == null ? null : rate,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
