import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/country_backmodel.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/models/ownerdetails.dart';
import 'package:dalllalalarab/screens/Autentication/login_page.dart';
import 'package:dalllalalarab/screens/Screens/detailsscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  UserDetails({this.user});
  final user;
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

List<Countries> countries;
List<Cities> cities;
List tempList = List();
List tempListcountries = List();

class _UserDetailsState extends State<UserDetails> {
  double height;
  double width;
  String _profileimage;
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _addreportscaffoldKey = GlobalKey<ScaffoldState>();
  String _countryname = "الدولة";

  String _cityname = "المدينة";

  List<Reviews> reviews;
  Future _future;
  List<Ads> pastPosts;
  double evaluation = 0;
  int userid = 0;

  String ratetext = "التقييم";

  Future<void> _fetchCountries() async {
    final prefs = await SharedPreferences.getInstance();
    var response = prefs.getString("response");
    if (response != null) {
      var f = jsonDecode(response);
      HomeClass data = new HomeClass.fromJson(f);
      countries = data.data.countries;
      cities = data.data.cities;
      setState(() {
        tempListcountries = countries;
        tempList = cities;
      });
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
      _registerscaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<void> _getdata() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt("User_id");
    setState(() {
      var _cityval = cities.where((city) => city.id == widget.user.city).first;
      _cityname = _cityval.name;

      var _countryval =
          countries.where((country) => country.id == widget.user.country).first;
      _countryname = _countryval.name;
    });
  }

  Future<void> _getReviewsdata() async {
    Response response;
    Dio dio = new Dio();
    var url = "https://dalllal.com/json/ownerdetails";
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 30000;
    response = await dio.post(url, data: {"user_id": widget.user.id});

    return response;
  }

  Future<void> _refresh() async {
    Response response;
    Dio dio = new Dio();
    var url = "https://dalllal.com/json/ownerdetails";
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 30000;
    response = await dio.post(url, data: {"user_id": widget.user.id});
    Ownerdetails data = new Ownerdetails.fromJson(response.data);
    if (data.msg == "success") {
      pastPosts = data.data[0].pastPosts;
      for (var item in pastPosts) {
        if (item.user.evaluation == null) {
          item.user.evaluation = 0;
        } else if (item.price == null || item.price == "") {
          item.price = "غير محدد";
        }
      }
      setState(() {
        reviews = data.data[0].reviews;
      });
    }
    return response;
  }

  changetext() {}

  addrate() {
    if (userid != 0) {
      AwesomeDialog(
        context: context,
        customHeader: Text(
          "إضافة تقييم",
          style: TextStyle(color: mycolor),
        ),
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
          bool _isButtonEnabled;
          if (evaluation != 0) {
            _isButtonEnabled = true;
          } else {
            _isButtonEnabled = false;
          }

          var _onPressed;
          if (_isButtonEnabled) {
            _onPressed = () async {
              var result = await Connectivity().checkConnectivity();
              if (result != ConnectivityResult.none) {
                FormData formData = new FormData.fromMap({
                  "owner_id": widget.user.id,
                  "user_id": userid,
                  "evaluation": evaluation,
                });
                Response response = await Dio().post(
                  "https://dalllal.com/json/addrate",
                  data: formData,
                );
                if (response.statusCode == 200) {
                  //  addreport data = new addreport.fromJson(response.data);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    duration: const Duration(milliseconds: 500),
                    content: Text(
                      'تم إضافة التقييم',
                      style: ksnackStyle,
                    ),
                  );

                  // Find the Scaffold in the widget tree and use it to show a SnackBar.
                  _registerscaffoldKey.currentState.showSnackBar(snackBar);
                  _btnController.success();
                }
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
                _registerscaffoldKey.currentState.showSnackBar(snackBar);
                _btnController.reset();
                ratetext = "التقييم";
              }
            };
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: RatingBar(
                  glow: true,
                  itemSize: height * 0.03,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 1,
                    color: mycolor,
                  ),
                  onRatingUpdate: (double value) {
                    _setState(() {
                      evaluation = value;
                      switch (evaluation.toInt()) {
                        case 5:
                          ratetext = "ممتاز";
                          break;
                        case 2:
                          ratetext = "مقبول";
                          break;
                        case 3:
                          ratetext = "جيد";
                          break;
                        case 4:
                          setState(() {
                            ratetext = "جيد جداً";
                          });
                          break;
                        default:
                          ratetext = "سئ";
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Text(ratetext),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: kButtonColor,
                        child: Container(
                          child: Text(
                            'إرسال',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: _onPressed,
                        controller: _btnController,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RoundedLoadingButton(
                        width: width * 0.5,
                        animateOnTap: true,
                        color: Colors.red,
                        child: Container(
                          child: Text(
                            'إلغاء',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      )..show();
    } else {
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
              tittle: 'هذه الخاصية بحاجة لتسجيل الدخول ',
              desc: ' هل تريد تسجيل الدخول ؟ ',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              btnOkOnPress: () {})
          .show();
    }
  }

  @override
  void initState() {
    super.initState();
    this._fetchCountries();
    this._getdata();

    _future = _getReviewsdata();
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
      key: _registerscaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("تفاصيل صاحب الإعلان"),
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
              Container(
                height: height * 0.32,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Container(
                            height: height,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: mycolor, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: mycolor,
                                    child: CircleAvatar(
                                      backgroundImage: _profileimage == null
                                          ? AssetImage('images/user.png')
                                          : NetworkImage(_profileimage),
                                      backgroundColor: Colors.white,
                                      radius: 45,
                                    ),
                                  ),
                                  Row(
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
                                                        widget.user.name != null
                                                            ? widget.user.name
                                                            : "الإسم",
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
                                                      widget.user.email != null
                                                          ? widget.user.email
                                                          : "لا يوجد",
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
                                                    widget.user.phone,
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
                                                  initialRating: widget.user
                                                              .evaluation !=
                                                          null
                                                      ? widget.user.evaluation
                                                          .toDouble()
                                                      : 0,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: height * .3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: mycolor, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            height: height * 0.4,
                            child: FutureBuilder(
                                future: _future,
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
                                        if (error.type ==
                                            DioErrorType.CONNECT_TIMEOUT)
                                          message = 'Connection Timeout';
                                        else if (error.type ==
                                            DioErrorType.RECEIVE_TIMEOUT)
                                          message = 'Receive Timeout';
                                        else if (error.type ==
                                            DioErrorType.RESPONSE)
                                          message =
                                              '404 server not found ${error.response.statusCode}';

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: RefreshIndicator(
                                            displacement: 40,
                                            child: new ListView(
                                              children: <Widget>[
                                                Center(
                                                  child: new Text(
                                                      'خطأ في الإتصال بالشبكة '),
                                                ),
                                              ],
                                            ),
                                            onRefresh: () {
                                              return _future = _refresh();
                                            },
                                          ),
                                        );
                                      }
                                      Response response = snapshot.data;
                                      Ownerdetails data =
                                          new Ownerdetails.fromJson(
                                              response.data);
                                      if (data.msg == "success") {
                                        pastPosts = data.data[0].pastPosts;
                                        for (var item in pastPosts) {
                                          if (item.title == null) {
                                            item.title = "بلا عنوان";
                                          }
                                          if (item.body == null) {
                                            item.body = "بلا تفاصيل";
                                          }
                                          if (item.images.length == 0) {
                                            item.images.insert(
                                                0,
                                                AssetImage('images/bc.jpg')
                                                    .toString());
                                          }
                                          if (item.user.rank == null) {
                                            item.user.rank = 0;
                                          }
                                          if (item.price == null ||
                                              item.price == "") {
                                            item.price = "غير محدد";
                                          }
                                        }
                                        return pastPosts.length != 0
                                            ? ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: pastPosts.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5,
                                                            top: 20,
                                                            right: 5,
                                                            left: 5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        border: Border.all(
                                                            color: mycolor,
                                                            width: 3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      width: width * .7,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 4,
                                                              child: Container(
                                                                height: height *
                                                                    0.2,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      color:
                                                                          mycolor,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        10.0),
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) => DetailsScreen(
                                                                                ads: pastPosts[index],
                                                                              ))),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fadeInCurve:
                                                                        Curves
                                                                            .easeInBack,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width:
                                                                        width,
                                                                    imageUrl: pastPosts[index].images.length !=
                                                                            0
                                                                        ? pastPosts[index].images[
                                                                            0]
                                                                        : pastPosts[index]
                                                                            .image,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'images/bc.jpg',
                                                                      width:
                                                                          width,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                      child: Text(
                                                                          pastPosts[index]
                                                                              .title)),
                                                                  Expanded(
                                                                    child:
                                                                        RatingBar(
                                                                      ignoreGestures:
                                                                          true,
                                                                      itemSize:
                                                                          height *
                                                                              0.03,
                                                                      initialRating: pastPosts[
                                                                              index]
                                                                          .user
                                                                          .evaluation
                                                                          .toDouble(),
                                                                      minRating:
                                                                          0,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          false,
                                                                      itemCount:
                                                                          5,
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        size: 1,
                                                                        color:
                                                                            mycolor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50),
                                                child: new ListView(
                                                  children: <Widget>[
                                                    Center(
                                                      child: new Text(
                                                          'لا توجد إعلانات سابقة '),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      }
                                  }
                                }),
                          ),
                        ],
                      ),
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
                        'الإعلانات السابقة',
                        style: kSizetStyle,
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * .3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: mycolor, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            height: height * 0.4,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: FutureBuilder(
                                      future: _future,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              DioError error = snapshot.error;
                                              String message = error.message;
                                              if (error.type ==
                                                  DioErrorType.CONNECT_TIMEOUT)
                                                message = 'Connection Timeout';
                                              else if (error.type ==
                                                  DioErrorType.RECEIVE_TIMEOUT)
                                                message = 'Receive Timeout';
                                              else if (error.type ==
                                                  DioErrorType.RESPONSE)
                                                message =
                                                    '404 server not found ${error.response.statusCode}';
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50),
                                                child: RefreshIndicator(
                                                    child: new ListView(
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                              'خطأ في الإتصال بالشبكة '),
                                                        ),
                                                      ],
                                                    ),
                                                    onRefresh: () {
                                                      return _future =
                                                          _refresh();
                                                    }),
                                              );
                                            }
                                            Response response = snapshot.data;
                                            Ownerdetails data =
                                                new Ownerdetails.fromJson(
                                                    response.data);
                                            if (data.msg == "success") {
                                              reviews = data.data[0].reviews;
                                              for (var item in reviews) {
                                                if (item.evaluation == null) {
                                                  item.evaluation = 0;
                                                }
                                              }
                                            }
                                            return reviews.length != 0
                                                ? ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: reviews.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                right: 5,
                                                                left: 5),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            border: Border.all(
                                                                color: mycolor,
                                                                width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          width: width * .7,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          FontAwesomeIcons
                                                                              .userAlt,
                                                                          color:
                                                                              Color(0xFF31533A),
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                5),
                                                                        Text(
                                                                          reviews[index].username != null
                                                                              ? reviews[index].username
                                                                              : "بلا إسم",
                                                                          style:
                                                                              kTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          FontAwesomeIcons
                                                                              .clock,
                                                                          color:
                                                                              Color(0xFF31533A),
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          reviews[index].createdAt != null
                                                                              ? reviews[index].createdAt
                                                                              : "",
                                                                          style:
                                                                              kTextStyle,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            "التقييم",
                                                                            style:
                                                                                TextStyle(color: mycolor),
                                                                          ),
                                                                          RatingBar(
                                                                            ignoreGestures:
                                                                                true,
                                                                            itemSize:
                                                                                height * 0.02,
                                                                            initialRating:
                                                                                reviews[index].evaluation.toDouble(),
                                                                            minRating:
                                                                                0,
                                                                            direction:
                                                                                Axis.horizontal,
                                                                            allowHalfRating:
                                                                                false,
                                                                            itemCount:
                                                                                5,
                                                                            itemBuilder: (context, _) =>
                                                                                Icon(
                                                                              Icons.star,
                                                                              size: 1,
                                                                              color: mycolor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(reviews[
                                                                              index]
                                                                          .content),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 50),
                                                    child: new ListView(
                                                      children: <Widget>[
                                                        Center(
                                                          child: new Text(
                                                              'لا توجد تقييمات مسبقة '),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                        }
                                      }),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            addrate();
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text('أضف تقييم'),
                                              SizedBox(width: 5),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFF31533A),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        'التقييمات السابقة',
                        style: kSizetStyle,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
