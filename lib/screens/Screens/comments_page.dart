import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/add_report.dart';
import 'package:dalllalalarab/models/showpost.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({this.ads});
  var ads;

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController body = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  int userid = 0;
  String _body;
  var commentlist = List();
  var comments;

  Future _future;

  Future<void> _refresh() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt("User_id");
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
          comments = data.data[0].post.cmnt;
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

          comments = data.data[0].post.cmnt;
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



  void addcomment()async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt("User_id");
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
                  Response response1;
                  Dio dio = new Dio();

                  response1 = await dio.post("https://dalllal.com/json/showpost",
                      data: {"post_id": widget.ads.id, "user_id": userid});

                  Showpost data1 = new Showpost.fromJson(response1.data);
                  setState(() {
                    comments = data1.data[0].post.cmnt;
                    commentlist = comments;
                  });
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
                  Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
    _refresh();

    // if ((subject.text != "") &&
    //     (body.text != "") &&
    //     (subject != null) &&
    //     (body != null)) {
    //   isButtonEnabled = true;
    // } else {
    //   isButtonEnabled = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("التعليقات "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: width,
                height: height * 0.8,
                child:  commentlist.length != 0
                    ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: commentlist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 5, left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Colors.white,
                          ),
                          height: height * .2,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.userAlt,
                                            color: Color(0xFF31533A),
                                            size: 15,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            commentlist[index]
                                                .userName!=null?commentlist[index]
                                                .userName:"بلا إسم",
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
                                            commentlist[index]
                                                .timeAgo!=null?commentlist[index]
                                                .timeAgo:"",
                                            style: kTextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(

                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween
                                    ,
                                    children: <Widget>[
                                      SingleChildScrollView(
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(commentlist[index].body!=null?commentlist[index].body:""),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.flag,
                                        color: Color(0xFF31533A),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    : Center(child: Text("لا يوجد تعليقات "))
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    addcomment();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
