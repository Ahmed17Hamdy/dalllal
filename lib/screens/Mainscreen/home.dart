import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/country_backmodel.dart';
import 'package:dalllalalarab/models/policiesmodel.dart';
import 'package:dalllalalarab/screens/Mainscreen/notifications.dart';
import 'package:dalllalalarab/screens/Screens/detailsscreen.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/screens/Drawer/main_drawer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'bottom_tabed.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _currentTab = 0;
  int _modelTab = 0;
  bool _isvisible = false;
  bool _mainvisible = true;
  bool _modelvisible = false;
  List<Cats> categories;
  List<Subcategories> subcategories;
  List<Ads> ads;
  List<Cities> cities;
  List citiestemp = List();
  List<Regions> allregions = List<Regions>();
  List regions = List();
  String countryid;
  String cityname = "كل المدن";
  List tempList = List();
  List subList = List();
  List modelList = List();
  List adsList = List();
  List checkedmodels = List();
  double height;
  double width;
  ProgressDialog loading;
  bool out = false;
  int select1 = 0;
  bool _isChecked = true;
  List _selectedyears = List();
  List _selectedyearsTo = List();
  List subadsList = List();
  List subadsModelList = List();
  int mainint = 0;
  Cities city;
  List<YearModel> years = new List<YearModel>();

  var _maincatname;

  Future _future;

  String username;

  int subint = 0;

  String maincategoryname;

  String subname;

  int submodelint = 0;

  int _cityid = 0;

  List<Ads> maincategorylist;

  String regionname = "كل الأحياء";

  int _regionid;

  bool regionvisible = false;

  Regions region;
  String _message = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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

  Future _getpolicies() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();

      response = await dio.get("https://dalllal.com/json/settings");
      if (response.statusCode == 200) {
        Policiesmodel data = new Policiesmodel.fromJson(response.data);
        if (data.msg == "success") {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("AppPhone", data.data.phone.value);
          await prefs.setString("AppPoloicy", data.data.policy.value);
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
          _scaffoldKey.currentState.showSnackBar(snackBar);
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
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  Future<HomeClass> _fetchCAds() async {
    var result = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();
    if (result != ConnectivityResult.none) {
      //   loading.show();
      try {
        Response response = await Dio().get("https://dalllal.com/json/home");

        if (response.statusCode == 200) {
          HomeClass data = new HomeClass.fromJson(response.data);

          var s = data.toJson();
          var d = jsonEncode(s);
          await prefs.setString("response", d);
          setState(() {
            Cats main = new Cats();

            //  categories.clear();
            main.name = "الرئيسية";
            tempList.insert(0, main);
            categories = data.data.cats;
            allregions = data.data.regions;
            tempList.addAll(categories);

            cities = data.data.cities;
            Cities allcities = new Cities();

            allcities.name = "كل المدن";
            allcities.id = 0;
            citiestemp.insert(0, allcities);
            citiestemp.addAll(cities);
            subcategories = data.data.subcategories;
            ads = data.data.ads;
            for (var item in ads) {
              if (item.title == null) {
                item.title = "بلا عنوان";
              }
              if (item.body == null) {
                item.body = "بلا تفاصيل";
              }
              if (item.images.length == 0) {
                item.images.insert(0, AssetImage('images/bc.jpg').toString());
              }
              if (item.user.evaluation == null) {
                item.user.evaluation = 0;
              }
              if (item.regionId == null) {
                item.regionId = 0;
              }
              if (item.price == null || item.price == "") {
                item.price = "غير محدد";
              }
            }
            adsList = ads;
            loading.hide();
          });

          return data;
        } else {
          setState(() {
            loading.hide();
          });

          //     netError.show();
          //  throw Exception('Failed to load internet');
        }
      } catch (e) {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
            style: ksnackStyle,
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        //   netError.show();
        // throw Exception('Failed to load internet');
      }
    } else {
      // final prefs = await SharedPreferences.getInstance();
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        content: Text(
          'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
          style: ksnackStyle,
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      // netError.show();
    }
  }

  Future<HomeClass> _refresh() async {
    var result = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();
    if (result != ConnectivityResult.none) {
      //   loading.show();
      try {
        Response response = await Dio().get("https://dalllal.com/json/home");

        if (response.statusCode == 200) {
          HomeClass data = new HomeClass.fromJson(response.data);
          var s = data.toJson();
          var d = jsonEncode(s);
          await prefs.setString("response", d);
          setState(() {
            categories = data.data.cats;
            Cats main = new Cats();

            tempList.clear();
            main.name = "الرئيسية";
            tempList.insert(0, main);
            categories = data.data.cats;
            allregions = data.data.regions;
            tempList.addAll(categories);

            cities = data.data.cities;
            citiestemp = cities;
            subcategories = data.data.subcategories;
            ads = data.data.ads;
            for (var item in ads) {
              if (item.title == null) {
                item.title = "بلا عنوان";
              }
              if (item.body == null) {
                item.body = "بلا تفاصيل";
              }
              if (item.images.length == 0) {
                item.images.insert(0, AssetImage('images/logo.jpg').toString());
              }
              if (item.user.evaluation == null) {
                item.user.evaluation = 0;
              }
              if (item.price == null || item.price == "") {
                item.price = "غير محدد";
              }
              if (item.regionId == null) {
                item.regionId = 0;
              }
            }
            adsList = ads;
            // if (mainint == 0) {
            //   adsList = ads;
            // } else {
            //   adsList =
            //       adsList = ads.where((ad) => ad.parentId == mainint).toList();
            // }
            // if (subint == 0) {
            //   adsList = ads.where((ad) => ad.parentId == select1).toList();
            // } else {
            //   adsList = ads.where((ad) => ad.catId == subint).toList();
            // }
            // if (submodelint != 0) {
            //   adsList = ads.where((ad) => ad.catId == submodelint).toList();
            // }
            // //  adsList = ads.where((ad) => ad.parentId == select1).toList();
            // // } else {
            // //   adsList = ads.where((ad) => ad.catId == submodelint).toList();
            // // }
            // if (_cityid != 0) {
            //   adsList = adsList.where((ad) => ad.cityId == _cityid).toList();
            // }
            // if (_selectedyearsTo.length != 0) {
            //   for (var year in _selectedyears) {
            //     subadsList.addAll(ads
            //         .where((ad) => ad.model == int.parse(year.year))
            //         .toList());
            //   }
            //   adsList = subadsList;
            // }
          });

          return data;
        } else {
          setState(() {
            loading.hide();
          });

          //     netError.show();
          //  throw Exception('Failed to load internet');
        }
      } catch (e) {
        //   netError.show();
        // throw Exception('Failed to load internet');
      }
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        content: Text(
          'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
          style: ksnackStyle,
        ),
      );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBar);

      // netError.show();
    }
  }

  Future<bool> _onBackPressed() async {
    setState(() async {
      await AwesomeDialog(
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
        tittle: ' دلال العرب  ',
        desc: ' هل تريد الخروج من التطبيق ؟ ',
        btnCancelOnPress: () => SystemNavigator.pop(),
        btnOkOnPress: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomTabbed()),
        ),
      ).show();
    });

    // if (_modelvisible == true) {
    //   setState(() {
    //     _modelvisible = false;
    //     _mainvisible = true;
    //     adsList = ads.where((ad) => ad.parentId == select1).toList();
    //   });
    // } else if (_modelvisible == false && _isvisible == true) {
    //   setState(() {
    //     adsList = ads.where((ad) => ad.catId == mainint).toList();
    //     _isvisible = false;
    //      _selectedIndex = 0;
    //   });
    // } else if (_modelvisible == false && out == false && _isvisible == false) {
    //   setState(() {
    //     if (adsList.length != 0) {
    //       adsList = ads;
    //     }
    //   });
    //   _selectedIndex = 0;
    //   out = true;
    // } else {
    //   return
    // }
  }

  void _getYears() {
    for (int i = 2021; i > 1992; i--) {
      YearModel year = new YearModel();
      year.id = i;
      year.year = i.toString();
      year.input = false;
      years.add(year);
    }
  }

  void _loadUsername() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      firstlog = _prefs.getBool("First_log") ?? false;
      username = _prefs.getString("User_name") ?? "";
      if (firstlog == true) {
        final snackBar = SnackBar(
          backgroundColor: mycolor,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'مرحباً بك , $username',
            style: ksnackStyle,
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        await _prefs.setBool("First_log", false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getpolicies();
    _loadUsername();
    getMessage();
    _future = this._fetchCAds();
    this._getYears();
  }

  void itemChange(bool val, int index) {
    setState(() {
      years[index].input = val;
    });
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

    loading = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      customBody: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: height * 0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 10,
              ),
              Text('جاري التحميل ....!'),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          decoration: (BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
          )),
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        expandedHeight: height * 0.35,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: SingleChildScrollView(
                            child: Column(children: <Widget>[
                              Container(
                                height: height * 0.08,
                                padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                child: TextField(
                                  onSubmitted: (text) {
                                    setState(() {
                                      adsList = ads
                                          .where((ad) => ad.title
                                              .contains(text.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                  onChanged: (text) {
                                    setState(() {
                                      adsList = ads
                                          .where((ad) => ad.title
                                              .contains(text.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: Icon(Icons.search),
                                      hintText: "إبحث في دلال العرب",
                                      contentPadding: EdgeInsets.all(5)),
                                ),
                              ),
                              Visibility(
                                visible: _mainvisible,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(
                                      height: height * 0.05,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tempList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedIndex = 0;
                                                _modelvisible = false;
                                                _maincatname =
                                                    tempList[index].name;
                                                if (_maincatname !=
                                                    "الرئيسية") {
                                                  _selectedIndex = index;
                                                  _isvisible = true;
                                                  Subcategories sub =
                                                      new Subcategories();
                                                  sub.name = "الكل";
                                                  subList.clear();
                                                  subList.insert(0, sub);
                                                  mainint = tempList[index].id;
                                                  subList.addAll(subcategories
                                                      .where((sub) =>
                                                          sub.parentId ==
                                                          mainint)
                                                      .toList());
                                                  //  subList.insert(0,sub);
                                                  // subList.addAll();
                                                  select1 = tempList[index].id;
                                                  maincategorylist = ads
                                                      .where((ad) =>
                                                          ad.parentId ==
                                                          mainint)
                                                      .toList();
                                                  adsList = maincategorylist;
                                                  _currentTab = 0;
                                                } else {
                                                  _isvisible = false;
                                                  adsList = ads;
                                                  mainint = 0;
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: _selectedIndex == index
                                                      ? kActiveColor
                                                      : kNormalColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                    tempList[index].name,
                                                    style:
                                                        _selectedIndex == index
                                                            ? kActiveTextStyle
                                                            : kNormalTextStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: _isvisible,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(
                                      height: height * 0.05,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: subList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _currentTab = 0;
                                              setState(() {
                                                mainint = 0;
                                                _selectedyearsTo.clear();
                                                subint = subList[index].id;
                                                subname = subList[index].name;
                                                if (subList[index].name !=
                                                        "الكل" &&
                                                    _maincatname ==
                                                        "السيارات") {
                                                  _currentTab = index;
                                                  _mainvisible = false;
                                                  _modelvisible = true;
                                                  adsList = maincategorylist
                                                      .where((ad) =>
                                                          ad.catId == subint)
                                                      .toList();

                                                  modelList.clear();
                                                  Models model = new Models();
                                                  model.name = "الكل";
                                                  modelList.insert(0, model);
                                                  modelList.addAll(
                                                      subList[index].models);
                                                } else if (subList[index]
                                                            .name !=
                                                        "الكل" &&
                                                    _maincatname !=
                                                        "السيارات") {
                                                  _currentTab = index;
                                                  _mainvisible = true;
                                                  _modelvisible = false;
                                                  adsList = maincategorylist
                                                      .where((ad) =>
                                                          ad.catId == subint)
                                                      .toList();

                                                  modelList.clear();
                                                } else {
                                                  _currentTab = 0;
                                                  subint = 0;
                                                  _mainvisible = true;
                                                  _modelvisible = false;
                                                  adsList = maincategorylist;
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: _currentTab == index
                                                      ? kActiveColor
                                                      : kNormalColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                    subList[index].name,
                                                    style: _currentTab == index
                                                        ? kActiveTextStyle
                                                        : kNormalTextStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: _modelvisible,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(
                                      height: height * 0.05,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: modelList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _modelTab = 0;
                                              mainint = 0;
                                              setState(() {
                                                _selectedyearsTo.clear();
                                                submodelint =
                                                    modelList[index].id;
                                                if (modelList[index].name !=
                                                    "الكل") {
                                                  _modelTab = index;
                                                  _mainvisible = false;
                                                  adsList = maincategorylist
                                                      .where((ad) =>
                                                          ad.brand ==
                                                          submodelint)
                                                      .toList();
                                                } else {
                                                  _mainvisible = true;
                                                  _modelvisible = false;
                                                  adsList = maincategorylist;

                                                  subint = 0;
                                                  submodelint = 0;
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: _modelTab == index
                                                      ? kActiveColor
                                                      : kNormalColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Text(
                                                    modelList[index].name,
                                                    style: _modelTab == index
                                                        ? kActiveTextStyle
                                                        : kNormalTextStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                                child: Container(
                                  height: height * 0.05,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: OutlineDropdownButtonFormField(
                                          value: city,
                                          items: citiestemp.map((city) {
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
                                              region = null;
                                              _selectedyearsTo.clear();
                                              cityname = newVal.name;
                                              _cityid = newVal.id;
                                              regions.clear();
                                              regions.addAll(allregions
                                                  .where((sub) =>
                                                      sub.areaId == _cityid)
                                                  .toList());
                                              if (regions.length != 0) {
                                                regionvisible = true;
                                              } else {
                                                regionvisible = false;
                                              }

                                              adsList = ads
                                                  .where((ad) =>
                                                      ad.cityId == _cityid)
                                                  .toList();
                                            });
                                          },
                                          isExpanded: true,
                                          hint: Text(
                                            cityname,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              FontAwesomeIcons.city,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            focusColor: Colors.white,
                                            filled: true,
                                            fillColor: mycolor,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 2.5, 30, 2.5),
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
                                                color: Colors.white,
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
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Visibility(
                                        visible: regionvisible,
                                        child: Expanded(
                                          child: OutlineDropdownButtonFormField(
                                            value: region,
                                            items: regions.map((city) {
                                              return new DropdownMenuItem<
                                                      Regions>(
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
                                            onChanged: (Regions newVal) {
                                              setState(() {
                                                _selectedyearsTo.clear();
                                                regionname = newVal.name;
                                                _regionid = newVal.id;

                                                adsList = ads
                                                    .where((ad) =>
                                                        ad.regionId ==
                                                        _regionid)
                                                    .toList();
                                              });
                                            },
                                            isExpanded: true,
                                            hint: Text(
                                              regionname,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                FontAwesomeIcons.city,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              focusColor: Colors.white,
                                              filled: true,
                                              fillColor: mycolor,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2.5, 30, 2.5),
                                              labelText: 'الحي',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
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
                                                  color: Colors.white,
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                                child: Wrap(
                                  children: <Widget>[
                                    Visibility(
                                      visible: _modelvisible,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 6,
                                                      child: Container(
                                                        height: height * 0.7,
                                                        child: ListView.builder(
                                                            itemCount:
                                                                years.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return new Column(
                                                                children: <
                                                                    Widget>[
                                                                  StatefulBuilder(
                                                                    builder: (context,
                                                                            _setState) =>
                                                                        new CheckboxListTile(
                                                                      title: new Text(
                                                                          years[index]
                                                                              .year),
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading,
                                                                      value: years[
                                                                              index]
                                                                          .input,
                                                                      onChanged:
                                                                          (bool
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          _setState(
                                                                              () {
                                                                            years[index].input =
                                                                                value;
                                                                            if (value ==
                                                                                true) {
                                                                              _selectedyears.add(years[index]);
                                                                            } else {
                                                                              _selectedyears.remove(years[index]);
                                                                            }
                                                                          });
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            MaterialButton(
                                                                onPressed: () {
                                                                  if (_selectedyearsTo
                                                                          .length ==
                                                                      0) {
                                                                    _selectedyearsTo
                                                                        .addAll(
                                                                            _selectedyears);
                                                                    setState(
                                                                        () {
                                                                      subadsList
                                                                          .clear();
                                                                      for (var year
                                                                          in _selectedyears) {
                                                                        subadsList.addAll(ads
                                                                            .where((ad) =>
                                                                                ad.model ==
                                                                                int.parse(year.year))
                                                                            .toList());
                                                                      }

                                                                      adsList =
                                                                          subadsList;

                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  } else {
                                                                    _selectedyearsTo
                                                                        .clear();
                                                                    subadsList
                                                                        .clear();
                                                                    _selectedyearsTo
                                                                        .addAll(
                                                                            _selectedyears);
                                                                    setState(
                                                                        () {
                                                                      if (_selectedyearsTo
                                                                              .length !=
                                                                          0) {
                                                                        for (var year
                                                                            in _selectedyears) {
                                                                          subadsList.addAll(ads
                                                                              .where((ad) => ad.model == int.parse(year.year))
                                                                              .toList());
                                                                        }

                                                                        adsList =
                                                                            subadsList;
                                                                      } else {
                                                                        subadsModelList = ads
                                                                            .where((ad) =>
                                                                                ad.parentId ==
                                                                                select1)
                                                                            .toList();
                                                                        adsList =
                                                                            subadsModelList;
                                                                      }

                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'حسناً',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                )),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                if (_selectedyears
                                                                        .length !=
                                                                    0) {
                                                                  setState(() {
                                                                    _selectedyears
                                                                        .clear();
                                                                    _selectedyearsTo
                                                                        .clear();
                                                                    for (var item
                                                                        in years)
                                                                      item.input =
                                                                          false;
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                'إلغاء',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: mycolor,
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "الموديل",
                                                style: kNormalTextStyle,
                                              ),
                                              Spacer(),
                                              Icon(
                                                FontAwesomeIcons.angleDown,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _modelvisible,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Container(
                                          height: 40,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            primary: true,
                                            shrinkWrap: true,
                                            children: List<Widget>.generate(
                                                _selectedyearsTo
                                                    .length, // place the length of the array here
                                                (int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Chip(
                                                  onDeleted: () {
                                                    setState(() {
                                                      for (var item in years) {
                                                        if (item.id ==
                                                            _selectedyearsTo[
                                                                    index]
                                                                .id) {
                                                          item.input = false;
                                                        }
                                                      }
                                                      subadsList.clear();
                                                      _selectedyearsTo.remove(
                                                          _selectedyearsTo[
                                                              index]);
                                                      _selectedyears.remove(
                                                          _selectedyears[
                                                              index]);
                                                      for (var year
                                                          in _selectedyears) {
                                                        subadsList.addAll(ads
                                                            .where((ad) =>
                                                                ad.model ==
                                                                int.parse(
                                                                    year.year))
                                                            .toList());
                                                      }
                                                      if (_selectedyearsTo
                                                              .length !=
                                                          0) {
                                                        for (var year
                                                            in _selectedyears) {
                                                          subadsList.addAll(ads
                                                              .where((ad) =>
                                                                  ad.model ==
                                                                  int.parse(year
                                                                      .year))
                                                              .toList());
                                                        }

                                                        adsList = subadsList;
                                                      } else {
                                                        subadsModelList = ads
                                                            .where((ad) =>
                                                                ad.parentId ==
                                                                select1)
                                                            .toList();
                                                        adsList =
                                                            subadsModelList;
                                                      }
                                                    });
                                                  },
                                                  label: Text(
                                                      _selectedyearsTo[index]
                                                          .year),
                                                  deleteIcon:
                                                      Icon(Icons.cancel),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        )),
                  ],
              body: RefreshIndicator(
                onRefresh: () {
                  return _future = _refresh();
                },
                child: StreamBuilder(
                    stream: _future.asStream(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            DioError error = snapshot.error;
                            String message = error.message;
                            if (error.type == DioErrorType.CONNECT_TIMEOUT)
                              message = 'Connection Timeout';
                            else if (error.type == DioErrorType.RECEIVE_TIMEOUT)
                              message = 'Receive Timeout';
                            else if (error.type == DioErrorType.RESPONSE)
                              message =
                                  '404 server not found ${error.response.statusCode}';

                            return Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: new ListView(
                                children: <Widget>[
                                  Center(
                                    child: new Text('خطأ في الإتصال بالشبكة '),
                                  ),
                                ],
                              ),
                            );
                          }

                          return adsList.length != 0
                              ? ListView.builder(
                                  itemCount: adsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      color: Colors.transparent,
                                      borderOnForeground: true,
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DetailsScreen(
                                                              ads: adsList[
                                                                  index],
                                                            ))),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        border: Border.all(
                                                            color: mycolor,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInCurve:
                                                              Curves.easeInBack,
                                                          fit: BoxFit.cover,
                                                          width: width,
                                                          height: height * 0.2,
                                                          imageUrl: adsList[index]
                                                                      .images
                                                                      .length !=
                                                                  0
                                                              ? adsList[index]
                                                                  .images[0]
                                                              : adsList[index]
                                                                  .image,
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'images/logo.png',
                                                            height:
                                                                height * 0.2,
                                                            width: width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Container(
                                                        width: width * 0.15,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: mycolor,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Visibility(
                                                                  visible:
                                                                      adsList[index].sold ==
                                                                              0
                                                                          ? false
                                                                          : true,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .ban,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "تم البيع ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                      adsList[index].sold ==
                                                                              0
                                                                          ? true
                                                                          : false,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .checkCircle,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "متاح ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 5, 10, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            adsList[index]
                                                                .title,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: mycolor),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "التقييم",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: mycolor),
                                                          ),
                                                        ),
                                                        RatingBar(
                                                          ignoreGestures: true,
                                                          itemSize:
                                                              height * 0.03,
                                                          initialRating:
                                                              adsList[index]
                                                                  .user
                                                                  .evaluation
                                                                  .toDouble(),
                                                          minRating: 0,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating:
                                                              false,
                                                          itemCount: 5,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            size: 1,
                                                            color: mycolor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .userAlt,
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                adsList[index]
                                                                    .user
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .map,
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                adsList[index]
                                                                    .cityName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .clock,
                                                                color: Colors
                                                                    .white,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                adsList[index]
                                                                    .timeAgo,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Text(
                                              //   adsList[index].body,
                                              //   style: TextStyle(
                                              //       color: Colors.white,
                                              //       fontSize: 12),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: new ListView(
                                    children: <Widget>[
                                      Center(
                                        child: new Text('لا توجد إعلانات '),
                                      ),
                                    ],
                                  ),
                                );
                      }
                    }),
              )),
        ),
      ),
    );
  }
}

//NestedScrollView(headerSliverBuilder: null, body: null),
