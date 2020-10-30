import 'package:after_layout/after_layout.dart';
import 'package:dalllalalarab/models/conversation_model.dart';
import 'package:dalllalalarab/screens/Screens/chat_info.dart';
import 'package:dalllalalarab/services/user_services.dart';
import 'package:dalllalalarab/utils/api_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Chat extends StatefulWidget {
  VoidCallback callback;
  bool isHasBar;
  Chat(this.callback, {this.isHasBar = false});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with AfterLayoutMixin<Chat> {
  List<ConversationModel> list = [];
  bool isLoading = true;
  Future<void> _getnotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("User_id") ?? 0;
    if (userId != 0 && userId != null) {
      UserServices serviceApi = UserServices();
      await serviceApi.getConversationModel();
      setState(() {
        list = serviceApi.listChat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.isHasBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text("الرسائل"),
            ),
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        child: list.length != 0
            ? ListView.builder(
                itemCount: list.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, i) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatInfo(
                                        list[i].id,
                                        list[i].senderId,
                                        list[i].sender.id == userId
                                            ? list[i].receiver.name
                                            : list[i].sender.name, () async {
                                      // list = await UserServices()
                                      //     .getConversationModel();
                                      setState(() {});
                                    })));
                      },
                      child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
//                    color: FixedAssets.backgroundColor2,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
//                                        list[i].sender['name'],
                                              list[i].sender.id == userId
                                                  ? list[i].receiver.name
                                                  : list[i].sender.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kIconColor,
                                                  fontSize: 17),
                                            ),
                                            SizedBox(height: 5),
                                            list[i].lastchat == null ||
                                                    list[i].lastchat.massage ==
                                                        null
                                                ? Container()
                                                : Text(
                                                    "${list[i].lastchat.massage}",
                                                    style: TextStyle(
                                                        color: kIconColor,
                                                        fontSize: 14),
                                                  ),
                                            SizedBox(height: 5),
                                            list[i].lastchat == null ||
                                                    list[i]
                                                            .lastchat
                                                            .createdAt ==
                                                        null
                                                ? Container()
                                                : Text(
                                                    "${DateFormat.yMMMd("ar").format(DateTime.parse(list[i].lastchat.createdAt.toString()))} - ${DateFormat.Hm("ar").format(DateTime.parse(list[i].lastchat.createdAt.toString()))}",
                                                    style: TextStyle(
                                                        color: kIconColor,
                                                        fontSize: 14),
                                                  ),
                                          ]),
                                      Icon(
                                        Icons.brightness_1,
                                        color: list[i].lastchat.view == 0
                                            ? mycolor
                                            : Colors.transparent,
                                      ),
                                      CircleAvatar(
                                        radius: 41,
                                        backgroundColor: mycolor,
                                        child: CircleAvatar(
                                          backgroundImage: list[i]
                                                          .receiver
                                                          .image ==
                                                      null ||
                                                  list[i].sender.image == null
                                              ? AssetImage('images/user.png')
                                              : NetworkImage(
                                                  list[i].sender.id == userId
                                                      ? ApiRoutes.BasicURL +
                                                          list[i].receiver.image
                                                      : ApiRoutes.BasicURL +
                                                          list[i].sender.image),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.white,
                                          radius: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          )),
                    ),
                  );
                })
            : Center(
                child: Text(
                "لا يوجد رسائل",
                style: kNormalTextStyle,
              )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getnotifications();
  }

  int userId = 0;

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    // print("object");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("User_id") ?? 0;
    if (userId != 0) {
      try {
        UserServices serviceApi = UserServices();
        await serviceApi.getConversationModel();

        list = serviceApi.listChat;
        if (list.length != null && list.length != 0) {
          var lastlist = list.where((ad) => ad.lastchat.view == 0).toList();

          itemsClient = badger.setBadge(
              itemsClient, lastlist.length != 0 ? "${lastlist.length}" : "", 3);
        }
      } catch (e) {
        list = [];
        print(e.toString() + " error notification screen");
      }

      isLoading = false;
      widget.callback();
      setState(() {});
    }
  }
}
