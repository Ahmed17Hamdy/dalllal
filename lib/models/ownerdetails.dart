import 'package:dalllalalarab/models/homeclass.dart';

class Ownerdetails {
  String msg;
  List<Data> data;

  Ownerdetails({this.msg, this.data});

  Ownerdetails.fromJson(Map<String, dynamic> json) {
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
  User user;
  List<Ads> pastPosts;
  List<Reviews> reviews;

  Data({this.user, this.pastPosts, this.reviews});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['past_posts'] != null) {
      pastPosts = new List<Ads>();
      json['past_posts'].forEach((v) {
        pastPosts.add(new Ads.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = new List<Reviews>();
      json['reviews'].forEach((v) {
        reviews.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.pastPosts != null) {
      data['past_posts'] = this.pastPosts.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}






class Reviews {
  int id;
  int userId;
  String username;
  int rateId;
  String type;
  String content;
  int ownerId;
  String buyDate;
  int evaluation;
  String createdAt;
  String updatedAt;

  Reviews(
      {this.id,
      this.userId,
      this.username,
      this.rateId,
      this.type,
      this.content,
      this.ownerId,
      this.buyDate,
      this.evaluation,
      this.createdAt,
      this.updatedAt});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    rateId = json['rate_id'];
    type = json['type'];
    content = json['content'];
    ownerId = json['owner_id'];
    buyDate = json['buy_date'];
    evaluation = json['evaluation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['rate_id'] = this.rateId;
    data['type'] = this.type;
    data['content'] = this.content;
    data['owner_id'] = this.ownerId;
    data['buy_date'] = this.buyDate;
    data['evaluation'] = this.evaluation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}