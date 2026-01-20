

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:front/color.dart';

class Livecall extends StatefulWidget {
  const Livecall({super.key});

  @override
  State<Livecall> createState() => _LivecallState();
}

class _LivecallState extends State<Livecall> {

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
          " Live Call",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: AppColors.n4,
      ),
      
      body:Stack(
        
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
            ),

            Positioned(
              top: 60,
              right: 16,
              child: Container(
                width: 110,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              ),

              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: FloatingActionButton(
                        heroTag: "switch",
                        backgroundColor: AppColors.n4,
                        shape: CircleBorder(),
                        onPressed: (){},
                        child: Icon(Icons.flip_camera_ios,color: AppColors.background,size: 35,),),
                    ),

                      SizedBox(
                        width: 72,
                        height: 72,
                        child: FloatingActionButton(
                        heroTag: "end",
                        backgroundColor: Colors.red,
                        shape: CircleBorder(),
                        onPressed: (){},
                        child: Icon(Icons.call_end_rounded,color: AppColors.background,size: 40,),),
                      ),
                    
                  ],
                ),
                )
          
        ],
      )
    );
  }
}