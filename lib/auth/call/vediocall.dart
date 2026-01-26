
import 'package:front/auth/call/calling.dart';


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:front/color.dart';


class Vediocall extends StatefulWidget {
  
  const Vediocall({super.key, });

  @override
  State<Vediocall> createState() => _VediocallState();
}

class _VediocallState extends State<Vediocall> {

  String? usertype;

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
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.background,)),
        title: const Text(
          "Vedio Call",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: AppColors.n4,
      ),
      
      body:SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20),
            
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 171, 215, 255),
                  borderRadius: BorderRadius.circular(50),
                ),
                child:IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.support_agent_rounded,
                  size: 50,
                  color: AppColors.n4,),
                ),
              ),
            ),
            Gap(20),
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.60,
                                  child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all( 5),
                                  backgroundColor:AppColors.n10,
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  ),
                                    ),
                            onPressed: (){
                              Navigator.push(
                                context,MaterialPageRoute(builder: (_) => Calling()),
                              );
                            },
                                child: Text(
                                  usertype == "deaf" || usertype == "blind" 
                                  ?"Call my assistant"
                                  :"Call my Patient",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                  color: AppColors.dialogcolor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                                                    ),
                          ),
                        Gap(10),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Divider(
                          color: AppColors.n1,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                              children: [
                                Icon(Icons.history, size: 30, color: Colors.grey),
                                Gap(8),
                                Text("calls history",
                                  style: TextStyle(
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 161, 161, 161)),),
                              ],
                            ),
                          ),
                          Gap(30),
                          Center(
                            child: Text(
                                    "No calls yet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey,fontSize: 16),
                                  ),
                          ),
          ],
        ),
      )
    );
  }
}