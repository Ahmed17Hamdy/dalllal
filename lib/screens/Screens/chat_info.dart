import 'package:after_layout/after_layout.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/models/chat_model.dart';
import 'package:dalllalalarab/services/user_services.dart';
import 'package:dalllalalarab/utils/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ChatInfo extends StatefulWidget {
  int chatId;
  int receiverID;
  String name;
  VoidCallback callback;
  ChatInfo(this.chatId, this.receiverID, this.name, this.callback);

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> with AfterLayoutMixin<ChatInfo> {
  List<ChatModel> list;
  bool isLoading = true;
  final TextEditingController _textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int userid = 0;
  Future<void> _updatechat() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Response response;
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      // await Future.delayed(Duration(milliseconds: 5000));

      userid = prefs.getInt("User_id");

      response = await dio.post("https://dalllal.com/json/updatechat",
          data: {"chat_id": widget.chatId});
      if (response.statusCode == 200) {
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
  }

  @override
  void initState() {
    super.initState();
    _updatechat();
  }

  @override
  void dispose() {
    super.dispose();
    widget.callback();
  }

  _ChatInfoState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.name}"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: isLoading
                ? Container()
                : ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    reverse: true,
//                      primary: true,
                    controller: scrollController ?? null,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, i) {
                      return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                          child: list[i].senderId == userid
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
//                    color: FixedAssets.backgroundColor2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          list[i].massage ?? "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: kIconColor,
                                                              fontSize: 17),
                                                        ),
                                                        list[i].file == null
                                                            ? Container()
                                                            : Image.network(
                                                                ApiRoutes
                                                                        .BasicURL +
                                                                    list[i]
                                                                        .file,
                                                                height: 80,
                                                                width: 80,
                                                              ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Text(
                                                              "${DateFormat.yMMMd("ar").format(list[i].createdAt)} - ${DateFormat.Hm("ar").format(list[i].createdAt)}",
                                                              style: TextStyle(
                                                                  color:
                                                                      kIconColor,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Card(
                                          color: Colors.grey,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
//                    color: FixedAssets.backgroundColor2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Text(
                                                          list[i].massage ?? "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17),
                                                        ),
                                                        list[i].file == null
                                                            ? Container()
                                                            : Image.network(
                                                                ApiRoutes
                                                                        .BasicURL +
                                                                    list[i]
                                                                        .file,
                                                                height: 80,
                                                                width: 80,
                                                              ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "${DateFormat.yMMMd("ar").format(list[i].createdAt)} - ${DateFormat.Hm("ar").format(list[i].createdAt)}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ]),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ));
                    }),
          ),
          Container(
//                  margin: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: kMyColor,
            ),
            child: _textComposerWidget(context),
            //
          ),
        ],
      ),
    );
  }

  Widget _textComposerWidget(context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 6,
            child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    color: Color(0xff3F4148),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 0.5, color: Colors.grey)),
                child: Row(children: <Widget>[
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextField(
                              controller: _textController,
                              style: TextStyle(color: Colors.white),
                              maxLines: 6,
                              minLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Color(0xffC8C8C8)),
                                  hintText: "ارسال الرساله"),
                              onSubmitted: (s) => sendChatMessage())))
                ]))),
        Expanded(
            flex: 1,
            child: Container(
//              height: AppTheme.height(8),
//              width: AppTheme.width(8),
                height: 60,
                width: 600,
                child: InkWell(
                    child: Card(
                      color: kButtonColor,
                      shape: CircleBorder(),
                      child: Icon(Icons.send, size: 20, color: Colors.white),
                    ),
                    onTap: () {
                      if (_textController.text.isNotEmpty &&
                              _textController.text != null ||
                          _textController.text.trim().length != 0) {
                        sendChatMessage().then((f) {});
                      }
                    })))
      ],
    );
  }

  Future<void> sendChatMessage() async {
    print("sadads");

    list.insert(
        0,
        ChatModel(
            massage: _textController.text,
            senderId: userid,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);

      UserServices().addMSG(list[0].senderId, widget.receiverID, widget.chatId,
          _textController.text);
      _textController.clear();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      });
    });
    setState(() {});
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    list = await UserServices().getChatMSGS(widget.chatId);
    list = list.reversed.toList();
    isLoading = false;
    setState(() {});
  }
}
