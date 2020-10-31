// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromMap(jsonString);

class ChatResponse {
  bool success;
  List<ConversationModel> data;
  String message;

  ChatResponse({this.success, this.data, this.message});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ConversationModel>();
      json['data'].forEach((v) {
        data.add(new ConversationModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ConversationModel {
  int id;
  int senderId;
  int receiverId;
  String createdAt;
  String updatedAt;
  Sender sender;
  Receiver receiver;
  Lastchat lastchat;

  ConversationModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.sender,
      this.receiver,
      this.lastchat});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null
        ? new Receiver.fromJson(json['receiver'])
        : null;
    lastchat = json['lastchat'] != null
        ? new Lastchat.fromJson(json['lastchat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver.toJson();
    }
    if (this.lastchat != null) {
      data['lastchat'] = this.lastchat.toJson();
    }
    return data;
  }
}

class Sender {
  int id;
  String username;
  String name;
  String email;
  String phone;
  Null rank;
  int type;
  String active;
  String image;
  String authComplete;
  int codeVerify;
  String passwordCodeVerify;
  String notf;
  int forbidden;
  String apiToken;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int country;
  int city;
  int evaluation;
  String googleToken;

  Sender(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.rank,
      this.type,
      this.active,
      this.image,
      this.authComplete,
      this.codeVerify,
      this.passwordCodeVerify,
      this.notf,
      this.forbidden,
      this.apiToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.country,
      this.city,
      this.evaluation,
      this.googleToken});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    rank = json['rank'];
    type = json['type'];
    active = json['active'];
    image = json['image'];
    authComplete = json['auth_complete'];
    codeVerify = json['code_verify'];
    passwordCodeVerify = json['password_code_verify'];
    notf = json['notf'];
    forbidden = json['forbidden'];
    apiToken = json['api_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    country = json['country'];
    city = json['city'];
    evaluation = json['evaluation'];
    googleToken = json['google_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['rank'] = this.rank;
    data['type'] = this.type;
    data['active'] = this.active;
    data['image'] = this.image;
    data['auth_complete'] = this.authComplete;
    data['code_verify'] = this.codeVerify;
    data['password_code_verify'] = this.passwordCodeVerify;
    data['notf'] = this.notf;
    data['forbidden'] = this.forbidden;
    data['api_token'] = this.apiToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['country'] = this.country;
    data['city'] = this.city;
    data['evaluation'] = this.evaluation;
    data['google_token'] = this.googleToken;
    return data;
  }
}

class Receiver {
  int id;
  String username;
  String name;
  String email;
  String phone;
  String rank;
  int type;
  String active;
  String image;
  int authComplete;
  int codeVerify;
  String passwordCodeVerify;
  String notf;
  int forbidden;
  String apiToken;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int country;
  int city;
  int evaluation;
  String googleToken;

  Receiver(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.rank,
      this.type,
      this.active,
      this.image,
      this.authComplete,
      this.codeVerify,
      this.passwordCodeVerify,
      this.notf,
      this.forbidden,
      this.apiToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.country,
      this.city,
      this.evaluation,
      this.googleToken});

  Receiver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    rank = json['rank'];
    type = json['type'];
    active = json['active'];
    image = json['image'];
    authComplete = json['auth_complete'];
    codeVerify = json['code_verify'];
    passwordCodeVerify = json['password_code_verify'];
    notf = json['notf'];
    forbidden = json['forbidden'];
    apiToken = json['api_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    country = json['country'];
    city = json['city'];
    evaluation = json['evaluation'];
    googleToken = json['google_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['rank'] = this.rank;
    data['type'] = this.type;
    data['active'] = this.active;
    data['image'] = this.image;
    data['auth_complete'] = this.authComplete;
    data['code_verify'] = this.codeVerify;
    data['password_code_verify'] = this.passwordCodeVerify;
    data['notf'] = this.notf;
    data['forbidden'] = this.forbidden;
    data['api_token'] = this.apiToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['country'] = this.country;
    data['city'] = this.city;
    data['evaluation'] = this.evaluation;
    data['google_token'] = this.googleToken;
    return data;
  }
}

class Lastchat {
  int id;
  String massage;
  Null file;
  int type;
  int conversationId;
  int senderId;
  int receiverId;
  int view;
  String createdAt;
  String updatedAt;

  Lastchat(
      {this.id,
      this.massage,
      this.file,
      this.type,
      this.conversationId,
      this.senderId,
      this.receiverId,
      this.view,
      this.createdAt,
      this.updatedAt});

  Lastchat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    massage = json['massage'];
    file = json['file'];
    type = json['type'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    view = json['view'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['massage'] = this.massage;
    data['file'] = this.file;
    data['type'] = this.type;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['view'] = this.view;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
