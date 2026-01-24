import 'package:flutter/material.dart';
import 'package:front/auth/deaf/deaf.dart';
import 'package:front/auth/deaf/speaker.dart';
import 'package:front/auth/call/vediocall.dart';
import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:gap/gap.dart';


  class Switcher extends StatefulWidget {
    const Switcher({super.key});

  @override
    State<Switcher>createState()=> _Switcherstate();
}

  class _Switcherstate extends State<Switcher>{

    double _turns =0;

    bool isdeaf = true;

    final List<Widget> pages = [
    Deaf(),
    Speaker(),
    Vediocall(),
    ViewInfo()
  ];

    //FloatingActionButtonLocation:FloatingActionButtonLocation.centerdocked


    @override
    Widget build (BuildContext context){
      return Scaffold(
        backgroundColor: AppColors.background,
        body:
          isdeaf? Deaf() : Speaker(),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: AppColors.n4,
            shape: CircleBorder(),
            child: AnimatedRotation(
              turns: _turns,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Icon(Icons.sync,
              color:AppColors.background,),
            ),
            onPressed: () {
              setState(() {
                _turns+=1;
                isdeaf=!isdeaf;
              });
            },
          ),
          floatingActionButtonLocation: 
            FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: SizedBox(
            height: 55,
            child: BottomAppBar(
              color: AppColors.n4,
              shape: CircularNotchedRectangle(),
              elevation: 0,
              notchMargin: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  IconButton(
                    padding: EdgeInsets.only(left:50),
                    icon: Icon(Icons.person,
                    color:AppColors.background,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_)=> ViewInfo()),
                      );
                    },
                  ),
                  Gap(10),
                  IconButton(
                    padding: EdgeInsets.only(right:50),
                    icon: Icon(Icons.video_call,
                    color:AppColors.background,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_)=>Vediocall()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          
      );
    }

  }
