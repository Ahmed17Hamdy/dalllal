import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';

import 'package:dalllalalarab/models/country_backmodel.dart';
import 'package:dalllalalarab/Providers/pushnotificationprovider.dart';

import 'package:dalllalalarab/models/emailfalse.dart';
import 'package:dalllalalarab/models/false_register.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/models/phonefalse.dart';
import 'package:dalllalalarab/models/regis_true.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Registeration extends StatefulWidget {
  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  final GlobalKey<FormState> _formkeyvalue = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  String _name;
  String _email;
  String _phone;
  String _password;
  String _cityid;
  String _confirmPass;
  Map data;
  List<Cities> cities;
  List<Countries> countries;
  String countryid;
  String cityname = "المدينة";
  List tempList = List();
  List tempListcountries = List();
  String code = "الكود";

  String countryname = "الدولة";
  ProgressDialog loading;

  bool _isButtonDisabled = false;
  List<Cities> chosencities;
  File _image;

  Countries _dropdownValue;
  Cities city;
  String policy = "";
  String token;
  Future<FormData> RegisterData() async {
    if (_image != null) {
      String filename = _image.path.split('/').last;
      return FormData.fromMap({
        "name": _name,
        "email": _email,
        "country": countryid,
        "city": _cityid,
        "phone": _phone,
        "google_token": token,
        "password": _password,
        "confirmpass": _confirmPass,
        "image": await MultipartFile.fromFile(_image.path, filename: filename),
      });
    } else {
      return FormData.fromMap({
        "name": _name,
        "email": _email,
        "country": countryid,
        "city": _cityid,
        "google_token": token,
        "phone": _phone,
        "password": _password,
        "confirmpass": _confirmPass,
      });
    }
  }

  Future<void> _fetchCountries() async {
    final prefs = await SharedPreferences.getInstance();
    var response = prefs.getString("response");

    if (response != null) {
      var f = jsonDecode(response);
      HomeClass data = new HomeClass.fromJson(f);
      countries = data.data.countries;
      cities = data.data.cities;
      setState(() {
        tempListcountries = countries;
        policy = prefs.getString("AppPoloicy" ?? "");
        loading.hide();
      });
    } else {
      loading.hide();
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5),
        content: Text(
          'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
          style: ksnackStyle,
        ),
      );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      _registerscaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future _register() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      try {
        Response response = await Dio().post(
          "https://dalllal.com/json/register",
          data: await RegisterData(),
        );
        if (response.statusCode == 200) {
          try {
            RegisterTrueBack data =
                new RegisterTrueBack.fromJson(response.data);
            setState(() {
              _btnController.success();
            });
            new AwesomeDialog(
              aligment: Alignment.center,
              dismissOnTouchOutside: false,
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'تم الإشتراك في التطبيق بنجاح  ',
              desc: ' مرحباً بك ... ',
            ).show();
            await Future.delayed(Duration(milliseconds: 5000));
            final prefs = await SharedPreferences.getInstance();
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
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomTabbed(
                        home: true,
                      )),
            );

            return data;
          } catch (e) {
            try {
              RegisterFalseBack data =
                  new RegisterFalseBack.fromJson(response.data);
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
                        tittle: 'هذا الحساب متواجد بالفعل ',
                        desc: ' هل تريد تسجيل الدخول ؟ ',
                        btnCancelOnPress: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        btnOkOnPress: () {})
                    .show();
                _btnController.stop();
              });
            } catch (e) {
              try {
                EmailFalse data = new EmailFalse.fromJson(response.data);
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
                          tittle: 'هذا الحساب متواجد بالفعل ',
                          desc: ' هل تريد تسجيل الدخول ؟ ',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          btnOkOnPress: () {})
                      .show();
                  _btnController.stop();
                });
              } catch (e) {
                PhoneFalse data = new PhoneFalse.fromJson(response.data);
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
                          tittle: 'هذا الحساب متواجد بالفعل ',
                          desc: ' هل تريد تسجيل الدخول ؟ ',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          btnOkOnPress: () {})
                      .show();
                  _btnController.stop();
                });
              }
            }
          }
        }
      } catch (e) {
        setState(() {
          _btnController.error();
          new AwesomeDialog(
                  aligment: Alignment.center,
                  dismissOnTouchOutside: false,
                  context: context,
                  btnCancelText: "نعم",
                  btnCancelColor: Colors.green,
                  btnOkText: "إلغاء",
                  btnOkColor: Colors.red,
                  headerAnimationLoop: false,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  tittle: 'خطأ في الإتصال بالشبكة ',
                  desc: ' يرجى التأكد من حالة الشبكة وإعادة المحاولة ',
                  btnCancelOnPress: () {
                    _register();
                  },
                  btnOkOnPress: () {})
              .show();
          _btnController.stop();
        });
      }
    } else {
      setState(() {
        _btnController.reset();
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
                  _register();
                },
                btnOkOnPress: () {})
            .show();
        _btnController.stop();
      });
    }
  }

  Future<void> gettoken() async {
    final pushprovider = new PushNotificationProvider();
    await pushprovider.initNotifications();
    setState(() async {
      token = pushprovider.google_token;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("google_token", token);
  }

  @override
  void initState() {
    super.initState();
    this._fetchCountries();

    gettoken();
  }

  bool showbtn = false;

  @override
  Widget build(BuildContext context) {
    void _onPolicyPress() {
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: Column(
                  children: <Widget>[
                    Text(
                      "سياسة الإستخدام",
                      style: kDialogText,
                    ),
                    Divider(),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Text(
                    policy,
                    style: kDialogText,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "حسناً",
                        style: kDialogText,
                      ))
                ],
              );
            });
      });
    }

    loading = new ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        customBody: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 10,
              ),
              Text('جاري التحميل ....!'),
            ],
          ),
        ));

    var _onPressed;
    if (_isButtonDisabled) {
      _onPressed = () {
        if (_formkeyvalue.currentState.validate()) {
          _register();
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.

        } else {
          _btnController.stop();
        }
      };
    }
    return Scaffold(
      key: _registerscaffoldKey,
      backgroundColor: mycolor,
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Form(
            key: _formkeyvalue,
            autovalidate: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text('الإشتراك في التطبيق',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: mycolor,
                        child: CircleAvatar(
                          child: InkWell(
                            onTap: _onAlertPress,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: mycolor),
                                margin: EdgeInsets.only(left: 70, top: 70),
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          backgroundImage: _image == null
                              ? AssetImage('images/user.png')
                              : FileImage(_image),
                          backgroundColor: Colors.white,
                          radius: 55,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      controller: name,
                      onChanged: ((String name) {
                        setState(() {
                          _name = name;
                        });
                      }),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "من فضلك أدخل الإسم";
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
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      onChanged: ((String email) {
                        setState(() {
                          _email = email;
                        });
                      }),
                      focusNode: focus,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus1);
                      },
                      validator: (val) => !EmailValidator.validate(val, true)
                          ? 'صيغة البريد غير صيحة'
                          : null,
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
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        helperStyle:
                            TextStyle(color: Colors.white, fontSize: 8),
                        labelText: 'البريد الإلكتروني',
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: OutlineDropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(
                        countryname,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Changa",
                            fontSize: 17),
                      ),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          FontAwesomeIcons.globe,
                          color: Colors.white,
                        ),
                        focusColor: Colors.white,
                        filled: true,
                        fillColor: mycolor,
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 2.5, 30, 2.5),
                        labelText: 'الدولة',
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
                      iconSize: 0,
                      value: _dropdownValue,
                      items: tempListcountries.map((country) {
                        return new DropdownMenuItem<Countries>(
                            child: Text(
                              country.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: "Changa",
                              ),
                            ),
                            value: country);
                      }).toList(),
                      onChanged: (Countries newVal) {
                        setState(() {
                          city = null;
                          cityname = "المدينة";
                          _dropdownValue = newVal;
                          countryname = newVal.name;
                          countryid = newVal.id.toString();
                          code = newVal.code.toString();
                          tempList = cities
                              .where((city) =>
                                  city.parentId == int.parse(countryid))
                              .toList();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'من فضلك إختر الدولة' : null,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: mycolor,
                            ),
                            child: Center(
                                child: Text(
                              code,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: phone,
                            onChanged: ((String phone) {
                              setState(() {
                                _phone = phone;
                              });
                            }),
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            keyboardType: TextInputType.phone,
                            maxLength: 9,
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
                                  TextStyle(color: Colors.white, fontSize: 8),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: OutlineDropdownButtonFormField(
                      value: city,
                      items: tempList.map((city) {
                        return new DropdownMenuItem<Cities>(
                            child: Text(
                              city.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: "Changa",
                              ),
                            ),
                            value: city);
                      }).toList(),
                      onChanged: (Cities newVal) {
                        setState(() {
                          city = newVal;
                          cityname = newVal.name;
                          _cityid = newVal.id.toString();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'من فضلك إختر المدينة' : null,
                      isDense: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          FontAwesomeIcons.city,
                          color: Colors.white,
                        ),
                        focusColor: Colors.white,
                        filled: true,
                        fillColor: mycolor,
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                        labelText: 'المدينة',
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
                      iconSize: 0,
                      hint: Text(
                        cityname,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Changa",
                            fontSize: 17),
                      ),
                      style: TextStyle(color: Colors.white),
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
                      focusNode: focus2,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus3);
                      },
                      validator: (val) {
                        if (val.isEmpty)
                          return 'من فضلك أدخل  كلمة المرور';
                        else if (val.length < 6)
                          return 'يجب ألا تقل كلمة المرور عن 6 أرقام';
                        else
                          return null;
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mycolor,
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                        labelText: 'كلمة المرور',
                        suffixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.white,
                        ),
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
                        labelStyle: TextStyle(color: Colors.white),
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
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextFormField(
                      controller: confirmPass,
                      onChanged: ((String confirmPass) {
                        setState(() {
                          _confirmPass = confirmPass;
                        });
                      }),
                      focusNode: focus3,
                      validator: (val) {
                        if (val.isEmpty)
                          return 'من فضلك أدخل تأكيد كلمة المرور';
                        else if (val != password.text)
                          return 'كلمة المرور غير متطابقة';
                        else
                          return null;
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mycolor,
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 30, 5),
                        labelText: 'تأكيد كلمة المرور',
                        suffixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(50.0),
                          ),
                          borderSide: BorderSide(
                            color: mycolor,
                          ),
                        ),
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
                    child: Row(
                      children: <Widget>[
                        Theme(
                            data: ThemeData(unselectedWidgetColor: mycolor),
                            child: Checkbox(
                                value: _isButtonDisabled,
                                activeColor: mycolor,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isButtonDisabled = value;
                                  });
                                })),
                        Text(
                          "الموافقة على ",
                          style: TextStyle(color: mycolor),
                        ),
                        GestureDetector(
                          onTap: _onPolicyPress,
                          child: Text(
                            "سياسة الإستخدام ",
                            style: TextStyle(
                                color: mycolor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                            'الإشتراك',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: _onPressed,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "لديك حساب بالفعل ؟  ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            "تسجيل الدخول ",
                            style: TextStyle(
                                color: mycolor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //========================= Gellary / Camera AlerBox
  void _onAlertPress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(
              "إختيار الصورة عن طريق",
              style: kTextStyle,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.image, color: Colors.white),
                    Text('معرض الصور', style: kTextStyle),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                    ),
                    Text('إلتقط الصورة', style: kTextStyle),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  // ================================= Image from camera
  Future getCameraImage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
      Navigator.pop(context);
    });
  }
}
