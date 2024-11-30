import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:copdbuddy/pages/doctor_register.dart';
import 'package:copdbuddy/pages/openingpage.dart';
import 'package:copdbuddy/pages/patient_asthmaform.dart';
import 'package:copdbuddy/pages/patient_copdform.dart';
import 'package:copdbuddy/pages/patient_mainscreen.dart';
import 'package:copdbuddy/pages/patient_register.dart';
import 'package:copdbuddy/pages/patientdata.dart';
import 'package:flutter/material.dart';
import 'Services/firebasenotif_api.dart';
import 'pages/patient_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:copdbuddy/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final FirebaseNotificationApi firebaseNotificationApi =
  FirebaseNotificationApi();

  @override
  void initState() {
    super.initState();
    firebaseNotificationApi.setupFirebase(); // Initialize Firebase notifications
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w600),
          bodyText2: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w600),
          headline1: TextStyle(fontFamily: 'Nunito', fontSize: 24, fontWeight: FontWeight.bold),
          // You can add more text styles as needed
        ),
      ),
      home: Welcome(),
    );
  }
}