import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:front/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:front/color.dart';

class Calling extends StatefulWidget {
  const Calling({super.key});

  @override
  State<Calling> createState() => _CallingState();
}

class _CallingState extends State<Calling> {

  bool isConnected = true;
  bool isCameraOn = true;
  bool isMicOn = true;




@override
  void initState(){
    super.initState();
    
  }

//====================ui==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          " Calling",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: AppColors.n4,
      ),
      
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(flex: 1,),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.support_agent,
                        size: 50,
                        color: AppColors.n4,
                      ),
                    ),
                    Gap(40),
                    Text("Calling your assistant...",
                    style: TextStyle(fontSize: 18,color:Colors.black.withOpacity(0.7), ),
                    ),
                    Spacer(flex: 2,)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(18),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Icon(Icons.call_end, size: 40,color: AppColors.background,),
                ), 
            ),
        ],
      )
    );
  }
}