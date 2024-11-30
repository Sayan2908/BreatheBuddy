import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class FirebaseNotificationApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> setupFirebase() async {
    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
      // Save the token if needed for server-side communication
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: $message");
      // Handle the incoming message
      showNotification(message);
    });

    _configureLocalNotifications();
    _scheduleDailyNotification();
  }

  void _configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleDailyNotification() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder', // Title
      'Remember to fill the COPD form at least once daily', // Content
      _nextInstanceOfMidnight(), // Schedule daily at midnight
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notification',
          'Daily reminder notification',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfMidnight() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 0, 0);
    return scheduledDate;
  }

  void showNotification(RemoteMessage message) {
    final String title = message.notification?.title ?? 'Reminder';
    final String body = message.notification?.body ??
        'Remember to fill the COPD form at least once daily';

    // Build the notification
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'custom_channel_id',
      'Custom Channel',
      'Custom channel for daily reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Display the notification
    _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }
}
