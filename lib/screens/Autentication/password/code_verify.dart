import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/sendcodesuc.dart';
import 'package:dalllalalarab/screens/Autentication/password/confirm_password.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CodeVerify extends StatefulWidget {
  CodeVerify({this.code, this.email});
  final String email;
  final int code;

  @override
  _CodeVerifyState createState() => _CodeVerifyState();
}

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _CodeVerifyState extends State<CodeVerify> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController code = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  String _code = "الكود";
  _getcode() {
    _code = widget.code.toString();
    code.text = _code;
  }

  //String _code = widget.code.toString();
  Future<void> _sendcode() async {
    var result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();

      var url = "https://dalllal.com/json/verify-forget-password";
      dio.options.baseUrl = url;
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 30000;
      response = await dio.post(url,
          data: {"email": widget.email, "password_code_verify": widget.code});
      Sendcodesucc data = new Sendcodesucc.fromJson(response.data);
      if (data.msg == "success") {
        _btnController.success();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmPassWord(
                    email: widget.email,
                  )),
        );
        _btnController.stop();
      } else {
        _btnController.error();
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'الكود غير صحيح ',
            style: ksnackStyle,
          ),
        );

        _scaffoldKey.currentState.showSnackBar(snackBar);
        _btnController.reset();
      }
      return response;
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

  @override
  void initState() {
    super.initState();

    this._getcode();
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
                    'كود التأكيد',
                    style: kBigTextStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image(
                    image: AssetImage('images/verify.png'),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'برجاء إدخال كود التأكيد للتحقق من حسابك',
                        style: kMedTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: code,
                        onChanged: ((String email) {
                          setState(() {
                            _code = widget.code.toString();
                          });
                        }),
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
                          labelText: _code,
                          hintStyle: TextStyle(color: Colors.white),
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
            ),
          )),
        ),
      ),
    );
  }
}
