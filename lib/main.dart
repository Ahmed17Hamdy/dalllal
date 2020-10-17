import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dalllalalarab/screens/Mainscreen/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //  print('on message $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BottomTabbed(
                      home: false,
                    )));
      },
      onResume: (Map<String, dynamic> message) async {
        //    print('on resume $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BottomTabbed(
                      home: false,
                    )));
      },
      onLaunch: (Map<String, dynamic> message) async {
        //  print('on launch $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BottomTabbed(
                      home: false,
                    )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextFormField.hide');
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: "دلال العرب",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale: Locale("ar"),
        theme: ThemeData(
            fontFamily: 'Changa', primarySwatch: mycolor, accentColor: mycolor),
        home: BottomTabbed(
          home: false,
        ),
      ),
    );
  }
}
