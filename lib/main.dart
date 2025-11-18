import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/auth/editprofile.dart';
import 'package:front/auth/login.dart';
import 'package:front/auth/signup.dart';
import 'package:front/homepage.dart';
import 'package:front/theme/theme.dart';
import 'package:front/theme/themeprovider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp();

  // Theme Provider + MyApp
  runApp(
    ChangeNotifierProvider(
      create: (context) => Themeprovider(),
      child: MyApp(),
),
);
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
      home: FirebaseAuth.instance.currentUser == null ? Login() : Homepage(),
      routes: {
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "signup": (context) => Signup(),
        "editprofile": (context) => EditProfile(),
      },
      theme: Provider.of<Themeprovider>(context).themeData,
      darkTheme: darkMode,
    );
  }
}
