import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/assistant/mainNavBar.dart';
import 'package:front/auth/blind.dart';
import 'package:front/auth/deaf/deaf.dart';
import 'package:front/auth/call/livecall.dart';
import 'package:front/auth/deaf/switcher.dart';
import 'package:front/auth/call/vediocall.dart';
import 'package:front/auth/repass/forgot.dart';

import 'package:front/auth/login.dart';
import 'package:front/auth/patientsignup.dart';
import 'package:front/auth/repass/getcode.dart';
import 'package:front/auth/repass/reset.dart';
import 'package:front/auth/signup.dart';
import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:front/emergencymode/blindemegencyUI.dart';
import 'package:front/emergencymode/deafemergencyUI.dart';
import 'package:front/homepage.dart';
import 'package:front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// camera
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(' Background Message: ${message.messageId}');
} // عشان تشتغل الاشعارات لما التطبيق يسكر

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _initFirebaseMessaging();
    /*FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });*/
  }

  Future<void> _initFirebaseMessaging() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    print("FCM TOKEN: $token");

    if (token != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setDeviceToken(token);
    }

    await FirebaseMessaging.instance.subscribeToTopic("test");
    print("Subscribed to topic: test");

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setDeviceToken(newToken);

      // إذا اليوزر عامل login → ابعت update للباك
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppColors.background,
      debugShowCheckedModeBanner: false,
      home: Signup(),
      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        //"editprofile": (context) => const EditProfile( isPatient: true),
        "viewinfo": (context) => ViewInfo(),
        "blind": (context) => Blind(),
        "assistant": (context) => const MainNavigationPage(
              role: UserRole.assistant,
            ),

        "volunteer": (context) => const MainNavigationPage(
              role: UserRole.volunteer,
            ),

        "deaf": (context) => Deaf(),
        "switcher": (context) => Switcher(),
        "patientsignup": (context) => Patientsignup(),
        "forgot": (context) => Forgot(),
        "getcode": (context) => Getcode(),
        "reset": (context) => Reset(),
        "Vediocall": (context) => Vediocall(),
        "livecall": (context) => Livecall(),
      },
    );
  }
}
