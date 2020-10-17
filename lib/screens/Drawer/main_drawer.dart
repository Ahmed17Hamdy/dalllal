import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Drawer/contact_us.dart';
import 'package:dalllalalarab/screens/Drawer/myads.dart';
import 'package:dalllalalarab/screens/Drawer/policies.dart';
import 'package:dalllalalarab/screens/Drawer/profile.dart';
import 'package:dalllalalarab/screens/Drawer/rules.dart';
import 'package:dalllalalarab/screens/Drawer/terms_of_use.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dalllalalarab/screens/Screens/add_adds.dart';
import 'package:dalllalalarab/screens/Drawer/commission.dart';
  import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String username = "";
  String login = "تسجيل الدخول";
  String image = "";

  @override
  initState() {
    _loadUsername();
    super.initState();
  }

  void _loadUsername() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      username = _prefs.getString("User_name");
      image = _prefs.getString("profileimage");
      if (username != "" && username != null) {
        login = "تسجيل الخروج";
      } else {
        username = "";
        image = "";
        login = "تسجيل الدخول";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            curve: Curves.bounceInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (username != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 41,
                        backgroundColor: mycolor,
                        child: CircleAvatar(
                          backgroundImage: image == ""
                              ? AssetImage('images/user.png')
                              : NetworkImage(image != null ? image : ""),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          radius: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          username != "" ? 'مرحبا \n $username ' : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('images/header.png')),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.plus, color: mycolor),
            title: Text('أضف إعلانك', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              setState(() {
                if (username != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAds()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              });
              // Update the state of the app.
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(
              FontAwesomeIcons.clipboardList,
              color: mycolor,
            ),
            title: Text('إعلاناتي', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              setState(() {
                if (username != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAds()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              });
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.red.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.listOl, color: mycolor),
            title: Text('شروط الإستخدام', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsOfUsePage(),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.listAlt, color: mycolor),
            title: Text('معاهدة إستخدام التطبيق', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Rules(),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.euroSign, color: mycolor),
            title: Text('حساب عمولة الموقع', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommossionPage(),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.crown, color: mycolor),
            title: Text('العضوية الذهبية', style: ktTextDrawerColor),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommossionPage(),
                ),
              );
            },
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.red.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.handshake, color: mycolor),
            dense: true,
            title: Text('سياسة التطبيق', style: ktTextDrawerColor),
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Policies()),
                );
              });
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.phoneAlt, color: mycolor),
            title: Text(
              'إتصل بنا',
              style: ktTextDrawerColor,
            ),
            dense: true,
            onTap: () {
              // Update the state of the app.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUs()),
              );
            },
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.red.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            leading: Icon(FontAwesomeIcons.signOutAlt, color: mycolor),
            title: Text(
              login,
              style: ktTextDrawerColor,
            ),
            dense: true,
            onTap: () async {
              // Update the state of the app.
              if (login == "تسجيل الخروج") {
                //  Navigator.pop(context);
                AwesomeDialog(
                  aligment: Alignment.center,
                  dismissOnTouchOutside: true,
                  context: context,
                  btnCancelText: "نعم",
                  btnCancelColor: Colors.green,
                  btnOkText: "لا",
                  btnOkColor: Colors.red,
                  headerAnimationLoop: false,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  tittle: 'تسجيل الخروج  ',
                  desc: ' هل تريد تسجيل الخروج ؟ ',
                  btnCancelOnPress: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setString("User_name", "");
                    await prefs.setInt("User_id", 0);
                    await prefs.setString("profileimage", "");
                    await prefs.setBool("First_log", false);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomTabbed()),
                    );
                  },
                  btnOkOnPress: () => Navigator.pop(context),
                ).show();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }

              // ...
            },
          ),
        ],
      ),
    );
  }
}
