import 'package:awesome_dialog/awesome_dialog.dart';
<<<<<<< HEAD
import 'package:front/component/UserProvider.dart';
=======
import 'package:front/color.dart';
>>>>>>> 5e54c68add19fe87d7780c00aaf660a95dfde551
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:front/component/dropdown.dart';
import 'package:front/component/role_fields.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:provider/provider.dart';

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

  // Role selection
  String? selectedRole;
String? disability;


  // Role-specific controllers
  final TextEditingController assistantnumber = TextEditingController();
  final TextEditingController patientAge = TextEditingController();
  final TextEditingController assistage = TextEditingController();
<<<<<<< HEAD
  final TextEditingController assistantDept    = TextEditingController();
  final TextEditingController volunteerage     = TextEditingController();
  final TextEditingController volunteerHours   = TextEditingController();
  //final TextEditingController disability  = TextEditingController();
=======
  final TextEditingController assistantDept = TextEditingController();
  final TextEditingController volunteerage = TextEditingController();
  final TextEditingController volunteerHours = TextEditingController();
>>>>>>> 5e54c68add19fe87d7780c00aaf660a95dfde551
  final TextEditingController repassword = TextEditingController();

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
    assistantDept.dispose();
    volunteerage.dispose();
    volunteerHours.dispose();
    super.dispose();
  }

//api
  Future<Map<String, dynamic>> registerOnDjango() async {
    final url = Uri.parse("http://10.0.2.2:8000/api/account/register/");
    int age = 0;

    if (selectedRole == "patient") {
      age = int.tryParse(patientAge.text.trim()) ?? 0;
    } else if (selectedRole == "assistant") {
      age = int.tryParse(assistage.text.trim()) ?? 0;
    } else if (selectedRole == "volunteer") {
      age = int.tryParse(volunteerage.text.trim()) ?? 0;
    }
    String userType = "patient";

    if (selectedRole == "First Assistant") {
      userType = "assistant";
    } else if (selectedRole == "Volunteer") {
      userType = "volunteer";
    }

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

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    20 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      color: AppColors.inputField,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(10),
                            const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 38,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // First/Last name
                            const Gap(16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("First Name",
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      const Gap(8),
                                      CustomText(
                                        hinttext: "first name",
                                        mycontroller: firstName,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Last Name",
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      const Gap(8),
                                      CustomText(
                                        hinttext: "last name",
                                        mycontroller: lastName,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Email
                            const Gap(16),
                            const Text("Email",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const Gap(8),
                            CustomText(
                              hinttext: "enter your email",
                              mycontroller: email,
                            ),

                            //
                            const Text("User Name",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const Gap(8),
                            CustomText(
                              hinttext: "enter your username",
                              mycontroller: username,
                            ),

                            // Password
                            const Gap(16),
                            const Text("Password",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const Gap(8),
                            PasswordField(
                              phint: "enter your password",
                              mycontroller: password,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return "Password is required";
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),

                            const Gap(16),
                            const Text("Confirm Password",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const Gap(8),
                            PasswordField(
                              phint: "enter your password again",
                              mycontroller: repassword,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return "Please confirm your password";
                                if (v != password.text)
                                  return "Passwords do not match";
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),

                            // Phone
                            const Gap(16),
                            const Text("Phone Number",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const Gap(8),
                            CustomText(
                              hinttext: "enter your phone number",
                              mycontroller: phone,
                            ),

                            // Role dropdown
                            const Gap(16),
                            const Text(
                              "Your Role",
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Gap(8),
                            RoleDropdown(
                              value: selectedRole,
                              onChanged: (v) =>
                                  setState(() => selectedRole = v),
                            ),

                            // Role-specific fields (ONE place)
                            Gap(12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: RoleFields(
                                selectedRole: selectedRole,
                                assistantnumber: assistantnumber,
                                patientAge: patientAge,
                                assistage: assistage,
                                volunteerage: volunteerage,
                               // disability:disability,
                              ),
                            ),

                            // Submit
                            const Gap(20),
                            CustomButtonAuth(
                              title: "Sign Up",
                              onPressed: () async {
                                final result = await registerOnDjango();

                                if (result["success"] == true) {
                                  // Successful
<<<<<<< HEAD
                                  final userProvider =
                                    Provider.of<UserProvider>(context, listen: false);
                                    userProvider.setUser(
                                    name: username.text,
                                    email: email.text,
                                    role: selectedRole!,
                                );
                                  if (selectedRole == "Patient") 
                                  {
                                    if (disability == "blind")
                                    {Navigator.of(context).pushReplacementNamed("blind");}
                                    }
                                  if (selectedRole == "First Assistant") 
                                  {Navigator.of(context).pushReplacementNamed("assistant");}
                                  if (selectedRole == "Volunteer") 
                                  {Navigator.of(context).pushReplacementNamed("homepage");}

=======
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: "Success",
                                    desc: "Account created successfully!",
                                    btnOkOnPress: () {},
                                  ).show();

                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .pushReplacementNamed("login");
>>>>>>> 5e54c68add19fe87d7780c00aaf660a95dfde551
                                } else {
                                  // Error from backend
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    title: "Sign Up Error",
                                    desc: result["message"].toString(),
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                            ),

                            const Gap(12),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("login");
                              },
                              child: const Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Already have an account?",
                                          style: TextStyle(
                                              fontSize: 14.7,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary)),
                                      TextSpan(
                                        text: "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
