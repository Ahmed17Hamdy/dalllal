import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/erroredite.dart';
import 'package:dalllalalarab/models/policiesmodel.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<FormState> _formkeyvalue = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController body = TextEditingController();

  String _name;

  String _phone;

  String _body;

  String facebook = "https://www.facebook.com";

  String insta = "https://www.instagram.com/?hl=en";

  String twitter = "https://twitter.com";

  String appphone;
  @override
  void initState() {
    super.initState();
    _getpolicies();
  }

  Future _getpolicies() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      response = await dio.get("https://dalllal.com/json/settings");
      if (response.statusCode == 200) {
        Policiesmodel data = new Policiesmodel.fromJson(response.data);
        if (data.msg == "success") {
          setState(() {
            facebook = data.data.facebook.value;
            insta = data.data.instgram.value;
            twitter = data.data.twitter.value;
            appphone = prefs.getString("AppPhone");
          });
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 5000),
            content: Text(
              'تحقق من إتصالك بالإنترنت',
              style: ksnackStyle,
            ),
          );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
          _registerscaffoldKey.currentState.showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'لا يوجد إتصال بالإنترنت',
            style: ksnackStyle,
          ),
        );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
        _registerscaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  Future _contact() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      int _userid = prefs.getInt("User_id");
      response = await dio.post("https://dalllal.com/json/addcontact", data: {
        "user_id": _userid,
        "phone": _phone,
        "name": _name,
        "body": _body
      });
      if (response.statusCode == 200) {
        Erroredite data = new Erroredite.fromJson(response.data);
        if (data.msg == "success") {
          final snackBar = SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 5000),
            content: Text(
              'تم إرسال الرسالة بنجاح , سعداء بالتواصل معكم ',
              style: ksnackStyle,
            ),
          );
          _btnController.success();
// Find the Scaffold in the widget tree and use it to show a SnackBar.
          _registerscaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 5000),
            content: Text(
              'تحقق من إتصالك بالإنترنت',
              style: ksnackStyle,
            ),
          );
          _btnController.error();

// Find the Scaffold in the widget tree and use it to show a SnackBar.
          _registerscaffoldKey.currentState.showSnackBar(snackBar);
          _btnController.reset();
        }
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'لا يوجد إتصال بالإنترنت',
            style: ksnackStyle,
          ),
        );
        _btnController.error();
        _btnController.reset();
// Find the Scaffold in the widget tree and use it to show a SnackBar.
        _registerscaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;

    _onPressed = () {
      if (_formkeyvalue.currentState.validate()) {
        _contact();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.stop();
      }
    };

    return Scaffold(
      key: _registerscaffoldKey,
      appBar:
          PreferredSize(child: AppBar(), preferredSize: Size.fromHeight(50.0)),
      body: Form(
        key: _formkeyvalue,
        autovalidate: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bc.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.fromLTRB(35, 10, 35, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'إتصل بنا',
                    style: kBigTextStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: mycolor, width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: TextFormField(
                            controller: name,
                            onChanged: ((String name) {
                              setState(() {
                                _name = name;
                              });
                            }),
                            autofocus: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "من فضلك أدخل الإسم";
                              } else
                                return null;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                              ),
                              filled: true,
                              fillColor: mycolor,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              helperStyle:
                                  TextStyle(color: Colors.white, fontSize: 8),
                              labelText: 'الإسم',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                              ),
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 24),
                              errorStyle: TextStyle(
                                fontSize: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(
                                  color: mycolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLength: 9,
                            controller: phone,
                            onChanged: ((String phone) {
                              setState(() {
                                _phone = phone;
                              });
                            }),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "من فضلك أدخل رقم الهاتف";
                              } else
                                return null;
                            },
                            style: TextStyle(color: Colors.white),
                            autofocus: false,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                              ),
                              filled: true,
                              fillColor: mycolor,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              helperStyle:
                                  TextStyle(color: mycolor, fontSize: 8),
                              labelText: 'رقم الهاتف',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(
                                FontAwesomeIcons.phoneAlt,
                                color: Colors.white,
                              ),
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 24),
                              errorStyle: TextStyle(
                                fontSize: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(
                                  color: mycolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: body,
                            onChanged: ((String body) {
                              setState(() {
                                _body = body;
                              });
                            }),
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            maxLength: 50,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "من فضلك أدخل نص الرسالة";
                              } else
                                return null;
                            },
                            style: TextStyle(color: Colors.white),
                            autofocus: false,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: mycolor,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              helperStyle:
                                  TextStyle(color: mycolor, fontSize: 8),
                              labelText: 'الرسالة',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.white,
                              ),
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 24),
                              errorStyle: TextStyle(
                                fontSize: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: mycolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: RoundedLoadingButton(
                            color: kButtonColor,
                            animateOnTap: true,
                            controller: _btnController,
                            width: width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                child: Text(
                                  'إرسال',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: _onPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                color: kButtonColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  "أو عن طريق مواقع التواصل",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  final url = facebook;
                                  if (await canLaunch(url)) {
                                    await launch(url, forceSafariVC: false);
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors.blue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final url = twitter;
                                  if (await canLaunch(url)) {
                                    await launch(url, forceSafariVC: false);
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.twitter,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final url = insta;
                                  if (await canLaunch(url)) {
                                    await launch(url, forceSafariVC: false);
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2.0),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFf9ed32),
                                            Color(0xFFee2a7b),
                                            Color(0xFF002aff)
                                          ],
                                        )),
                                    child: Icon(FontAwesomeIcons.instagram,
                                        color: Colors.white)),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final String url =
                                      'whatsapp://send?phone=$appphone';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                                child: Icon(FontAwesomeIcons.whatsapp,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
