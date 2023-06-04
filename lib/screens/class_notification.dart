import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications{

  static Future<void> pushNotifications(String title,String body)async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    ;
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,

    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,

    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }


}