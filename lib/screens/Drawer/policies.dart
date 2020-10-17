import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/erroredite.dart';
import 'package:dalllalalarab/models/policiesmodel.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Policies extends StatefulWidget {
  @override
  _PoliciesState createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  String pagetitle = "سياسة التطبيق";

  String policiesbody = "";
  Future _getpolicies() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();

      response = await dio.get("https://dalllal.com/json/settings");
      if (response.statusCode == 200) {
        Policiesmodel data = new Policiesmodel.fromJson(response.data);
        if (data.msg == "success") {
          setState(() {
            policiesbody = data.data.policy.value;
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

  @override
  void initState() {
    this._getpolicies();
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _registerscaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(pagetitle),
        ),
        body: Container(
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
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: mycolor,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'images/logo.jpg',
                            ),
                            backgroundColor: Colors.white,
                            radius: 100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: mycolor, width: 3),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(policiesbody),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
