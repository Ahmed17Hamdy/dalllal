class Policiesmodel {
  String msg;
  Data data;

  Policiesmodel({this.msg, this.data});

  Policiesmodel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Policy policy;
  Phone phone;
  Phone twitter;
  Policy facebook;
  Policy instgram;

  Data({this.policy, this.phone, this.twitter, this.facebook, this.instgram});

  Data.fromJson(Map<String, dynamic> json) {
    policy =
        json['policy'] != null ? new Policy.fromJson(json['policy']) : null;
    phone = json['phone'] != null ? new Phone.fromJson(json['phone']) : null;
    twitter =
        json['twitter'] != null ? new Phone.fromJson(json['twitter']) : null;
    facebook =
        json['facebook'] != null ? new Policy.fromJson(json['facebook']) : null;
    instgram =
        json['instgram'] != null ? new Policy.fromJson(json['instgram']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policy != null) {
      data['policy'] = this.policy.toJson();
    }
    if (this.phone != null) {
      data['phone'] = this.phone.toJson();
    }
    if (this.twitter != null) {
      data['twitter'] = this.twitter.toJson();
    }
    if (this.facebook != null) {
      data['facebook'] = this.facebook.toJson();
    }
    if (this.instgram != null) {
      data['instgram'] = this.instgram.toJson();
    }
    return data;
  }
}

class Policy {
  int id;
  String slug;
  String name;
  String value;
  int type;
  int orderBy;
  String createdAt;
  String updatedAt;

  Policy(
      {this.id,
      this.slug,
      this.name,
      this.value,
      this.type,
      this.orderBy,
      this.createdAt,
      this.updatedAt});

  Policy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    value = json['value'];
    type = json['type'];
    orderBy = json['orderBy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['value'] = this.value;
    data['type'] = this.type;
    data['orderBy'] = this.orderBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Phone {
  int id;
  String slug;
  String name;
  String value;
  int type;
  int orderBy;
  Null createdAt;
  String updatedAt;

  Phone(
      {this.id,
      this.slug,
      this.name,
      this.value,
      this.type,
      this.orderBy,
      this.createdAt,
      this.updatedAt});

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    value = json['value'];
    type = json['type'];
    orderBy = json['orderBy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['value'] = this.value;
    data['type'] = this.type;
    data['orderBy'] = this.orderBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}