import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:dalllalalarab/models/mypost.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dalllalalarab/screens/Screens/detailsscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../constants.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

String pagetitle = 'المُفضلة';
final _scaffoldKey = GlobalKey<ScaffoldState>();

class _FavouritesState extends State<Favourites> {
  Future<bool> _onBackPressed() async {
    return await AwesomeDialog(
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
      btnOkOnPress: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomTabbed()),
      ),
    ).show();
  }

  int userid;
  List<Ads> ads = List<Ads>();
  List adsList = List();

  Future _future;
  Future<void> _fetchdata() async {
    var result = await Connectivity().checkConnectivity();
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt("User_id")??0;
    if (userid != 0) {
      if (result != ConnectivityResult.none) {
        Response response;
        Dio dio = new Dio();
        response = await dio.post("https://dalllal.com/json/myfavourites",
            data: {"user_id": userid});
        if (response.statusCode == 200) {
          FavouriteResponse data =
              new FavouriteResponse.fromJson(response.data);
          setState(() {
            for (var item in data.data) {
              ads.add(item.post);
            }
            if (ads.length != 0) {
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
                if (item.user.rank == null) {
                  item.user.rank = 0;
                }
                if (item.price == null || item.price == "") {
                  item.price = "غير محدد";
                }
              }
            }

            adsList = ads;
          });
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 5),
            content: Center(
              child: Text(
                'خطأ في الإتصال بالشبكة , من فضلك تحقق من إتصالك بالإنترنت',
                style: ksnackStyle,
              ),
            ),
          );

          // Find the Scaffold in the widget tree and use it to show a SnackBar.
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _future = this._fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: mycolor, width: 3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white,
                ),
                height: height,
                width: width,
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
                              ? RefreshIndicator(
                                  onRefresh: _fetchdata,
                                  child: ListView.builder(
                                    itemCount: adsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5,
                                            top: 20,
                                            right: 5,
                                            left: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: mycolor, width: 3),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            color: Colors.white,
                                          ),
                                          width: width * .7,
                                          height: height * 0.3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    height: height * 0.2,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                          color: mycolor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      DetailsScreen(
                                                                        ads: adsList[
                                                                            index],
                                                                      ))),
                                                      child: CachedNetworkImage(
                                                        fadeInCurve:
                                                            Curves.easeInBack,
                                                        fit: BoxFit.cover,
                                                        width: width,
                                                        imageUrl: adsList[index]
                                                            .images[0],
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'images/bc.jpg',
                                                          width: width,
                                                          fit: BoxFit.cover,
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
                                                    children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                              adsList[index]
                                                                  .title)),
                                                      Expanded(
                                                        child: RatingBar(
                                                          ignoreGestures: true,
                                                          itemSize:
                                                              height * 0.03,
                                                          initialRating:
                                                              adsList[index]
                                                                  .user
                                                                  .rank
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
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: new ListView(
                                    children: <Widget>[
                                      Center(
                                        child:
                                            new Text('لا توجد إعلانات مفضلة '),
                                      ),
                                    ],
                                  ),
                                );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
