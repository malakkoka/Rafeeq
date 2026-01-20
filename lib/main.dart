import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/assistant/assistantpage.dart';
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
import 'package:front/auth/volunteer/volunteerpage.dart';
import 'package:front/component/user_provider.dart';

import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:front/homepage.dart';

import 'package:provider/provider.dart';


// camera
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  await Firebase.initializeApp();

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
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppColors.background,
      debugShowCheckedModeBanner: false,
      home:   Livecall(),   


      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        //"editprofile": (context) => const EditProfile( isPatient: true),
        "viewinfo":(context)=> ViewInfo(),
        "blind": (context) => Blind(),
        "assistant": (context) => AssistantPage(),
        "volunteer": (context) => VolunteerHome(), 
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
  