import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/assistant/assistantMainPage.dart';
import 'package:front/auth/blind.dart';
import 'package:front/auth/deaf/deaf.dart';
import 'package:front/auth/deaf/switcher.dart';

import 'package:front/auth/login.dart';
import 'package:front/auth/patientsignup.dart';
import 'package:front/auth/signup.dart';
<<<<<<< HEAD
import 'package:front/component/user_provider.dart';
=======
>>>>>>> 544d610f6721af09a68ac3ebdb0e60b28829d7ce
import 'package:front/auth/volunteer/volunteerpage.dart';
import 'package:front/component/user_provider.dart';

import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:front/homepage.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======

>>>>>>> 544d610f6721af09a68ac3ebdb0e60b28829d7ce

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
<<<<<<< HEAD
      home: Login(),  //Assistantmainpage(),
=======
      home:Signup(),   


>>>>>>> 544d610f6721af09a68ac3ebdb0e60b28829d7ce
      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        //"editprofile": (context) => const EditProfile( isPatient: true),
        "viewinfo":(context)=> ViewInfo(),
        "blind": (context) => Blind(),
<<<<<<< HEAD
        "assistant": (context) => Assistantmainpage(),
        "volunteer": (context) => VolunteerHome(),
=======
        "assistant": (context) => AssistantPage(),
        "volunteer": (context) => VolunteerHome(), 
>>>>>>> 544d610f6721af09a68ac3ebdb0e60b28829d7ce
        "deaf": (context) => Deaf(),
        "switcher": (context) => Switcher(),
        "patientsignup": (context) => Patientsignup(),
      },
<<<<<<< HEAD
      
=======

      theme: Provider.of<Themeprovider>(context).themeData,
      darkTheme: darkMode,
>>>>>>> 544d610f6721af09a68ac3ebdb0e60b28829d7ce
    );
  }
}
