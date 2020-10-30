class ApiRoutes {
  static const String BasicURL = "https://dalllal.com/";
  static const String api = BasicURL + "json/";
  static const String allNotifications = api + "allnotifications?user_id=";
  static const String updateNotifications = api + "updateNotificationView";
  static const String getConversationById =
      api + "getConversationById?conversation_id=";
  static const String addConversation = api + "addConversation";
  static const String updateOrderStatus = api + "updateOrderStatus";
  static const String addMsg = api + "addMassage";
  static const String getConversationByUser_id =
      api + "getConversationByUser_id?user_id=";
}
