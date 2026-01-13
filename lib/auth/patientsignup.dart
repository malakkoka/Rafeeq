//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String? disability; // blind | deaf
  bool? readandwrite;
  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    repassword.dispose();
    super.dispose();
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                    Gap(8),
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
                              onPressed: () async {},),
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
