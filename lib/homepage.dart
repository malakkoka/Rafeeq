//import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Install'),
        actions: [
          IconButton(
          onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route)=>false);

          },
          icon: Icon(Icons.exit_to_app_sharp),
            
          ),
        ],
      ),
      body: ListView(
        children: [
          // Text("How Are You", style: ),
        ],
      ),
    );
  }
}
