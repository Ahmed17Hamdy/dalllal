import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/components/custom_form_text.dart';
import 'package:dalllalalarab/models/erroredite.dart';
import 'package:dalllalalarab/models/sendcodesuc.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../constants.dart';

class ConfirmPassWord extends StatefulWidget {
  ConfirmPassWord({this.email});
  final String email;
  @override
  _ConfirmPassWordState createState() => _ConfirmPassWordState();
}

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _ConfirmPassWordState extends State<ConfirmPassWord> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final focus = FocusNode();

  String _pass;

  String _confirmPass;
  Future<void> _changepass() async {
    var result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();

      var url = "https://dalllal.com/json/rechangepass";
      dio.options.baseUrl = url;
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 30000;
      response = await dio.post(url, data: {
        "email": widget.email,
        "new_pass": _pass,
        "confirm_pass": _confirmPass
      });
      Erroredite data = new Erroredite.fromJson(response.data);
      if (data.msg == "success") {
        _btnController.success();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        _btnController.stop();
      } else {
        _btnController.error();
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'البريد غير موجود , من فضلك تأكد من البريد الخاص بك',
            style: ksnackStyle,
          ),
        );

        _scaffoldKey.currentState.showSnackBar(snackBar);
        _btnController.reset();
      }
      return response;
    } else {
      _btnController.stop();
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
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;

    _onPressed = () {
      if (_formKey.currentState.validate()) {
        _changepass();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.stop();
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
                    'كلمة مرور جديدة',
                    style: kBigTextStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image(
                    image: AssetImage('images/confirm.png'),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'برجاء إدخال كلمة المرور الجديدة',
                        style: kMedTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          onChanged: ((String confirm) {
                            setState(() {
                              _pass = confirm;
                            });
                          }),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                          controller: pass,
                          validator: (val) {
                            if (val.isEmpty) return 'من فضلك أدخل كلمة المرور';
                            return null;
                          },
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          autofocus: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: mycolor,
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 30, 5),
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
                          onChanged: ((String confirm) {
                            setState(() {
                              _confirmPass = confirm;
                            });
                          }),
                          focusNode: focus,
                          controller: confirmPass,
                          validator: (val) {
                            if (val.isEmpty)
                              return 'من فضلك أدخل تأكيد كلمة المرور';
                            if (val != pass.text)
                              return 'كلمة المرور غير متطابقة';
                            return null;
                          },
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          autofocus: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: mycolor,
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 30, 5),
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
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  RoundedLoadingButton(
                    color: kButtonColor,
                    animateOnTap: true,
                    controller: _btnController,
                    width: width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        child: Text(
                          'تأكيد',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: _onPressed,
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
