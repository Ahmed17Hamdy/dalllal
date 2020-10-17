class RegisterTrueBack {
  bool success;
  String data;
  Message message;

  RegisterTrueBack({this.success, this.data, this.message});

  RegisterTrueBack.fromJson(Map<String, dynamic> json) {
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
  String name;
  String phone;
  String email;
  String username;
  String city;
  String country;
  int type;
  Null googleToken;
  int active;
  int codeVerify;
  String apiToken;
  String image;
  String updatedAt;
  String createdAt;
  int id;

  Message(
      {this.name,
      this.phone,
      this.email,
      this.username,
      this.city,
      this.country,
      this.type,
      this.googleToken,
      this.active,
      this.codeVerify,
      this.apiToken,
      this.image,
      this.updatedAt,
      this.createdAt,
      this.id});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    city = json['city'];
    country = json['country'];
    type = json['type'];
    googleToken = json['google_token'];
    active = json['active'];
    codeVerify = json['code_verify'];
    apiToken = json['api_token'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['username'] = this.username;
    data['city'] = this.city;
    data['country'] = this.country;
    data['type'] = this.type;
    data['google_token'] = this.googleToken;
    data['active'] = this.active;
    data['code_verify'] = this.codeVerify;
    data['api_token'] = this.apiToken;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}