import 'package:copdbuddy/Services/notification_service.dart';
import 'package:copdbuddy/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AddMedicinePage extends StatefulWidget {
  final String userId;

  const AddMedicinePage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  late String _medicineName;
  late TimeOfDay _selectedTime;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  NotificationServices _notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _initializeNotifications();
    _notificationServices.initialiseNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add medicine',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                onChanged: (value) {
                  _medicineName = value;
                },
              ),
              SizedBox(height: 16),
              Text('Select Time:'),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Select Time'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addMedicine();
                  // _notificationServices.sendNotification("title", "body");
                },
                child: Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _addMedicine() async {
    if (_medicineName.isNotEmpty) {
      await _firebaseFunctions.addMedicine(
        widget.userId,
        _medicineName,
        _selectedTime,
      );

      // Schedule notification for the selected time
      print("job1 done");

      _scheduleNotification();

      Navigator.pop(context);
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    // Initialize timezone
    tz.initializeDatabase([]);

    // Set the default location
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Replace 'your_timezone_here' with the desired timezone.

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _scheduleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'medicines_channel',
      'Medicines Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    final DateTime now = DateTime.now();
    final DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    print("Date time: ${scheduledTime}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to take $_medicineName!',
      'Remember to take your prescribed medicine.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'medication',
    );
    print("last function called");
  }

  Future<void> _onSelectNotification(String? payload) async {
    // Handle notification tap event
    print('Notification tapped with payload: $payload');
  }
}
