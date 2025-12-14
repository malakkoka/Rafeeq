import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/auth/assistant.dart';
import 'package:front/auth/blind.dart';
import 'package:front/auth/editprofile.dart';
import 'package:front/auth/login.dart';
import 'package:front/auth/signup.dart';
import 'package:front/component/UserProvider.dart';
import 'package:front/homepage.dart';
import 'package:front/theme/theme.dart';
import 'package:front/theme/themeprovider.dart';
import 'package:provider/provider.dart';
import 'auth/volunteer/volunteerpage.dart';

//import 'package:front/emergencymode/fall_detector.dart';
//import 'package:front/emergencymode/user_type.dart';


//camera imp.
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  // Firebase initialization
  await Firebase.initializeApp();

  // Theme Provider + MyApp
<<<<<<< HEAD
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Themeprovider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ),
);
=======
  runApp(
    ChangeNotifierProvider(
      create: (context) => Themeprovider(),
      child: MyApp(),
    ),
  );
>>>>>>> 5e54c68add19fe87d7780c00aaf660a95dfde551
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

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
      home: Login(),

      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        "editprofile": (context) => EditProfile(),
        "blind": (context) => Blind(),
<<<<<<< HEAD
        "assistent": (context) => Assistent(),

=======
>>>>>>> 5e54c68add19fe87d7780c00aaf660a95dfde551
      },
      theme: Provider.of<Themeprovider>(context).themeData,
      darkTheme: darkMode,
    );
  }
}
