import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/sendcodesuc.dart';
import 'package:dalllalalarab/screens/Autentication/password/code_verify.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController email = TextEditingController();

  String _email;
  Future<void> _sendcode() async {
    var result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();

      var url = "https://dalllal.com/json/send-forget-password";
      dio.options.baseUrl = url;
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 30000;
      response = await dio.post(url, data: {"email": _email});
      Sendcodesucc data = new Sendcodesucc.fromJson(response.data);
      if (data.msg == "success") {
        _btnController.success();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodeVerify(
                    code: data.data.pinCodeForTest,
                    email: _email,
                  )),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;

    _onPressed = () {
      if (_formKey.currentState.validate()) {
        _sendcode();
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

      } else {
        _btnController.stop();
      }
    };

    return Scaffold(
      body: Form(
        autovalidate: true,
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
            padding: EdgeInsets.fromLTRB(50, 10, 50, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'إسترجاع كلمة المرور',
                  style: kBigTextStyle,
                ),
                Image(
                  image: AssetImage('images/password.png'),
                  width: 200,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'برجاء إرسال الكود عن طريق ',
                      style: kMedTextStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      onChanged: ((String email) {
                        setState(() {
                          _email = email;
                        });
                      }),
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
                  ],
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
                        'إرسال',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: _onPressed,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
