import 'dart:convert';

import 'package:dalllalalarab/models/chat_model.dart';
import 'package:dalllalalarab/models/conversation_model.dart';
import 'package:dalllalalarab/models/notificationmodel.dart';
import 'package:dalllalalarab/utils/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  List<ConversationModel> listChat = [];
  Future<List<NotificationModel>> getListNotificationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(ApiRoutes.allNotifications + "${prefs.getInt("User_id")}");
    return await http.get(
      ApiRoutes.allNotifications + "${prefs.getInt("User_id")}",
//      ApiRoutes.allNotifications + "7",
      headers: {
        "Content-Type": "application/json",
//        "Authorization": "bearer ${prefs.getString('token')}"
      },
    ).then((response) {
      print(response.statusCode.toString());
      print(response.body.toString());
      var jsonValue = json.decode(response.body)['data'];
      print(jsonValue.toString());
      return (jsonValue as List)
          .map((f) => new NotificationModel.fromMap(f))
          .toList();
    });
  }

  setNotificationModelRead(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(ApiRoutes.updateNotifications);
    return Dio()
        .post(
      ApiRoutes.updateNotifications,
      data: FormData.fromMap({
        "notification_id": "$id",
        "user_id": "${prefs.getInt("User_id")}",
//        "user_id": "7",
        "view": "1"
      }),
    )
        .then((value) {
      print(value.data.toString());
    });
  }

  updateOrderStatus(String orderId, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(ApiRoutes.updateOrderStatus);
    print({
      "order_id": "$orderId",
      "user_id": "${prefs.getInt("User_id")}",
      "status": "${status}"
    });
    return Dio()
        .post(
      ApiRoutes.updateOrderStatus,
      data: FormData.fromMap({
        "order_id": "$orderId",
        "user_id": "${prefs.getInt("User_id")}",
        "status": "${status}"
      }),
    )
        .then((value) {
      print(value.data.toString());
    });
  }

  Future<List<ChatModel>> getChatMSGS(int id) async {
    try {
      print(ApiRoutes.getConversationById + "$id");
      return await http.get(
        ApiRoutes.getConversationById + "$id",
//      ApiRoutes.allNotifications + "7",
        headers: {
          "Content-Type": "application/json",
//        "Authorization": "bearer ${prefs.getString('token')}"
        },
      ).then((response) {
        print(response.statusCode.toString());
        print(response.body.toString());
        var jsonValue = json.decode(response.body)['data'];
        print(jsonValue.toString());
        return (jsonValue as List)
            .map((f) => new ChatModel.fromMap(f))
            .toList();
      });
    } catch (e) {}
  }

  Future<bool> addNewMSG(
    String senderID,
    String receiverID,
    String msg,
  ) async {
    print(ApiRoutes.addConversation);
    print({
      "massage": "$msg",
      "sender_id": "$senderID",
      "receiver_id": "$receiverID",
    });
    return Dio()
        .post(
      ApiRoutes.addConversation,
      data: FormData.fromMap({
        "massage": "$msg",
        "sender_id": "$senderID",
        "receiver_id": "$receiverID",
      }),
    )
        .then((value) {
      print(value.data.toString());
      return true;
    });
  }

  Future<bool> addMSG(
    int senderID,
    int receiverID,
    int chatID,
    String msg,
  ) async {
    Map model = {
      "massage": "$msg",
      "type": "0",
      "conversation_id": "$chatID",
      "sender_id": "$senderID",
      "receiver_id": "$receiverID",
    };
    print(model.toString());
    return Dio()
        .post(
      ApiRoutes.addMsg,
      data: FormData.fromMap({
        "massage": "$msg",
        "type": "0",
        "conversation_id": "$chatID",
        "sender_id": "$senderID",
        "receiver_id": "$receiverID",
      }),
    )
        .then((value) {
      print(value.data.toString());
      return true;
    });
  }

  Future<void> getConversationModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var userId = prefs.getInt("User_id") ?? 0;
    Response response = await Dio()
        .get(ApiRoutes.getConversationByUser_id + "$userId");
    ChatResponse data = new ChatResponse.fromJson(response.data);
    listChat = data.data;
    //  print(ApiRoutes.getConversationByUser_id + "${prefs.getInt("User_id")}");
//    print(ApiRoutes.getConversationByUser_id + "10");
//     return await http.get(
//       ApiRoutes.getConversationByUser_id + "${prefs.getInt("User_id")}",
// //      ApiRoutes.getConversationByUser_id + "10",
//       headers: {
//         "Content-Type": "application/json",
// //        "Authorization": "bearer ${prefs.getString('token')}"
//       },
//     ).then((response) {
//       print(response.statusCode.toString());
//       print(response.body.toString());
//       var jsonValue = json.decode(response.body)['data'];
//       print(jsonValue.toString());
//       return (jsonValue as List)
//           .map((f) => new ConversationModel.fromMap(f))
//           .toList();
//     });
  }
}
