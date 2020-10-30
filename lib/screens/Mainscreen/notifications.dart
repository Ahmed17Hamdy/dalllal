import 'package:after_layout/after_layout.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/constants.dart';
import 'package:dalllalalarab/models/modelnotification.dart';
import 'package:dalllalalarab/models/showpost.dart';
import 'package:dalllalalarab/screens/Screens/detailsscreen.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  VoidCallback callback;

  Notifications(this.callback);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AfterLayoutMixin<Notifications> {
  List notifiMessage = List();
  String userName = 'test';

  int userid;

  List<Notificationsdetails> notifications;
  Future<void> _getdata() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getInt("User_id");
      //  var token = prefs.getString("google_token");
      if (userid == null) {
        userid = 0;
      }
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _getnotifications() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      // await Future.delayed(Duration(milliseconds: 5000));

      userid = prefs.getInt("User_id") ?? 0;

      response = await dio.post("https://dalllal.com/json/notifications",
          data: {"owner_id": userid});
      if (response.statusCode == 200) {
        ModelNotification data = new ModelNotification.fromJson(response.data);
        if (data.msg == "success") {
          notifications = data.data;
          notifiMessage = notifications;
        } else {
          setState(() {
            final snackBar = SnackBar(
              backgroundColor: Colors.orange,
              duration: const Duration(milliseconds: 500),
              content: Text(
                'من فضلك تأكد من البيانات المطلوبة',
                style: ksnackStyle,
              ),
            );

            // Find the Scaffold in the widget tree and use it to show a SnackBar.
            _scaffoldKey.currentState.showSnackBar(snackBar);
          });
        }
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
    }
  }

  @override
  void initState() {
    super.initState();
    _getnotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        child: notifiMessage.length != 0
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var result = await Connectivity().checkConnectivity();
                      if (result != ConnectivityResult.none) {
                        if (userid != 0 && userid != null) {
                          Response response;
                          Dio dio = new Dio();
                          dio.options.connectTimeout = 5000;
                          dio.options.receiveTimeout = 30000;
                          response = await dio
                              .post("https://dalllal.com/json/showpost", data: {
                            "post_id": notifiMessage[index].postId,
                            "user_id": userid
                          });

                          Showpost data = new Showpost.fromJson(response.data);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailsScreen(
                                        ads: data.data[0].post,
                                      )));

                          return response;
                        }
                      }
                    },
                    child: Card(
                      color: Color(0xFFDDB871),
                      borderOnForeground: true,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'images/logo.jpg',
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    notifiMessage[index].title,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              notifiMessage[index].body,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 5,
                    ),
                itemCount: notifiMessage.length)
            : Center(
                child: Text(
                "لا يوجد إشعارات",
                style: kNormalTextStyle,
              )),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    // print("object");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt("User_id") ?? 0;
    if (userid != 0) {
      try {
        // UserServices serviceApi = UserServices();
        // await serviceApi.getConversationModel();
        await _getnotifications();
        //    notifiMessage = serviceApi.listChat;
        if (notifications != null && notifications.length != 0) {
          var lastlist = notifications.where((ad) => ad.view == 0).toList();

          itemsClient = badger.setBadge(
              itemsClient, lastlist.length != 0 ? "${lastlist.length}" : "", 2);
        }
      } catch (e) {
        notifiMessage = [];
        print(e.toString() + " error notification screen");
      }

      //isLoading = false;
      widget.callback();
      setState(() {});
    }
  }
}
