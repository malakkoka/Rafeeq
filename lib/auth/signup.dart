import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController lastName  = TextEditingController();
  final TextEditingController email     = TextEditingController();
  final TextEditingController phone     = TextEditingController();
  final TextEditingController password  = TextEditingController();

  // Role selection
  String? selectedRole;

  // Role-specific controllers
  final TextEditingController assistantnumber        = TextEditingController();
  final TextEditingController patientAge       = TextEditingController();
  final TextEditingController assistage = TextEditingController();
  final TextEditingController assistantDept    = TextEditingController();
  final TextEditingController volunteerOrg     = TextEditingController();
  final TextEditingController volunteerHours   = TextEditingController();
  final TextEditingController repassword = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    repassword.dispose();
    assistantnumber.dispose();
    patientAge.dispose();
    assistage.dispose();
    assistantDept.dispose();
    volunteerOrg.dispose();
    volunteerHours.dispose();
    super.dispose();
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
                    20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom,
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
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff3B1E54),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // First/Last name
                            const Gap(16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("First Name",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const Gap(8),
                                      CustomText(
                                        hinttext: "enter your first name",
                                        mycontroller: firstName,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Last Name",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const Gap(8),
                                      CustomText(
                                        hinttext: "enter your last name",
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
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            CustomText(
                              hinttext: "enter your email",
                              mycontroller: email,
                            ),

                            // Password
                            const Gap(16),
                            const Text("Password",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            PasswordField(
                              phint: "Enter your password",
                              mycontroller: password,
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Password is required";
                                return null;
                                },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),

const Gap(16),
                            const Text("conform Password",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            PasswordField(phint: "Re-Enter your password",
                              mycontroller: repassword,
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Please confirm your password";
                                if (v != password.text) return "Passwords do not match";
                                return null;
                                  },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),
                            
                            // Phone
                            const Gap(16),
                            const Text("Phone number",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Gap(8),
                            CustomText(
                              hinttext: "enter your phone number",
                              mycontroller: phone,
                            ),

                            // Role dropdown
                            const Gap(16),
                            const Text(
                              "Who are you",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Gap(8),
                            RoleDropdown(
                              value: selectedRole,
                              onChanged: (v) => setState(() => selectedRole = v),
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
                                assistantDept: assistantDept,
                                volunteerage: volunteerOrg,
                                volunteerHours: volunteerHours,
                              ),
                            ),

                            // Submit
                            const Gap(20),
                            CustomButtonAuth(
                              title: "Sign Up",
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
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
                                    case 'email-already-in-use':
                                      msg = 'This email is already in use.';
                                      break;
                                    case 'invalid-email':
                                      msg = 'Invalid email format.';
                                      break;
                                    case 'weak-password':
                                      msg = 'Password is too weak.';
                                      break;
                                    default:
                                      msg = e.message ??
                                          'Unexpected error occurred.';
                                  }
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Sign Up Error',
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
                                          text: "Already have an account? "),
                                      TextSpan(
                                        text: "Login",
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
