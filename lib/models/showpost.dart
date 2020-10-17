import 'package:dalllalalarab/models/homeclass.dart';

class Showpost {
  String msg;
  List<Data> data;

  Showpost({this.msg, this.data});

  Showpost.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Ads post;
  List<Ads> similarPosts;
  List<Ads> similarForCity;
  List<Alladvisors> alladvisors;
  List<Alladvisors> advisorsforcity;
  int favourite;

  Data({this.post, this.similarPosts});

  Data.fromJson(Map<String, dynamic> json) {
    post = json['post'] != null ? new Ads.fromJson(json['post']) : null;
    if (json['similar_posts'] != null) {
      similarPosts = new List<Ads>();
      json['similar_posts'].forEach((v) {
        similarPosts.add(new Ads.fromJson(v));
      });
      if (json['similar_for_city'] != null) {
        similarForCity = new List<Ads>();
        json['similar_for_city'].forEach((v) {
          similarForCity.add(new Ads.fromJson(v));
        });
      }
      if (json['alladvisors'] != null) {
        alladvisors = new List<Alladvisors>();
        json['alladvisors'].forEach((v) {
          alladvisors.add(new Alladvisors.fromJson(v));
        });
      }
      if (json['advisorsforcity'] != null) {
        advisorsforcity = new List<Alladvisors>();
        json['advisorsforcity'].forEach((v) {
          advisorsforcity.add(new Alladvisors.fromJson(v));
        });
      }
      favourite = json['favourite'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    if (this.similarPosts != null) {
      data['similar_posts'] = this.similarPosts.map((v) => v.toJson()).toList();
    }
    if (this.similarForCity != null) {
      data['similar_for_city'] =
          this.similarForCity.map((v) => v.toJson()).toList();
    }
    if (this.alladvisors != null) {
      data['alladvisors'] = this.alladvisors.map((v) => v.toJson()).toList();
    }
    if (this.advisorsforcity != null) {
      data['advisorsforcity'] =
          this.advisorsforcity.map((v) => v.toJson()).toList();
    }
    data['favourite'] = this.favourite;
    return data;
  }
}

class Alladvisors {
  int id;
  String name;
  String phone;
  String city;
  int areaId;
  String createdAt;
  String updatedAt;

  Alladvisors(
      {this.id,
      this.name,
      this.city,
      this.phone,
      this.areaId,
      this.createdAt,
      this.updatedAt});

  Alladvisors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    phone = json['phone'];
    areaId = json['area_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['area_id'] = this.areaId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
