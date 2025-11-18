import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/password.dart';
import 'package:front/component/textform.dart';
import 'package:gap/gap.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
                      color: const Color.fromARGB(255, 201, 171, 226),
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
                                  fontSize: 20,
                                  color: Color(0xff3B1E54),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(16),
                            const Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Gap(12),
                            CustomText(
                              hinttext: "enter your email ",
                              mycontroller: email,
                            ),
                            const Gap(12),
                            const Text(
                              "password",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Gap(12),
                            PasswordField(phint: "Enter your password",
                              mycontroller: password),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              alignment: Alignment.topRight,
                              child: const Text(
                                "forget password ?",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 150, 148, 148),
                                ),
                              ),
                            ),
                            CustomButtonAuth(
                              title: "login",
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: email.text.trim(),
                                    password: password.text,
                                  );
                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .pushReplacementNamed("homepage");
                                } on FirebaseAuthException catch (e) {
                                  debugPrint('Auth code: ${e.code}');
                                  String msg;
                                  switch (e.code) {
                                    case 'invalid-credential':
                                    case 'wrong-password':
                                      msg = 'Incorrect password.';
                                      break;
                                    case 'user-not-found':
                                      msg = 'No user found for this email.';
                                      break;
                                    case 'invalid-email':
                                      msg = 'Invalid email format.';
                                      break;
                                    default:
                                      msg = e.message ??
                                          'Unexpected error occurred.';
                                  }
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Login Error',
                                    desc: msg,
                                    btnOkOnPress: () {},
                                  ).show();
                                } catch (e) {
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'Unexpected error: $e',
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
                                    color: Colors.grey,
                                    thickness: 1,
                                    endIndent: 10,
                                  ),
                                ),
                                Text(
                                  "Or",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    indent: 10,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: MaterialButton(
                                onPressed: () {},
                                color: const Color(0xff4E56C0),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.network(
                                  "https://image.similarpng.com/file/similarpng/very-thumbnail/2020/06/Logo-google-icon-PNG.png",
                                  width: 20,
                                  height: 20,
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
                                      TextSpan(text: "dont have acount? "),
                                      TextSpan(
                                        text: "register ",
                                        style: TextStyle(
                                          color: Color(0xff4E56C0),
                                          fontWeight: FontWeight.bold,
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
