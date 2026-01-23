//import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/customdrawer.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("home page"),
      ),
      drawer: CustomDrawer(),
      body: Container(),
    );
  }
}
