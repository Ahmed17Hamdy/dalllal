class Sendcodesucc {
  String msg;
  Data data;

  Sendcodesucc({this.msg, this.data});

  Sendcodesucc.fromJson(Map<String, dynamic> json) {
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
  int pinCodeForTest;
 // List<Null> mailFails;
  String email;

  Data({this.pinCodeForTest, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    pinCodeForTest = json['pin_code_for_test'];
    
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin_code_for_test'] = this.pinCodeForTest;
    
    data['email'] = this.email;
    return data;
  }
}