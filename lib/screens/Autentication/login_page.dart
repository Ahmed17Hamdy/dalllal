import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/loginfalse.dart';
import 'package:dalllalalarab/models/logintrue.dart';
import 'package:dalllalalarab/screens/Autentication/password/forget_password.dart';
import 'package:dalllalalarab/screens/Autentication/register.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final TextEditingController phone = TextEditingController();
final TextEditingController password = TextEditingController();
final RoundedLoadingButtonController _btnController =
    new RoundedLoadingButtonController();

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe;
  String _phone = "";
  String _password;
  ProgressDialog loading;
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();

  String token;
  @override
  initState() {
    _gettoken();
    _loadUsername();
    super.initState();
  }

  Future<FormData> LoginData() async {
    return FormData.fromMap({
      "phone": _phone,
      "password": _password,
      "google_token": token,
    });
  }

  Future<void> _gettoken() async {
    final pushprovider = new FirebaseMessaging();

    pushprovider.getToken().then((googletoken) {
      setState(() {
        token = googletoken;
      });

      print(token); // Print the Token in Console
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("google_token", token);
  }

  Future _login() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      // loading.show();
      try {
        Response response = await Dio().post(
          "https://dalllal.com/json/login",
          data: await LoginData(),
        );
        if (response.statusCode == 200) {
          try {
            Logintrue data = new Logintrue.fromJson(response.data);

            final prefs = await SharedPreferences.getInstance();
            // await Future.delayed(Duration(milliseconds: 5000));

            await prefs.setInt("User_id", data.message.id);
            await prefs.setString("User_name", data.message.name);
            await prefs.setString("Email", data.message.email);
            await prefs.setString("phone", data.message.phone);
            await prefs.setString("countryname", data.message.country);
            await prefs.setString("cityyname", data.message.city);
            await prefs.setString(
                "profileimage",
                "http://dalllal.com/dashboard_files/usersimages/" +
                    data.message.image);
            await prefs.setBool("First_log", true);
            _btnController.success();
            _phone = "";
            phone.text = "";
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomTabbed(
                        home: false,
                      )),
            );
            return data;
          } catch (e) {
            Loginfalse data = new Loginfalse.fromJson(response.data);
            setState(() {
              _btnController.error();
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
                      tittle: 'هذا الحساب غير مسجل  ',
                      desc: ' هل تريد الإشتراك ؟ ',
                      btnCancelOnPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registeration()),
                        );
                      },
                      btnOkOnPress: () {})
                  .show();
              _btnController.stop();
            });
          }
        }
      } catch (e) {
        setState(() {
          _btnController.error();
          new AwesomeDialog(
                  aligment: Alignment.center,
                  dismissOnTouchOutside: false,
                  context: context,
                  btnCancelText: "إعادة",
                  btnCancelColor: Colors.green,
                  btnOkText: "إلغاء",
                  btnOkColor: Colors.red,
                  headerAnimationLoop: false,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  tittle: 'خطأ في الإتصال بالشبكة ',
                  desc: ' يرجى التأكد من حالة الشبكة وإعادة المحاولة ',
                  btnCancelOnPress: () {
                    _login();
                  },
                  btnOkOnPress: () {})
              .show();
          _btnController.reset();
        });
      }
    } else {
      setState(() {
        _btnController.error();
        new AwesomeDialog(
                aligment: Alignment.center,
                dismissOnTouchOutside: false,
                context: context,
                btnCancelText: "إعادة",
                btnCancelColor: Colors.green,
                btnOkText: "إلغاء",
                btnOkColor: Colors.red,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.BOTTOMSLIDE,
                tittle: 'خطأ في الإتصال بالشبكة ',
                desc: ' يرجى التأكد من حالة الشبكة وإعادة المحاولة ',
                btnCancelOnPress: () {
                  _login();
                },
                btnOkOnPress: () {})
            .show();
        _btnController.reset();
      });
    }
  }

  Future<void> setRemember() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      setState(() {
        _prefs.setBool("remember_me", _rememberMe);
      });
    } catch (e) {
      print(e);
    }
  }

  void _loadUsername() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      setState(() {
        _phone = _prefs.getString("phone") ?? "";
        _rememberMe = _prefs.getBool("remember_me") ?? false;
        _password = password.text = "";
        if (_rememberMe == true) {
          phone.text = _phone ?? "";
        } else {
          phone.text = "";
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;
    _onPressed = () {
      if (_formKey.currentState.validate()) {
        _login();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.stop();
        //   print("dddd");
      }
    };

    return Scaffold(
      body: Form(
        autovalidate: false,
        key: _formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextFormField(
                  controller: phone,
                  onChanged: ((String phone) {
                    setState(() {
                      _phone = phone;
                    });
                  }),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "يرجي إدخال رقم الجوال !";
                    } else
                      return null;
                  },
                  keyboardType: TextInputType.phone,
                  maxLength: 9,
                  style: TextStyle(color: Colors.white),
                  autofocus: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mycolor,
                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                    labelText: 'رقم الجوال',
                    suffixIcon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.white,
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
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextFormField(
                  controller: password,
                  onChanged: ((String password) {
                    setState(() {
                      _password = password;
                    });
                  }),
                  focusNode: focus,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "يرجي إدخال كلمة المرور !";
                    }
                    if (value.length < 6) {
                      return " يجب ألا تقل كلمة المرور عن 6 أرقام أو أحرف !";
                    } else
                      return null;
                  },
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  autofocus: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mycolor,
                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                    labelText: ' كلمة المرور',
                    suffixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide(color: Colors.white),
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
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(unselectedWidgetColor: mycolor),
                            child: Checkbox(
                                value: _rememberMe,
                                checkColor: Colors.white,
                                activeColor: mycolor,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value;
                                    setRemember();
                                  });
                                }),
                          ),
                          Text(
                            'تذكرني',
                            style: TextStyle(color: mycolor),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()),
                          );
                        },
                        child: Text('هل نسيت كلمة المرور ؟'),
                      ),
                    ],
                  ),
                ),
              ),
              RoundedLoadingButton(
                color: kButtonColor,
                width: width * 0.5,
                animateOnTap: true,
                controller: _btnController,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    child: Text(
                      'تسجيل الدخول',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: _onPressed,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ليس لديك حساب ؟',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registeration()),
                          );
                        },
                        child: Text('سجل الأن ',
                            style: TextStyle(
                                color: mycolor,
                                decoration: TextDecoration.underline)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
