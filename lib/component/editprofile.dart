// ignore_for_file: avoid_print, use_build_context_synchronously

//import 'dart:convert';
import 'package:front/color.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/viewinfo.dart';
import 'package:gap/gap.dart';

import '../component/customtextformfield.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final bool isPatient;
  final UserRole userRole;
  const EditProfile(
      {super.key, 
      this.isPatient = false,
      required this.userRole,
      });

  @override
  State<EditProfile> createState() => _EditprofileState();
}

class _EditprofileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    //getData();
  }

  bool isPasswordHidden = true;
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYzNDQyODMwLCJpYXQiOjE3NjMzNTY0MzAsImp0aSI6IjAwYjVhNzFiZWQ3NzQxOTQ5YWFkYTUzZGJkNjFiYTMwIiwidXNlcl9pZCI6IjUifQ.tg2K8R21ZVUmC9BS6BMS-NBQyNozpOjoXWwSbJlgrxY";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.appbar,
                borderRadius: BorderRadius.circular(20)
              ),
              height:280 ,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.only( left: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.asset( "images/OIP.webp",
                      height: 80,
                      width: 80,
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top:120),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(
                                  "moka",
                                  //textAlign: TextAlign.right, 
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              Text(
                                "moka@gmail.com",
                                //textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
            ),
            Positioned(
              bottom: 0,
              left:0,
              right:0,
              child: Container(
                height:630,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListView(
                  children: [
                    CustomTextFormField(
                  labeltext: "User Name",
                  mycontroller: usernameController,
                  hinttext: "mokakoka",
                  
                ),
                CustomTextFormField(
                  labeltext: "age",
                  mycontroller: usernameController,
                  hinttext: "22",
                  
                ),
                    CustomTextFormField(
                  labeltext: "phone number",
                  mycontroller: phoneNoController,
                  hinttext: "0795461724",
                  
                ),
                
                CustomTextFormField(
                  labeltext: "adress",
                  mycontroller: addressController,
                  hinttext: "amman",
                  
                  
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:100, vertical: 10),
                  child: CustomButtonAuth(title:   "save Changes",
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewInfo()));
                      
                    }),
                )
                  ],
                ),
              ),
            ),
            if (widget.userRole == UserRole.volunteer) ...[
          const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Has driving license?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: hasDrivingLicense,
                onChanged: (value) {
                  setState(() {
                    hasDrivingLicense = value;
          });
        },
      ),
    ],
  ),
]

            
          ],
        ),
      )
    );
  }
}

