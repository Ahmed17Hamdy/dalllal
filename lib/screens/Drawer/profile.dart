import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/country_backmodel.dart';
import 'package:dalllalalarab/models/editeprofile.dart';
import 'package:dalllalalarab/models/emailfalse.dart';
import 'package:dalllalalarab/models/erroredite.dart';
import 'package:dalllalalarab/models/false_register.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/models/phonefalse.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkeyvalue = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeypassvalue = new GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newpassword = TextEditingController();

  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  String _name = "الإسم";
  String _email = "البريد الإلكتروني";
  String _phone = "رقم الجوال";
  String _password = "كلمة المرور";
  String _newpassword = "كلمة المرور";
  String _cityname = "المدينة";
  String _countryname = "الدولة";
  String _confirmPass = "تأكيد كلمة المرور";
  double height;
  double width;
  File _image;
  String countryid;
  String _profileimage = "http://via.placeholder.com/350x150";
  List<Cities> cities;
  List citiest = List();
  List<Countries> countries;
  List countriest = List();

  Countries _countryValue;
  Cities _cityValue;
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  String _cityid;
  String code = "الكود";

  int _user_id;

  Future<void> getdata() async {
    final prefs = await SharedPreferences.getInstance();
    var st = prefs.getString("User_name");
    if (st != null) {
      setState(() {
        _name = prefs.getString("User_name");
        _user_id = prefs.getInt("User_id");
        _profileimage = prefs.getString("profileimage");
        _email = prefs.getString("Email");
        _phone = prefs.getString("phone");
        _cityname = prefs.getString("cityyname");
        _countryname = prefs.getString("countryname");
        _countryValue =
            countries.where((country) => country.name == _countryname).first;
        countryid = _countryValue.id.toString();
        code = _countryValue.code.toString();
        _cityValue = cities.where((city) => city.name == _cityname).first;
        _cityid = _cityValue.id.toString();
      });
    }
  }

  Future<void> _fetchdata() async {
    final prefs = await SharedPreferences.getInstance();
    var response = prefs.getString("response");
    if (response != null) {
      var f = jsonDecode(response);
      HomeClass data = new HomeClass.fromJson(f);

      cities = data.data.cities;
      countries = data.data.countries;
      setState(() {
        citiest = cities;
        countriest = countries;
      });
    }
  }

  Future<FormData> RegisterData() async {
    if (_image != null) {
      String filename = _image.path.split('/').last;
      return FormData.fromMap({
        "user_id": _user_id,
        "name": _name,
        "email": _email,
        "country": countryid,
        "city": _cityid,
        "phone": _phone,
        "password": _password,
        "confirmpass": _confirmPass,
        "image": await MultipartFile.fromFile(_image.path, filename: filename),
      });
    } else {
      return FormData.fromMap({
        "user_id": _user_id,
        "name": _name,
        "email": _email,
        "country": countryid,
        "city": _cityid,
        "phone": _phone,
        "password": _password,
        "confirmpass": _confirmPass,
      });
    }
  }

  Future _register() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      try {
        Response response = await Dio().post(
          "https://dalllal.com/json/editprofile",
          data: await RegisterData(),
        );
        if (response.statusCode == 200) {
          try {
            Editeprofile data = new Editeprofile.fromJson(response.data);

            _btnController.success();

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

            final snackBar = SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(milliseconds: 5000),
              content: Text(
                'تم تعديل البيانات بنجاح',
                style: ksnackStyle,
              ),
            );
            _btnController.success();
// Find the Scaffold in the widget tree and use it to show a SnackBar.
            _registerscaffoldKey.currentState.showSnackBar(snackBar);

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

  Future _editepass() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();
      response = await dio.post("https://dalllal.com/json/editpass", data: {
        "password": _newpassword,
        "old_password": _password,
        "user_id": _user_id
      });
      if (response.statusCode == 200) {
        Succesedite data = new Succesedite.fromJson(response.data);
        if (data.msg == "success") {
          final snackBar = SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 5000),
            content: Text(
              'تم تغيير كلمة المرور',
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
              'كلمة المرور الحالية غير صحيحة , من فضلك تأكد من كلمة المرور',
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
  void initState() {
    super.initState();
    this._fetchdata();
    this.getdata();
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
    var _onPressed;

    _onPressed = () {
      if (_formkeyvalue.currentState.validate()) {
        _register();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.reset();
      }
    };
    var _oneditePressed;

    _oneditePressed = () {
      if (_formkeypassvalue.currentState.validate()) {
        _editepass();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.reset();
      }
    };

    return Scaffold(
      key: _registerscaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("الصفحة الشخصية"),
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
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: mycolor,
                      child: CircleAvatar(
                        backgroundImage: _profileimage == null
                            ? AssetImage('images/user.png')
                            : NetworkImage(_profileimage),
                        backgroundColor: Colors.white,
                        radius: 55,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: height * 0.3,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                child: Container(
                                  height: height * 0.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border:
                                        Border.all(color: mycolor, width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.userAlt,
                                                    color: mycolor,
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Wrap(
                                                    children: <Widget>[
                                                      Text(
                                                        _name,
                                                        style: TextStyle(
                                                            color: mycolor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.envelope,
                                                    color: mycolor,
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      _email,
                                                      style: TextStyle(
                                                          color: mycolor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.phoneAlt,
                                                    color: mycolor,
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    _phone,
                                                    style: TextStyle(
                                                        color: mycolor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "التقييم",
                                                  style:
                                                      TextStyle(color: mycolor),
                                                ),
                                                RatingBar(
                                                  ignoreGestures: true,
                                                  itemSize: height * 0.02,
                                                  initialRating: 0,
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    size: 1,
                                                    color: mycolor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.globe,
                                                  color: mycolor,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    _countryname,
                                                    style: TextStyle(
                                                        color: mycolor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.city,
                                                  color: mycolor,
                                                  size: 19,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    _cityname,
                                                    style: TextStyle(
                                                        color: mycolor),
                                                  ),
                                                ),
                                              ],
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
                              'بيانات المستخدم',
                              style: kSizetStyle,
                            )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: mycolor),
                        child: ExpansionTile(
                          trailing: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.black,
                          ),
                          title: Text(
                            "تغيير بيانات المستخدم",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: mycolor,
                          children: <Widget>[
                            Container(
                              height: height,
                              color: Colors.white,
                              child: Form(
                                key: _formkeyvalue,
                                autovalidate: false,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0),
                                                      color: mycolor),
                                                  margin: EdgeInsets.only(
                                                      left: 70, top: 70),
                                                  child: Icon(
                                                    Icons.photo_camera,
                                                    size: 30,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            backgroundImage: _image == null
                                                ? NetworkImage(_profileimage)
                                                : FileImage(_image),
                                            backgroundColor: Colors.white,
                                            radius: 55,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: TextFormField(
                                        controller: name,
                                        onChanged: ((String name) {
                                          setState(() {
                                            _name = name;
                                          });
                                        }),
                                        // onFieldSubmitted: (v) {
                                        //   FocusScope.of(context).requestFocus(focus);
                                        // },
                                        validator: (value) {
                                          if (_name.isEmpty) {
                                            return "من فضلك أدخل الإسم";
                                          } else
                                            return null;
                                        },
                                        style: TextStyle(color: Colors.white),
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: mycolor,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 0, 30, 0),
                                          helperStyle: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                          labelText: _name,
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.user,
                                            color: Colors.white,
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                          errorStyle: TextStyle(
                                            fontSize: 10,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: email,
                                        onChanged: ((String email) {
                                          setState(() {
                                            _email = email;
                                          });
                                        }),
                                        //  focusNode: focus,
                                        // onFieldSubmitted: (v) {
                                        //   FocusScope.of(context).requestFocus(focus1);
                                        // },
                                        validator: (val) =>
                                            !EmailValidator.validate(
                                                    _email, true)
                                                ? 'صيغة البريد غير صيحة'
                                                : null,
                                        style: TextStyle(color: Colors.white),
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: mycolor,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 0, 30, 0),
                                          helperStyle: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                          labelText: _email,
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.envelope,
                                            color: Colors.white,
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                          errorStyle: TextStyle(
                                            fontSize: 10,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: OutlineDropdownButtonFormField(
                                        isExpanded: true,
                                        hint: Text(
                                          _countryname,
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
                                              const EdgeInsets.fromLTRB(
                                                  10, 2.5, 30, 2.5),
                                          labelText: _countryname,
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        iconSize: 0,
                                        value: _countryValue,
                                        items: countriest.map((country) {
                                          return new DropdownMenuItem<
                                                  Countries>(
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
                                            _cityValue = null;
                                            _cityname = "المدينة";
                                            _countryValue = newVal;
                                            _countryname = newVal.name;
                                            countryid = newVal.id.toString();
                                            code = newVal.code.toString();
                                            citiest = cities
                                                .where((city) =>
                                                    city.parentId ==
                                                    int.parse(countryid))
                                                .toList();
                                          });
                                        },
                                        validator: (value) =>
                                            _countryname == null
                                                ? 'من فضلك إختر الدولة'
                                                : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: mycolor,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                code,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
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
                                              //           focusNode: focus1,
                                              // onFieldSubmitted: (v) {
                                              //   FocusScope.of(context).requestFocus(focus2);
                                              // },
                                              keyboardType: TextInputType.phone,
                                              maxLength: 9,
                                              validator: (value) {
                                                if (_phone.isEmpty) {
                                                  return "من فضلك أدخل رقم الهاتف";
                                                } else
                                                  return null;
                                              },
                                              style: TextStyle(
                                                  color: Colors.white),
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(50.0),
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: mycolor,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 30, 0),
                                                helperStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8),
                                                labelText: _phone,
                                                hintStyle: TextStyle(
                                                    color: Colors.white),
                                                suffixIcon: Icon(
                                                  FontAwesomeIcons.phoneAlt,
                                                  color: Colors.white,
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                                errorStyle: TextStyle(
                                                  fontSize: 10,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(50.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: mycolor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: OutlineDropdownButtonFormField(
                                        value: _cityValue,
                                        items: citiest.map((city) {
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
                                            _cityValue = newVal;
                                            _cityname = newVal.name;
                                            _cityid = newVal.id.toString();
                                          });
                                        },
                                        validator: (value) => _cityname == null
                                            ? 'من فضلك إختر المدينة'
                                            : null,
                                        isDense: true,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.city,
                                            color: Colors.white,
                                          ),
                                          focusColor: Colors.white,
                                          filled: true,
                                          fillColor: mycolor,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 5, 30, 5),
                                          labelText: 'المدينة',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        iconSize: 0,
                                        hint: Text(
                                          _cityname,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Changa",
                                              fontSize: 17),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 0),
                                      child: TextFormField(
                                        controller: password,
                                        onChanged: ((String password) {
                                          setState(() {
                                            _password = password;
                                          });
                                        }),
                                        // focusNode: focus2,
                                        // onFieldSubmitted: (v) {
                                        //   FocusScope.of(context).requestFocus(focus3);
                                        // },
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
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 5, 30, 5),
                                          labelText: 'كلمة المرور',
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.lock,
                                            color: Colors.white,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 0),
                                      child: TextFormField(
                                        controller: confirmPass,
                                        onChanged: ((String confirmPass) {
                                          setState(() {
                                            _confirmPass = confirmPass;
                                          });
                                        }),
                                        //    focusNode: focus3,
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
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 5, 30, 5),
                                          labelText: 'تأكيد كلمة المرور',
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.lock,
                                            color: Colors.white,
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: mycolor,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(50.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 0),
                                      child: RoundedLoadingButton(
                                        color: kButtonColor,
                                        width: width * 0.5,
                                        animateOnTap: true,
                                        controller: _btnController,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              'تعديل',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        onPressed: _onPressed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: mycolor, width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: mycolor),
                        child: ExpansionTile(
                          trailing: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.black,
                          ),
                          title: Text(
                            "تغيير كلمة المرور",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: mycolor,
                          children: <Widget>[
                            Container(
                              height: height * 0.4,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 5),
                                        child: Container(
                                          height: height * 0.5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: mycolor, width: 3),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Form(
                                              key: _formkeypassvalue,
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 0),
                                                    child: TextFormField(
                                                      controller: password,
                                                      onChanged:
                                                          ((String password) {
                                                        setState(() {
                                                          _password = password;
                                                        });
                                                      }),
                                                      //     focusNode: focus2,
                                                      // onFieldSubmitted: (v) {
                                                      //   FocusScope.of(context).requestFocus(focus3);
                                                      // },
                                                      validator: (val) {
                                                        if (val.isEmpty)
                                                          return 'من فضلك أدخل  كلمة المرور';
                                                        else if (val.length < 6)
                                                          return 'يجب ألا تقل كلمة المرور عن 6 أرقام';
                                                        else
                                                          return null;
                                                      },
                                                      obscureText: true,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      autofocus: false,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: mycolor,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 10, 5),
                                                        labelText:
                                                            'كلمة المرور الحالية',
                                                        suffixIcon: Icon(
                                                          FontAwesomeIcons.lock,
                                                          color: Colors.white,
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: mycolor,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 0),
                                                    child: TextFormField(
                                                      controller: newpassword,
                                                      onChanged:
                                                          ((String password) {
                                                        setState(() {
                                                          _newpassword =
                                                              password;
                                                        });
                                                      }),
                                                      //     focusNode: focus2,
                                                      // onFieldSubmitted: (v) {
                                                      //   FocusScope.of(context).requestFocus(focus3);
                                                      // },
                                                      validator: (val) {
                                                        if (val.isEmpty)
                                                          return 'من فضلك أدخل  كلمة المرور';
                                                        else if (val.length < 6)
                                                          return 'يجب ألا تقل كلمة المرور عن 6 أرقام';
                                                        else
                                                          return null;
                                                      },
                                                      obscureText: true,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      autofocus: false,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: mycolor,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 30, 5),
                                                        labelText:
                                                            'كلمة المرور',
                                                        suffixIcon: Icon(
                                                          FontAwesomeIcons.lock,
                                                          color: Colors.white,
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: mycolor,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 0),
                                                    child: TextFormField(
                                                      controller: confirmPass,
                                                      onChanged: ((String
                                                          confirmPass) {
                                                        setState(() {
                                                          _confirmPass =
                                                              confirmPass;
                                                        });
                                                      }),
                                                      //         focusNode: focus3,
                                                      validator: (val) {
                                                        if (val.isEmpty)
                                                          return 'من فضلك أدخل تأكيد كلمة المرور';
                                                        else if (val !=
                                                            newpassword.text)
                                                          return 'كلمة المرور غير متطابقة';
                                                        else
                                                          return null;
                                                      },
                                                      obscureText: true,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      autofocus: false,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: mycolor,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 5, 30, 5),
                                                        labelText:
                                                            'تأكيد كلمة المرور',
                                                        suffixIcon: Icon(
                                                          FontAwesomeIcons.lock,
                                                          color: Colors.white,
                                                        ),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: mycolor,
                                                          ),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            const Radius
                                                                .circular(50.0),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            30, 10, 30, 0),
                                                    child: RoundedLoadingButton(
                                                      color: kButtonColor,
                                                      width: width * 0.5,
                                                      animateOnTap: true,
                                                      controller:
                                                          _btnController,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: 100,
                                                          child: Text(
                                                            'تعديل',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed:
                                                          _oneditePressed,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
              ],
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
