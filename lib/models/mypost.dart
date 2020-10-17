import 'package:dalllalalarab/models/homeclass.dart';

class Mypost {
  String msg;
  List<Ads> data;

  Mypost({this.msg, this.data});

  Mypost.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Ads>();
      json['data'].forEach((v) {
        data.add(new Ads.fromJson(v));
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

class FavouriteResponse {
  String msg;
  List<FavouritesModel> data;

  FavouriteResponse({this.msg, this.data});

  FavouriteResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<FavouritesModel>();
      json['data'].forEach((v) {
        data.add(new FavouritesModel.fromJson(v));
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

class FavouritesModel {
  int id;
  int userId;
  int postId;
  Ads post;

  FavouritesModel({this.id, this.userId, this.postId, this.post});

  FavouritesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    post = json['post'] != null ? new Ads.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}
