import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/add_fav.dart';
import 'package:dalllalalarab/models/add_report.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/models/showpost.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Mainscreen/chat.dart';
import 'package:dalllalalarab/screens/Screens/imagepreview.dart';
import 'package:dalllalalarab/screens/Screens/userdetails.dart';
import 'package:dalllalalarab/services/user_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import 'comments_page.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({this.ads});
  var ads;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addreportscaffoldKey = GlobalKey<ScaffoldState>();
  double height;
  String addfavourite = 'أضف إلى المفضلة';
  double width;
  final GlobalKey<FormState> _addReportkeyvalue = new GlobalKey<FormState>();
  final TextEditingController subject = TextEditingController();
  final TextEditingController body = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  String _body;
  String _subject;
  List<Ads> similarads;
  List similaradsList = List();
  List<Ads> similaradsforcity;
  List similaradsListforcity = List();
  List<Alladvisors> advisors;
  List advisorsList = List();
  List<Alladvisors> advisorsforcity;
  List advisorsListforcity = List();
  var commentlist = List();
  var comments;
  Future _future;
  int userid = 0;

  int favourite;

  bool consultviv = false;

  String appphone;
  Future<void> _followcomments() async {
    if (userid != 0 && userid != null) {
      var result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.none) {
        Response response;
        Dio dio = new Dio();
        response = await dio.post("https://dalllal.com/json/followresponse",
            data: {"post_id": widget.ads.id, "user_id": userid});
        if (response.statusCode == 200) {
          Followcomments data = new Followcomments.fromJson(response.data);
          if (data.msg != "error") {
            setState(() {
              final snackBar = SnackBar(
                backgroundColor: Colors.green,
                duration: const Duration(milliseconds: 500),
                content: Text(
                  'أنت الآن تتابع التعليقات لهذا الإعلان',
                  style: ksnackStyle,
                ),
              );

              // Find the Scaffold in the widget tree and use it to show a SnackBar.
              _scaffoldKey.currentState.showSnackBar(snackBar);
            });
          } else {
            setState(() {
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(milliseconds: 500),
                content: Text(
                  'أنت بالفعل مُتابع لهذا الإعلان',
                  style: ksnackStyle,
                ),
              );

              // Find the Scaffold in the widget tree and use it to show a SnackBar.
              _scaffoldKey.currentState.showSnackBar(snackBar);
            });
          }
        }
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
            style: ksnackStyle,
          ),
        );

        // Find the Scaffold in the widget tree and use it to show a SnackBar.
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  Future<void> _addfavourite() async {
    if (userid != 0 && userid != null) {
      if (addfavourite != "أزل من المفضلة") {
        var result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response;
          Dio dio = new Dio();
          response = await dio.post("https://dalllal.com/json/addfav",
              data: {"post_id": widget.ads.id, "user_id": userid});
          if (response.statusCode == 200) {
            //  Addfav data = new Addfav.fromJson(response.data);
            setState(() {
              addfavourite = "أزل من المفضلة";
              favourite = 1;
            });
          }
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 5),
            content: Text(
              'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
              style: ksnackStyle,
            ),
          );

          // Find the Scaffold in the widget tree and use it to show a SnackBar.
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } else {
        var result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          Response response;
          Dio dio = new Dio();
          response = await dio.post("https://dalllal.com/json/removefav",
              data: {"post_id": widget.ads.id, "user_id": userid});
          if (response.statusCode == 200) {
            //  Addfav data = new Addfav.fromJson(response.data);
            setState(() {
              addfavourite = "أضف إلى المفضلة";
              favourite = 0;
            });
          }
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 5),
            content: Text(
              'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
              style: ksnackStyle,
            ),
          );

          // Find the Scaffold in the widget tree and use it to show a SnackBar.
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  void report() {
    if (userid != 0 && userid != null) {
      AwesomeDialog(
        context: context,
        customHeader: Text(
          "إبلاغ عن إعلان",
          style: TextStyle(color: mycolor),
        ),
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
          bool _isButtonEnabled;
          if ((subject.text != "") &&
              (body.text != "") &&
              (subject != null) &&
              (body != null)) {
            _isButtonEnabled = true;
          } else {
            _isButtonEnabled = false;
          }

          var _onPressed;
          if (_isButtonEnabled) {
            _onPressed = () async {
              var result = await Connectivity().checkConnectivity();
              if (result != ConnectivityResult.none) {
                FormData formData = new FormData.fromMap({
                  "post_id": widget.ads.id,
                  "user_id": userid,
                  "body": _body,
                  "subject": _subject,
                });
                Response response = await Dio().post(
                  "https://dalllal.com/json/addreport",
                  data: formData,
                );
                if (response.statusCode == 200) {
                  addreport data = new addreport.fromJson(response.data);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    duration: const Duration(milliseconds: 5),
                    content: Text(
                      'تم إضافة البلاغ',
                      style: ksnackStyle,
                    ),
                  );

                  // Find the Scaffold in the widget tree and use it to show a SnackBar.
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  _btnController.success();
                }
              } else {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 5),
                  content: Text(
                    'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
                    style: ksnackStyle,
                  ),
                );

                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                _scaffoldKey.currentState.showSnackBar(snackBar);
                _btnController.reset();
              }
            };
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: TextFormField(
                  controller: subject,
                  onChanged: ((String newval) {
                    _setState(() {
                      _subject = newval;
                      if ((subject.text != "") &&
                          (body.text != "") &&
                          (subject != null) &&
                          (body != null)) {
                        _isButtonEnabled = true;
                      } else {
                        _isButtonEnabled = false;
                      }
                      //   isEmpty();
                    });
                  }),
                  // onFieldSubmitted: (v) {
                  //   FocusScope.of(context).requestFocus(focus);
                  // },

                  style: TextStyle(color: kMyColor),
                  autofocus: false,
                  decoration: kTextFeild.copyWith(labelText: 'عنوان الإبلاغ'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: TextFormField(
                  maxLines: 5,
                  controller: body,
                  onChanged: ((String newval) {
                    _setState(() {
                      _body = newval;
                      if ((subject.text != "") &&
                          (body.text != "") &&
                          (subject != null) &&
                          (body != null)) {
                        _isButtonEnabled = true;
                      } else {
                        _isButtonEnabled = false;
                      }
                      //    isEmpty();
                    });
                  }),
                  // onFieldSubmitted: (v) {
                  //   FocusScope.of(context).requestFocus(focus);
                  // },

                  style: TextStyle(color: kMyColor),
                  autofocus: false,
                  decoration: kTextFeild.copyWith(labelText: 'الموضوع'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: kButtonColor,
                        child: Container(
                          child: Text(
                            'إرسال',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: _onPressed,
                        controller: _btnController,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: Colors.red,
                        child: Container(
                          child: Text(
                            'إلغاء',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        controller: _btnController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      )..show();
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  void addcomment() {
    if (userid != 0 && userid != null) {
      AwesomeDialog(
        context: context,
        customHeader: Text(
          "إكتب تعليقاً",
          style: TextStyle(color: mycolor),
        ),
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
          bool _isButtonEnabled;
          if ((body.text != "") && (body != null)) {
            _isButtonEnabled = true;
          } else {
            _isButtonEnabled = false;
          }

          var _onPressed;
          if (_isButtonEnabled) {
            _onPressed = () async {
              var result = await Connectivity().checkConnectivity();
              if (result != ConnectivityResult.none) {
                FormData formData = new FormData.fromMap({
                  "post_id": widget.ads.id,
                  "user_id": userid,
                  "body": _body,
                });
                Response response = await Dio().post(
                  "https://dalllal.com/json/addcomment",
                  data: formData,
                );
                if (response.statusCode == 200) {
                  addreport data = new addreport.fromJson(response.data);

                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    duration: const Duration(milliseconds: 5),
                    content: Text(
                      'تم إضافة التعليق',
                      style: ksnackStyle,
                    ),
                  );

                  // Find the Scaffold in the widget tree and use it to show a SnackBar.
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  _btnController.success();
                }
              } else {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 5),
                  content: Text(
                    'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
                    style: ksnackStyle,
                  ),
                );

                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                _scaffoldKey.currentState.showSnackBar(snackBar);
                _btnController.reset();
              }
            };
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: TextFormField(
                  maxLines: 5,
                  controller: body,
                  onChanged: ((String newval) {
                    _setState(() {
                      _body = newval;
                      if ((body.text != "") && (body != null)) {
                        _isButtonEnabled = true;
                      } else {
                        _isButtonEnabled = false;
                      }
                      //    isEmpty();
                    });
                  }),
                  // onFieldSubmitted: (v) {
                  //   FocusScope.of(context).requestFocus(focus);
                  // },

                  style: TextStyle(color: kMyColor),
                  autofocus: false,
                  decoration: kTextFeild.copyWith(labelText: 'الموضوع'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: kButtonColor,
                        child: Container(
                          child: Text(
                            'إرسال',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: _onPressed,
                        controller: _btnController,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: Colors.red,
                        child: Container(
                          child: Text(
                            'إلغاء',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      )..show();
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  Future<void> _fetchdata() async {
    if (userid != 0 && userid != null) {
      Response response;
      Dio dio = new Dio();
      dio.options.connectTimeout = 10000;
      dio.options.receiveTimeout = 30000;
      response = await dio.post("https://dalllal.com/json/showpost",
          data: {"post_id": widget.ads.id, "user_id": userid});
      return response;
    } else {
      Response response;
      Dio dio = new Dio();
      dio.options.connectTimeout = 100000;
      dio.options.receiveTimeout = 300000;
      response = await dio.post("https://dalllal.com/json/showunauthpost",
          data: {"post_id": widget.ads.id});
      Showpost data = new Showpost.fromJson(response.data);
      setState(() {
        widget.ads = data.data[0].post;
      });
      return response;
    }
  }

  Future<void> _refresh() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      if (userid != 0 && userid != null) {
        Response response;
        Dio dio = new Dio();
        dio.options.connectTimeout = 5000;
        dio.options.receiveTimeout = 30000;
        response = await dio.post("https://dalllal.com/json/showpost",
            data: {"post_id": widget.ads.id, "user_id": userid});

        Showpost data = new Showpost.fromJson(response.data);
        setState(() {
          similarads = data.data[0].similarPosts;
          similaradsforcity = data.data[0].similarForCity;
          favourite = data.data[0].favourite;
          comments = data.data[0].post.cmnt;
          advisorsListforcity = data.data[0].advisorsforcity;
          advisorsList = data.data[0].alladvisors;
          for (var item in similarads) {
            if (item.title == null) {
              item.title = "بلا عنوان";
            }
            if (item.body == null) {
              item.body = "بلا تفاصيل";
            }
            if (item.images.length == 0) {
              item.images.insert(0, AssetImage('images/bc.jpg').toString());
            }
            if (item.user.rank == null) {
              item.user.rank = 0;
            }
            if (item.price == null || item.price == "") {
              item.price = "غير محدد";
            }
          }
          for (var item in similaradsforcity) {
            if (item.title == null) {
              item.title = "بلا عنوان";
            }
            if (item.body == null) {
              item.body = "بلا تفاصيل";
            }
            if (item.images.length == 0) {
              item.images.insert(0, AssetImage('images/bc.jpg').toString());
            }
            if (item.user.rank == null) {
              item.user.rank = 0;
            }
            if (item.price == null || item.price == "") {
              item.price = "غير محدد";
            }
          }
          favourite != 1
              ? addfavourite = "أضف إلى المفضلة"
              : addfavourite = "أزل من المفضلة";
          similaradsList = similarads;
          similaradsListforcity = similaradsforcity;
          commentlist = comments;
        });
        return response;
      } else {
        Response response;
        Dio dio = new Dio();
        dio.options.connectTimeout = 5000;
        dio.options.receiveTimeout = 30000;
        response = await dio.post("https://dalllal.com/json/showunauthpost",
            data: {"post_id": widget.ads.id});

        Showpost data = new Showpost.fromJson(response.data);
        setState(() {
          similarads = data.data[0].similarPosts;
          similaradsforcity = data.data[0].similarForCity;
          favourite = data.data[0].favourite;
          comments = data.data[0].post.cmnt;
          advisorsListforcity = data.data[0].advisorsforcity;
          advisorsList = data.data[0].alladvisors;
          for (var item in similarads) {
            if (item.title == null) {
              item.title = "بلا عنوان";
            }
            if (item.body == null) {
              item.body = "بلا تفاصيل";
            }
            if (item.images.length == 0) {
              item.images.insert(0, AssetImage('images/bc.jpg').toString());
            }
            if (item.user.rank == null) {
              item.user.rank = 0;
            }
            if (item.price == null || item.price == "") {
              item.price = "غير محدد";
            }
          }
          for (var item in similaradsforcity) {
            if (item.title == null) {
              item.title = "بلا عنوان";
            }
            if (item.body == null) {
              item.body = "بلا تفاصيل";
            }
            if (item.images.length == 0) {
              item.images.insert(0, AssetImage('images/bc.jpg').toString());
            }
            if (item.user.rank == null) {
              item.user.rank = 0;
            }
            if (item.price == null || item.price == "") {
              item.price = "غير محدد";
            }
          }
          favourite != 1
              ? addfavourite = "أضف إلى المفضلة"
              : addfavourite = "أزل من المفضلة";
          similaradsList = similarads;
          similaradsListforcity = similaradsforcity;
          commentlist = comments;
        });
        return response;
      }
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        content: Text(
          'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
          style: ksnackStyle,
        ),
      );

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<void> _getdata() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userid = prefs.getInt("User_id");
      appphone = prefs.getString("AppPhone");
      if (userid == null) {
        userid = 0;
      }
    });
  }

  Future<void> _sendmessage() async {
    if (userid != 0 && userid != null) {
      final String url = 'sms:+${widget.ads.user.phone}?body=hello%20there';
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  Future<void> _call() async {
    if (userid != 0 && userid != null) {
      {
        final String url = 'tel:+${widget.ads.user.phone}';
        if (await canLaunch(url)) {
          await launch(url);
        }
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  Future<void> _sendwhatsapp() async {
    if (userid != 0 && userid != null) {
      {
        final String url = 'whatsapp://send?phone=${widget.ads.user.phone}';
        if (await canLaunch(url)) {
          await launch(url);
        }
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  Future<void> _sendwhatsappforapp() async {
    if (userid != 0 && userid != null) {
      {
        final String url = 'whatsapp://send?phone=$appphone';
        if (await canLaunch(url)) {
          await launch(url);
        }
      }
    } else {
      AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              btnCancelText: "نعم",
              btnCancelColor: Colors.green,
              btnOkText: "لا",
              btnOkColor: Colors.red,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  bool isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    this._getdata();
    _future = this._fetchdata();
    if ((subject.text != "") &&
        (body.text != "") &&
        (subject != null) &&
        (body != null)) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
  }

  bool isEmpty() {
    setState(() {
      if ((subject.text != "") &&
          (body.text != "") &&
          (subject != null) &&
          (body != null)) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
    } else {
      height = MediaQuery.of(context).size.width;
      width = MediaQuery.of(context).size.height;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("تفاصيل الإعلان"),
      ),
      body: Container(
          decoration: (BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
          )),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Container(
                    height: height * 0.30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: mycolor, width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ImagePreview(
                                    images: widget.ads.images,
                                  ))),
                      child: Carousel(
                        autoplay: true,
                        animationCurve: Curves.easeOut,
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.lightGreenAccent,
                        indicatorBgPadding: 5.0,
                        dotBgColor: mycolor.withOpacity(0.5),
                        borderRadius: true,
                        moveIndicatorFromBottom: 180.0,
                        noRadiusForIndicator: true,
                        overlayShadow: true,
                        overlayShadowColors: Colors.white,
                        overlayShadowSize: 0.7,
                        images: widget.ads.images
                            .map((item) => Container(
                                  child: CachedNetworkImage(
                                    fadeInCurve: Curves.easeInBack,
                                    fit: BoxFit.contain,
                                    width: width,
                                    height: height * 0.2,
                                    imageUrl: item,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'images/bc.jpg',
                                      height: height * 0.2,
                                      width: width,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: height * .25,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                            child: Container(
                              height: height * 0.22,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: mycolor, width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserDetails(
                                                        user: widget.ads.user,
                                                      )),
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 2, left: 2),
                                          child: CircleAvatar(
                                            radius: 41,
                                            backgroundColor: mycolor,
                                            child: CircleAvatar(
                                              backgroundImage: widget
                                                          .ads.user.image ==
                                                      null
                                                  ? AssetImage(
                                                      'images/user.png')
                                                  : NetworkImage(
                                                      "https://dalllal.com/dashboard_files/usersimages/" +
                                                          widget
                                                              .ads.user.image),
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.white,
                                              radius: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            widget.ads.userName,
                                            style: TextStyle(color: mycolor),
                                          ),
                                          Text(
                                            widget.ads.area.name,
                                            style: TextStyle(color: mycolor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "التقييم",
                                            style: TextStyle(color: mycolor),
                                          ),
                                          RatingBar(
                                            ignoreGestures: true,
                                            itemSize: height * 0.02,
                                            initialRating:
                                                widget.ads.user.evaluation !=
                                                        null
                                                    ? widget.ads.user.evaluation
                                                        .toDouble()
                                                    : 0,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              size: 1,
                                              color: mycolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
//                                          setState(() async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString("ownerEmail",
                                              widget.ads.user.email);
                                          await prefs.setString("ownername",
                                              widget.ads.user.name);
                                          if (userid != 0) {
                                            print(
                                                widget.ads.user.id.toString());
                                            await UserServices().addNewMSG(
                                                prefs
                                                    .getInt("User_id")
                                                    .toString(),
                                                widget.ads.user.id.toString(),
                                                "مرحبا");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Chat(
                                                      () {},
                                                      isHasBar: true)),
                                            );
                                          } else {
                                            AwesomeDialog(
                                                    aligment: Alignment.center,
                                                    dismissOnTouchOutside:
                                                        false,
                                                    context: context,
                                                    btnCancelText: "نعم",
                                                    btnCancelColor:
                                                        Colors.green,
                                                    btnOkText: "لا",
                                                    btnOkColor: Colors.red,
                                                    headerAnimationLoop: false,
                                                    dialogType:
                                                        DialogType.WARNING,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    tittle:
                                                        'هذه الخاصية بحاجة لتسجيل الدخول ',
                                                    desc:
                                                        ' هل تريد تسجيل الدخول ؟ ',
                                                    btnCancelOnPress: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginPage()),
                                                      );
                                                    },
                                                    btnOkOnPress: () {})
                                                .show();
                                          }
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "مراسلة",
                                              style: TextStyle(color: mycolor),
                                            ),
                                            Icon(
                                              Icons.chat,
                                              color: mycolor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          'معلومات صاحب الإعلان',
                          style: kSizetStyle,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: mycolor, width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, right: 8),
                                      child: SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    "الإسم : ",
                                                    style: kDetailedTextStyle,
                                                  ),
                                                  Text(
                                                    widget.ads.title != null
                                                        ? widget.ads.title
                                                        : "بلا إسم",
                                                    style: kDetailETextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    "التاريخ  : ",
                                                    style: kDetailedTextStyle,
                                                  ),
                                                  Text(
                                                      widget.ads.timeAgo != null
                                                          ? widget.ads.timeAgo
                                                          : "",
                                                      style: kDetailETextStyle),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text('السعر : ',
                                                      style:
                                                          kDetailedTextStyle),
                                                  Text(
                                                    widget.ads.price != null
                                                        ? widget.ads.price
                                                        : "غير محدد",
                                                    style: kDetailETextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    "المدينة : ",
                                                    style: kDetailedTextStyle,
                                                  ),
                                                  Text(
                                                    widget.ads.cityName != null
                                                        ? widget.ads.cityName
                                                        : "بلا مدينة",
                                                    style: kDetailETextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(
                                              "التفاصيل : ",
                                              style: kDetailedTextStyle,
                                            ),
                                            Text(
                                              widget.ads.body != null
                                                  ? widget.ads.body
                                                  : "",
                                              style: kDetailETextStyle,
                                              overflow: TextOverflow.visible,
                                              maxLines: 10,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text(
                                            "عدد زيارات الإعلان : ",
                                            style: kDetailedTextStyle,
                                          ),
                                          Text(
                                            widget.ads.views != null
                                                ? widget.ads.views.toString()
                                                : "0",
                                            style: kDetailETextStyle,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          'تفاصيل الإعلان',
                          style: kSizetStyle,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: height * .25,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: mycolor, width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,
                              ),
                              height: height * 0.2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: _call,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.phone,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "مكالمة هاتفية",
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: _sendmessage,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.envelopeOpen,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "رسالة عبر الجوال",
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _addfavourite();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Icon(
                                                favourite == 1
                                                    ? FontAwesomeIcons
                                                        .solidHeart
                                                    : FontAwesomeIcons.heart,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                addfavourite,
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Container(
                                          height: height * .15,
                                          child: VerticalDivider(
                                            color: Colors.white,
                                            thickness: 3,
                                          )),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            report();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.reply,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "إبلاغ عن إعلان",
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _sendwhatsapp,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.whatsapp,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                " عبر واتساب",
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _followcomments();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.replyAll,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "متابعة الردود",
                                                style:
                                                    TextStyle(color: mycolor),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          ' التواصل',
                          style: kSizetStyle,
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * .3,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: mycolor, width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.white,
                              ),
                              height: height * 0.4,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: FutureBuilder(
                                          future: _future,
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                              case ConnectionState.active:
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              case ConnectionState.done:
                                                if (snapshot.hasError) {
                                                  DioError error =
                                                      snapshot.error;
                                                  String message =
                                                      error.message;
                                                  if (error.type ==
                                                      DioErrorType
                                                          .CONNECT_TIMEOUT)
                                                    message =
                                                        'Connection Timeout';
                                                  else if (error.type ==
                                                      DioErrorType
                                                          .RECEIVE_TIMEOUT)
                                                    message = 'Receive Timeout';
                                                  else if (error.type ==
                                                      DioErrorType.RESPONSE)
                                                    message =
                                                        '404 server not found ${error.response.statusCode}';
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 50),
                                                    child: RefreshIndicator(
                                                        child: new ListView(
                                                          children: <Widget>[
                                                            Center(
                                                              child: new Text(
                                                                  'خطأ في الإتصال بالشبكة '),
                                                            ),
                                                          ],
                                                        ),
                                                        onRefresh: () {
                                                          return _future =
                                                              _refresh();
                                                        }),
                                                  );
                                                }
                                                Response response =
                                                    snapshot.data;
                                                Showpost data =
                                                    new Showpost.fromJson(
                                                        response.data);
                                                commentlist =
                                                    data.data[0].post.cmnt;
                                                return RefreshIndicator(
                                                  onRefresh: () {
                                                    return _fetchdata();
                                                  },
                                                  child: commentlist.length != 0
                                                      ? ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: commentlist
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 20,
                                                                      right: 5,
                                                                      left: 5),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      color:
                                                                          mycolor,
                                                                      width: 3),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        10.0),
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                width:
                                                                    width * .7,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                FontAwesomeIcons.userAlt,
                                                                                color: Color(0xFF31533A),
                                                                                size: 15,
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              Text(
                                                                                commentlist[index].userName != null ? commentlist[index].userName : "بال إسم",
                                                                                style: kTextStyle,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                FontAwesomeIcons.clock,
                                                                                color: Color(0xFF31533A),
                                                                                size: 12,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                commentlist[index].timeAgo != null ? commentlist[index].timeAgo : "",
                                                                                style: kTextStyle,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        child:
                                                                            Wrap(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(widget.ads.comments[index].body != null
                                                                                ? widget.ads.comments[index].body
                                                                                : ""),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.flag,
                                                                            color:
                                                                                Color(0xFF31533A),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Center(
                                                          child: Text(
                                                              "لا يوجد تعليقات ")),
                                                );
                                            }
                                          })),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                addcomment();
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Text('أكتب تعليق'),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.message,
                                                    color: Color(0xFF31533A),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (userid != null ||
                                                    userid != 0) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CommentsPage(
                                                        ads: widget.ads,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          LoginPage(),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Text('عرض كل التعليقات'),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    FontAwesomeIcons.replyAll,
                                                    color: Color(0xFF31533A),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          'التعليقات',
                          style: kSizetStyle,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: height * .3,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: mycolor, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                ),
                                height: height * 0.4,
                                child: FutureBuilder(
                                    future: _future,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          return Center(
                                            // ignore: missing_return
                                            child: CircularProgressIndicator(),
                                          );
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            // ignore: missing_return
                                            DioError error = snapshot.error;
                                            String message = error.message;
                                            if (error.type ==
                                                DioErrorType.CONNECT_TIMEOUT)
                                              message = 'Connection Timeout';
                                            else if (error.type ==
                                                DioErrorType.RECEIVE_TIMEOUT)
                                              message = 'Receive Timeout';
                                            else if (error.type ==
                                                DioErrorType.RESPONSE)
                                              message =
                                                  '404 server not found ${error.response.statusCode}';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: RefreshIndicator(
                                                  child: new ListView(
                                                    children: <Widget>[
                                                      Center(
                                                        child: new Text(
                                                            'خطأ في الإتصال بالشبكة '),
                                                      ),
                                                    ],
                                                  ),
                                                  onRefresh: () {
                                                    return _future = _refresh();
                                                  }),
                                            );
                                          }
                                          Response response = snapshot.data;
                                          Showpost data = new Showpost.fromJson(
                                              response.data);
                                          similaradsList =
                                              data.data[0].similarPosts;
                                          for (var item in similaradsList) {
                                            if (item.title == null) {
                                              item.title = "بلا عنوان";
                                            }
                                            if (item.body == null) {
                                              item.body = "بلا تفاصيل";
                                            }
                                            if (item.images.length == 0) {
                                              item.images.insert(
                                                  0,
                                                  AssetImage('images/bc.jpg')
                                                      .toString());
                                            }
                                            if (item.user.rank == null) {
                                              item.user.rank = 0;
                                            }
                                            if (item.price == null ||
                                                item.price == "") {
                                              item.price = "غير محدد";
                                            }
                                          }
                                          return RefreshIndicator(
                                            onRefresh: () {
                                              return _fetchdata();
                                            },
                                            child: similaradsList.length != 0
                                                ? ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        similaradsList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5,
                                                                top: 20,
                                                                right: 5,
                                                                left: 5),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            border: Border.all(
                                                                color: mycolor,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          width: width * .7,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 4,
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        height *
                                                                            0.2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                          color:
                                                                              mycolor,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10.0),
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => DetailsScreen(
                                                                                    ads: similaradsList[index],
                                                                                  ))),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInCurve:
                                                                            Curves.easeInBack,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            width,
                                                                        imageUrl:
                                                                            similaradsList[index].images[0],
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Image.asset(
                                                                          'images/bc.jpg',
                                                                          width:
                                                                              width,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                          child: Text(similaradsList[index].title != null
                                                                              ? similaradsList[index].title
                                                                              : "بلا إسم")),
                                                                      Expanded(
                                                                        child:
                                                                            RatingBar(
                                                                          ignoreGestures:
                                                                              true,
                                                                          itemSize:
                                                                              height * 0.03,
                                                                          initialRating: similaradsList[index].user.rank != null
                                                                              ? similaradsList[index].user.rank.toDouble()
                                                                              : 0,
                                                                          minRating:
                                                                              0,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              false,
                                                                          itemCount:
                                                                              5,
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            size:
                                                                                1,
                                                                            color:
                                                                                mycolor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child: Text(
                                                        "لا يوجد إعلانات مشابهة ")),
                                          );
                                      }
                                    })),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          'الإعلانات المشابهة',
                          style: kSizetStyle,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: height * .3,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: mycolor, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                ),
                                height: height * 0.4,
                                child: FutureBuilder(
                                    future: _future,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            DioError error = snapshot.error;
                                            String message = error.message;
                                            if (error.type ==
                                                DioErrorType.CONNECT_TIMEOUT)
                                              message = 'Connection Timeout';
                                            else if (error.type ==
                                                DioErrorType.RECEIVE_TIMEOUT)
                                              message = 'Receive Timeout';
                                            else if (error.type ==
                                                DioErrorType.RESPONSE)
                                              message =
                                                  '404 server not found ${error.response.statusCode}';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: RefreshIndicator(
                                                  child: new ListView(
                                                    children: <Widget>[
                                                      Center(
                                                        child: new Text(
                                                            'خطأ في الإتصال بالشبكة '),
                                                      ),
                                                    ],
                                                  ),
                                                  onRefresh: () {
                                                    return _future = _refresh();
                                                  }),
                                            );
                                          }
                                          Response response = snapshot.data;
                                          Showpost data = new Showpost.fromJson(
                                              response.data);
                                          similaradsListforcity =
                                              data.data[0].similarForCity;
                                          for (var item
                                              in similaradsListforcity) {
                                            if (item.title == null) {
                                              item.title = "بلا عنوان";
                                            }
                                            if (item.body == null) {
                                              item.body = "بلا تفاصيل";
                                            }
                                            if (item.images.length == 0) {
                                              item.images.insert(
                                                  0,
                                                  AssetImage('images/bc.jpg')
                                                      .toString());
                                            }
                                            if (item.user.rank == null) {
                                              item.user.rank = 0;
                                            }
                                            if (item.price == null ||
                                                item.price == "") {
                                              item.price = "غير محدد";
                                            }
                                          }
                                          return RefreshIndicator(
                                            onRefresh: () {
                                              return _fetchdata();
                                            },
                                            child: similaradsListforcity
                                                        .length !=
                                                    0
                                                ? ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        similaradsListforcity
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5,
                                                                top: 20,
                                                                right: 5,
                                                                left: 5),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            border: Border.all(
                                                                color: mycolor,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          width: width * .7,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 4,
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        height *
                                                                            0.2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                          color:
                                                                              mycolor,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10.0),
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => DetailsScreen(
                                                                                    ads: similaradsListforcity[index],
                                                                                  ))),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInCurve:
                                                                            Curves.easeInBack,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width:
                                                                            width,
                                                                        imageUrl:
                                                                            similaradsListforcity[index].images[0],
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(child: CircularProgressIndicator()),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Image.asset(
                                                                          'images/bc.jpg',
                                                                          width:
                                                                              width,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                          child: Text(similaradsListforcity[index].title != null
                                                                              ? similaradsListforcity[index].title
                                                                              : "بلا إسم")),
                                                                      Expanded(
                                                                        child:
                                                                            RatingBar(
                                                                          ignoreGestures:
                                                                              true,
                                                                          itemSize:
                                                                              height * 0.03,
                                                                          initialRating: similaradsListforcity[index].user.rank != null
                                                                              ? similaradsListforcity[index].user.rank.toDouble()
                                                                              : 0,
                                                                          minRating:
                                                                              0,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          allowHalfRating:
                                                                              false,
                                                                          itemCount:
                                                                              5,
                                                                          itemBuilder: (context, _) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            size:
                                                                                1,
                                                                            color:
                                                                                mycolor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child: Text(
                                                        "لا يوجد إعلانات مشابهة ")),
                                          );
                                      }
                                    })),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, right: 50),
                        height: height * .07,
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            color: mycolor),
                        child: Center(
                            child: Text(
                          'إعلانات مشابهة داخل المدينة',
                          style: kSizetStyle,
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.ads.parentId == 1 || widget.ads.parentId == 2
                      ? true
                      : false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: mycolor, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          color: Colors.white),
                      height: height * .2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            widget.ads.parentId != 1
                                ? "للإستشارة وتقييم العقار "
                                : "للإستشارة وفحص السيارة",
                            style: TextStyle(color: mycolor),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () => _sendwhatsappforapp,
                            child: Icon(
                              FontAwesomeIcons.whatsapp,
                              size: 50,
                              color: Color(0xFFDDB871),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
