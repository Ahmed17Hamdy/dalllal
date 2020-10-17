class ModelNotification {
  String msg;
  List<Notificationsdetails> data;

  ModelNotification({this.msg, this.data});

  ModelNotification.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Notificationsdetails>();
      json['data'].forEach((v) {
        data.add(new Notificationsdetails.fromJson(v));
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

class Notificationsdetails {
  int id;
  String title;
  String body;
  int userId;
  int ownerId;
  int postId;
  int view;
  String createdAt;
  String updatedAt;

  Notificationsdetails(
      {this.id,
      this.title,
      this.body,
      this.view,
      this.userId,
      this.ownerId,
      this.postId,
      this.createdAt,
      this.updatedAt});

  Notificationsdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    postId = json['post_id'];
    view = json['view'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['user_id'] = this.userId;
    data['owner_id'] = this.ownerId;
    data['post_id'] = this.postId;
    data['view'] = this.view;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
