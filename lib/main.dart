import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/assistant/assistantpage.dart';
import 'package:front/auth/blind.dart';
import 'package:front/auth/deaf.dart';
import 'package:front/auth/login.dart';
import 'package:front/auth/signup.dart';
import 'package:front/auth/volunteer/volunteerpage.dart';
import 'package:front/component/UserProvider.dart';
import 'package:front/component/editprofile.dart';
import 'package:front/homepage.dart';
import 'package:front/theme/theme.dart';
import 'package:front/theme/themeprovider.dart';
import 'package:provider/provider.dart';
//import 'auth/volunteer/volunteerpage.dart';

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
        ChangeNotifierProvider(create: (_) => Themeprovider()),
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
      debugShowCheckedModeBanner: false,
      // home: FirebaseAuth.instance.currentUser == null ? Login() : Homepage(),
      home: VolunteerHome(),
      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        "editprofile": (context) => const EditProfile(),
        "blind": (context) => Blind(),
        "assistant": (context) => AssistantPage(),
        "volunteer": (context) => VolunteerHome(),
        "deaf": (context) => Deaf(),
      },

      theme: Provider.of<Themeprovider>(context).themeData,
      darkTheme: darkMode,
    );
  }
}
