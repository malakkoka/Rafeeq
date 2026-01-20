//import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/assistant/assistantpage.dart';
import 'package:front/color.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Patientsignup extends StatefulWidget {
  const Patientsignup({super.key});
  


  @override
  State<Patientsignup> createState() => _PatientsignupState();
}

class _PatientsignupState extends State<Patientsignup> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();
  final TextEditingController patientAgeController = TextEditingController();
  String? disability; // blind | deaf
  String? gender ;
  bool? readandwrite;
  @override
  void dispose() {
    patientAgeController.dispose();
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    repassword.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> registerPatient() async {
  final assistantId = await const FlutterSecureStorage().read(key: "assistant_id");
    debugPrint("READ ASSISTANT ID = $assistantId");
  //final token = await const FlutterSecureStorage().read(key: "token");

  final url = Uri.parse('http://138.68.104.187/api/account/register/');

  final age = int.tryParse(patientAgeController.text) ?? 0;

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "username": username.text.trim(),
        "email": email.text.trim(),
        "phone": phone.text.trim(),
        "password": password.text.trim(),
        "user_type": disability, // blind | deaf
        "can_write": readandwrite ?? false,
        "can_speak_with_sign_language": disability == "deaf",
        "assistant": int.parse(assistantId!),
        "age": age,
        "address": "default",
        "gender": gender,
        "is_active": true,
      }),
    );

   // final data = jsonDecode(response.body);
    debugPrint("STATUS = ${response.statusCode}");
    debugPrint("BODY = ${response.body}");

    if (response.statusCode == 201) {
      return {"success": true};
    } else {
      return {"success": false, "message": response.body,};
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.dialogcolor, 
      body: SafeArea(
        child: Column(
          children: [
              Gap(20),
              Text(
                "Patient Sign Up",
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.n1,
                ),
              ),
              Gap(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.background,
                      
                    ),
                    child: ListView(
                      keyboardDismissBehavior: 
                        ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                    _section("Username", username),
                    _section("Email", email),
                    _passwordSection("Password", password),
                    _confirmPasswordSection(),
                    _section("Phone Number", phone),
                    
                    Gap(16),
                    Text(
                      "Patient Type",
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                                    ),
                                    Row(
                      children: [
                        Expanded(child:
                        RadioListTile(
                          title: const Text("Blind"),
                          value: "blind",
                          groupValue: disability,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              disability = v;
                            });
                          },
                        ),
                        ),
                        Expanded(child:
                        RadioListTile(
                          title: const Text("Deaf"),
                          value: "deaf",
                          groupValue: disability,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              disability = v;
                            });
                          },
                        ),
                        ),
                      ],
                    ),
                    Gap(8),
                    if (disability=="deaf")...
                      [
                        Gap(12),
                        Text(
                        "can read and write ? ",
                        style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: 
                        RadioListTile(
                          title: const Text("Yes"),
                          value: true,
                          groupValue: readandwrite,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              readandwrite=v;
                            });
                          },
                        ),
                        ),
                        Expanded(child:
                        RadioListTile(
                          title: const Text("No"),
                          value: false,
                          groupValue: readandwrite,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              readandwrite=v;
                            }
                            );
                          },
                        ),
                        ),
                      ],
                    )
                      ],
                    Gap(8),
                    const Text(
                                  "Age",
                                  style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                                ),
                                const Gap(8),
                                CustomText(
                                  hinttext: "Enter your age",
                                  mycontroller:patientAgeController,
                                  
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                Gap(8),
                    
                    Gap(16),
                    Text(
                      "Gender",
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                                    ),
                    Gap(8),
                    Row(
                      children: [
                        Expanded(child:
                        RadioListTile(
                          title: const Text("Male"),
                          value: "male",
                          groupValue: gender,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              gender = v;
                            });
                          },
                        ),
                        ),
                        Expanded(child:
                        RadioListTile(
                          title: const Text("Female"),
                          value: "female",
                          groupValue: gender,
                          activeColor: AppColors.n10,
                          onChanged: (v){
                            setState(() {
                              gender = v;
                            });
                          },
                        ),
                        ),
                      ],
                    ),
                    
                    
                              ],
                            ),
                  ),
                ),
                      ),
                    ),
                    Gap(20),
                    Container(
                      padding: const EdgeInsets.only(left:10,right:10),
                      width: 250,
                      child: CustomButtonAuth(
                              title: "Sign Up", 
                              onPressed: () async {
                                final result = await registerPatient();
                                if (result["success"] == true) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const AssistantPage()),
                                    );
                                  } else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result["message"].toString())),
                                    );
                                  }
                                },
                                ),
                    ),
                      Gap(60),
                      ],
                    ),
                  ),
                );

  }
Widget _section(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Text(
          label,
          style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        ),
        const Gap(8),
        CustomText(

          hinttext: "Enter ${label.toLowerCase()}",
          mycontroller: controller,
          
        ),
      ],
    );
  }

 /* Widget _labeledField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        CustomText(
          hinttext: label.toLowerCase(),
          mycontroller: controller,
        ),
      ],
    );
  }*/

  Widget _passwordSection(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Text(
          label,
          style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        ),
        const Gap(8),
        PasswordField(
          phint: "Enter password",
          mycontroller: controller,
          validator: (v) =>
              v == null || v.isEmpty ? "Password is required" : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _confirmPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        const Text(
          "Confirm Password",
          style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        ),
        const Gap(8),
        PasswordField(
          phint: "Enter password again",
          mycontroller: repassword,
          validator: (v) {
            if (v == null || v.isEmpty) return "Please confirm your password";
            if (v != password.text) return "Passwords do not match";
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
