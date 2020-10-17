class Erroredite {
  String msg;
  String data;

  Erroredite({this.msg, this.data});

  Erroredite.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
class Succesedite {
  String msg;
  String data;

  Succesedite({this.msg, this.data});

  Succesedite.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}