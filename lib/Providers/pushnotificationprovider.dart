import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String google_token;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
        _firebaseMessaging.getToken().then((token) async {
     // print(token);
     final prefs = await SharedPreferences.getInstance();
            await prefs.setString("google_token", token);
    });
    
  }

  
}
