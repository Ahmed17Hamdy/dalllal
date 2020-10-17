class Editeprofile {
  bool success;
  String data;
  Message message;

  Editeprofile({this.success, this.data, this.message});

  Editeprofile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class Message {
  int id;
  String username;
  String name;
  String email;
  String phone;
  int rank;
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
  int evaluation;
  String googleToken;
  String city;
  String country;

  Message(
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
      this.evaluation,
      this.googleToken,
      this.city,
      this.country});

  Message.fromJson(Map<String, dynamic> json) {
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
    evaluation = json['evaluation'];
    googleToken = json['google_token'];
    city = json['city'];
    country = json['country'];
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
    data['evaluation'] = this.evaluation;
    data['google_token'] = this.googleToken;
    data['city'] = this.city;
    data['country'] = this.country;
    return data;
  }
}