import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  final AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings('ic_launcher');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(android: _androidInitializationSettings,);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification ( String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('medicine', 'Take medication', importance: Importance.max, priority: Priority.high);
    print(androidNotificationDetails);
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    print(notificationDetails);
    _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
    print('done');
  }

  void scheduleNotification ( String title , String body ) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('medicine', 'Take medication', importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.periodicallyShow(0, title, body,RepeatInterval.everyMinute, notificationDetails);
  }

}