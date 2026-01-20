import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:front/auth/patientsignup.dart';
import 'package:front/color.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:front/component/dropdown.dart';
import 'package:front/component/role_fields.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:front/component/custom_button_auth.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Basic controllers
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();

  // Role selection
  String? selectedRole;
   String? disability;

  // Role-specific controllers
  final TextEditingController assistantnumber = TextEditingController();
  final TextEditingController patientAge = TextEditingController();
  final TextEditingController assistage = TextEditingController();
  final TextEditingController volunteerage = TextEditingController();
  
  


  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    username.dispose();
    phone.dispose();
    password.dispose();
    repassword.dispose();
    assistantnumber.dispose();
    patientAge.dispose();
    assistage.dispose();
    volunteerage.dispose();
  
    super.dispose();
  }

  // API
  Future<Map<String, dynamic>> registerOnDjango() async {
    final url = Uri.parse('http://138.68.104.187/api/account/register/');
    int age = 0;



    if (selectedRole == "Patient") {
      age = int.tryParse(patientAge.text.trim()) ?? 0;
    } else if (selectedRole == "Assistant") {
      age = int.tryParse(assistage.text.trim()) ?? 0;
    } else if (selectedRole == "Volunteer") {
      age = int.tryParse(volunteerage.text.trim()) ?? 0;
    }

    String userType = "blind";
    if (selectedRole == "Assistant") {
      userType = "assistant";
    } else if (selectedRole == "Volunteer") {
      userType = "volunteer";
    }
    if (selectedRole == "Patient") {
      userType = disability??"blind";}

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username.text.trim(),
          "email": email.text.trim(),
          "phone": phone.text.trim(),
          "age": age,
          "address": "default",
          "gender": "female",
          "can_write": true,
          "can_speak_with_sign_language": false,
          "is_active": true,
          "user_type": userType,
          "password": password.text.trim(),
          
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["Isuccess"] == true) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

//=============هاي الداله بتسجل دخول عشان ناخد التوكين ============

  Future<String?> loginandtoken()async{
    final url =Uri.parse("http://138.68.104.187/api/account/login/");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "username":username.text.trim(),
          "password":password.text.trim(),
        }),
      );

      final data =jsonDecode(response.body);

      if (response.statusCode == 200 && data["access"] != null) {
      return data["access"]; 
    }
    else {
      return null;
    }
    }
  catch (e) {
    return null;
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
              Center(
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: AppColors.n1,
                ),
              ),
            ),
            Gap(10),
            Expanded(
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    
                  ),
                child: Card(
                  
                  child: Container(
                  
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.background,
                      
                    ),
                    child: ListView(
                      
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      
                      children: [
                    _section("Username", username),
                    _section("Email", email),
                    _passwordSection("Password", password),
                    _confirmPasswordSection(),
                    _section("Phone Number", phone),
                    Gap(16),
                    const Text(
                      "Your Role",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Gap(8),
                    RoleDropdown(
                      value: selectedRole,
                      onChanged: (v) =>
                          setState(() => selectedRole = v),
                    ),
                    Gap(12),
                    RoleFields(
                      selectedRole: selectedRole,
                      assistantnumber: assistantnumber,
                      patientAge: patientAge,
                      assistage: assistage,
                      volunteerage: volunteerage,
                    ),
                    
                    
                    
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Gap(20),
                    SizedBox(
                      width: 300,
                      child: CustomButtonAuth(
                                  title: "Sign Up", 
                                  onPressed: () async { 
                                      final result = await registerOnDjango();
                                      
                                      if (result["success"] == true){
                                        final userData = result["data"]["user"];
                                        final role = selectedRole;
                                        //بجيب التوكين 
                                      //  final token = await loginandtoken();

                                      //  if (token == null){
                                        //  ScaffoldMessenger.of(context).showSnackBar(
                                          //  const SnackBar(content: Text("Login failed after signup")),
                                        //  );
                                       //   return;
                                       // }
                                        //بخزن التوكين 
                                       // await const FlutterSecureStorage().write(
                                        //  key: "token",
                                        //  value: token,
                                      //  );
                                        
                                        if (role == "Assistant"){
                                          final assistantId = userData["id"];
                                          await const FlutterSecureStorage().write(
                                          key: "assistant_id",
                                          value: assistantId.toString(),
                                        );

                                        if (!mounted) return;
                                        Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (_) => const Patientsignup()),
                                      );
                                        }
                                        else{
                                          if (!mounted) return;
                                          Navigator.of(context).pushReplacementNamed("volunteerpage");
                                        }
                                      }else{
                                        await  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          desc: result["message"].toString(),
                                          btnOkOnPress: () {},
                                          ).show();
                                      }
                                      }, ),
                    ),
                                            const Gap(12),
                              InkWell(
                                onTap: () =>
                                    Navigator.of(context).pushReplacementNamed("login"),
                                child: const Center(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Already have an account? ",
                                          style: TextStyle(
                                            fontSize: 14.7,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.n1,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(12),
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

          hinttext: "Enter your ${label.toLowerCase()}",
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
          phint: "Enter your password",
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
          phint: "Enter your password again",
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
