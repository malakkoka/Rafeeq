import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/UserProvider.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> loginToDjango() async {
  final url = Uri.parse('http://192.168.52.212:8000/api/account/login/');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username.text.trim(),
        "password": password.text.trim(),
      }),
    );

    debugPrint("LOGIN STATUS: ${response.statusCode}");
    debugPrint("LOGIN RAW RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
        if (data["user"] == null) {
        return {
          "success": false,
          "message": "Invalid response: user is null",
        };
      }

      return {
        "success": true,
        "username": data["user"]["username"],
        "email": data["user"]["email"],
        "role": data["user"]["user_type"],
        "token": data["access"],
      };
    } else {
      return {
        "success": false,
        "message": response.body.toString(),
      };
    }
  } catch (e) {
    return {
      "success": false,
      "message": e.toString(),
    };
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                                "Login",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Gap(16),
                            const Text(
                              "Username",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const Gap(5),
                            CustomText(
                              hinttext: "Enter your username",
                              mycontroller: username,
                            ),
                            const Gap(16),
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(5),
                            PasswordField(
                              phint: "Enter your password",
                              mycontroller: password,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2, bottom: 20),
                              alignment: Alignment.topRight,
                              child: const Text(
                                "forgot password?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            CustomButtonAuth(
                              title: "Login",
                              onPressed: () async {
                                final result = await loginToDjango();

                                if (result["success"] == true) {
                                  final userProvider =
                                  Provider.of<UserProvider>(context, listen: false);

                                  userProvider.setUser(
                                  name: result["username"],
                                  email: result["email"],
                                  role: result["role"] ?? '',
                                );

                                if (!mounted) return;
                                if (result["role"] == "blind") {
                                Navigator.of(context)
                                  .pushReplacementNamed("blind");
                            } else if (result["role"] == "assistant") {
                              Navigator.of(context)
                                  .pushReplacementNamed("assistant");
                            } else if (result["role"] == "volunteer") {
                              Navigator.of(context)
                                  .pushReplacementNamed("volunteerpage");
                            } else if (result["role"] == "deaf") {
                              Navigator.of(context)
                                  .pushReplacementNamed("deaf");
                            } 
                              } else {
                                await AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: "Login Error",
                                  desc: result["message"].toString(),
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            },
                          ),
                            const Gap(12),
                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.yellowButton,
                                    thickness: 1.4,
                                  ),
                                ),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.yellowButton,
                                    thickness: 1.4,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            Center(
                              child: SizedBox(
                                width: 170,
                                height: 50,
                                child: MaterialButton(
                                  onPressed: () {},
                                  color: AppColors.accent,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.asset(
                                    "images/googleImage.webp",
                                    width: 43,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(12),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("signup");
                              },
                              child: const Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Don't have an account? ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Sign Up",
                                        style: TextStyle(
                                          fontSize: 15.5,
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