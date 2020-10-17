import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const kMyColor = Color(0xFFDDB871);
const kBigTextStyle =
    TextStyle(fontFamily: 'Changa', fontSize: 26, color: Colors.white);
const kSizetStyle = TextStyle(
  fontFamily: 'Changa',
  fontSize: 20,
  color: Colors.white,
);
const kMedTextStyle =
    TextStyle(fontFamily: 'Changa', fontSize: 22, color: Colors.white);
const ksnackStyle =
    TextStyle(fontFamily: 'Changa', fontSize: 12, color: Colors.white);

const kTextStyle =
    TextStyle(fontFamily: 'Changa', fontSize: 14, color: Color(0xFF31533A));
const ktTextDrawerColor = TextStyle(color: Color(0xFF708090));
const kButtonColor = Color(0xFF398F50);
const kIconColor = Color(0xFF31533A);
const kDialogText = TextStyle(color: Color(0xFF31533A), fontFamily: 'Changa');
const kNormalColor = Color(0xFF398F50);
const kActiveColor = Colors.white;
const kActiveTextStyle = TextStyle(
    fontFamily: 'Changa',
    fontSize: 14,
    color: Color(0xFF398F50),
    fontWeight: FontWeight.bold);
const kNormalTextStyle = TextStyle(
    fontFamily: 'Changa',
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold);
const kDetailedTextStyle = TextStyle(
    color: Color(0xFFDDB871), fontWeight: FontWeight.normal, fontSize: 15);
const kDetailETextStyle = TextStyle(
    color: Color(0xFF31533A), fontWeight: FontWeight.normal, fontSize: 15);
const kTextFeild = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(50.0),
    ),
  ),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
  helperStyle: TextStyle(color: Color(0xFFDDB871), fontSize: 8),
  labelText: '',
  hintStyle: TextStyle(color: Color(0xFFDDB871)),
  labelStyle: TextStyle(color: Color(0xFFDDB871), fontSize: 24),
  errorStyle: TextStyle(
    fontSize: 10,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(50.0),
    ),
    borderSide: BorderSide(
      color: Color(0xFFDDB871),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(50.0),
    ),
    borderSide: BorderSide(
      color: Color(0xFFDDB871),
    ),
  ),
);

const kTextFeildAdd = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
  ),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
  helperStyle: TextStyle(color: Color(0xFFDDB871), fontSize: 8),
  labelText: '',
  hintStyle: TextStyle(color: Color(0xFFDDB871)),
  suffixIcon: Icon(
    FontAwesomeIcons.envelope,
    color: Color(0xFFDDB871),
  ),
  labelStyle: TextStyle(
    color: Color(0xFFDDB871),
    fontSize: 24,
  ),
  errorStyle: TextStyle(
    fontSize: 10,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Color(0xFFDDB871),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Color(0xFFDDB871),
    ),
  ),
);

Map<int, Color> color = {
  50: Color.fromRGBO(0, 94, 50, .1),
  100: Color.fromRGBO(0, 94, 50, .2),
  200: Color.fromRGBO(0, 94, 50, .3),
  300: Color.fromRGBO(0, 94, 50, .4),
  400: Color.fromRGBO(0, 94, 50, .5),
  500: Color.fromRGBO(0, 94, 50, .6),
  600: Color.fromRGBO(0, 94, 50, .7),
  700: Color.fromRGBO(0, 94, 50, .8),
  800: Color.fromRGBO(0, 94, 50, .9),
  900: Color.fromRGBO(0, 94, 50, 1),
};
MaterialColor mycolor = MaterialColor(0xFFDDB871, color);
List<BottomNavigationBarItem> itemsClient = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(
      Icons.home,
    ),
    title: Text('الرئيسية'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.favorite,
    ),
    title: Text('المُفضلة'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.notifications,
    ),
    title: Text('الإشعارات'),
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.message,
    ),
    title: Text('الرسائل'),
  ),
];

BottomNavigationBadge badger = new BottomNavigationBadge(
    backgroundColor: Colors.red,
    badgeShape: BottomNavigationBadgeShape.circle,
    textColor: Colors.white,
    position: BottomNavigationBadgePosition.topRight,
    textSize: 8);
