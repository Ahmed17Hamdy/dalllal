import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Drawer/main_drawer.dart';
import 'package:dalllalalarab/screens/Screens/add_adds.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'chat.dart';
import 'favourite.dart';
import 'home.dart';
import 'notifications.dart';

class BottomTabbed extends StatefulWidget {
  BottomTabbed({this.home});
  bool home;
  @override
  _BottomTabbedState createState() => _BottomTabbedState();
}

double height;
double width;
bool firstlog = false;

class _BottomTabbedState extends State<BottomTabbed> {
  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String username;
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _selectedPage = 0;

  int userid;

  @override
  void initState() {
    _loadUsername();
    getMessage();
    Widget currentScreen = widget.home == true
        ? Home()
        : Notifications(() {
            setState(() {});
          });
    //  getMessage();
    super.initState();
  }

  int currentTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  String title = 'دلال العرب';

// void getMessage(){
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//       print('on message $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //  print('on message $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomTabbed()));
      },
      onResume: (Map<String, dynamic> message) async {
        //    print('on resume $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomTabbed()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        //  print('on launch $message');
        setState(() => _message = message["notification"]["title"]);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomTabbed()));
      },
    );
  }

  void _loadUsername() async {
    itemsClient = badger.removeAll(itemsClient);

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      firstlog = _prefs.getBool("First_log") ?? false;
      username = _prefs.getString("User_name") ?? "";
      userid = _prefs.getInt("User_id" ?? 0);
    } catch (e) {
      print(e);
    }
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

    return Scaffold(
      //  key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      drawer: MainDrawer(),

      body: IndexedStack(
        //     key: _scaffoldKey,
        index: _selectedPage,
        children: [
          Home(),
          Favourites(),
          Notifications(() {
            setState(() {});
          }),
          Chat(() {
            setState(() {});
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
        onPressed: () {
          if (userid != 0) {
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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: mycolor,
        items: itemsClient,
        currentIndex: _selectedPage,
        selectedItemColor: kIconColor,
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      switch (_selectedPage) {
        case 0:
          title = 'الرئيسية';
          break;
        case 1:
          title = 'المُفضلة';
          if (userid == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
          break;
        case 2:
          title = 'الإشعارات';
          if (userid == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }

          break;
        case 3:
          title = 'الرسائل';
          if (userid == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
          break;
        default:
      }
    });
  }
}
