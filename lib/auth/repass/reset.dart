import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/password.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Reset extends StatefulWidget{
  const Reset({super.key});

  @override
  State<Reset>createState()=>_Resetstate();

}

class _Resetstate extends State<Reset>{
  

  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();
  late String userEmail;
  
  

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  userEmail = ModalRoute.of(context)!.settings.arguments as String;
}


//================================
Future<void> resetPasswordApi() async {
  print("🔵 Reset Password button clicked");

  print("📧 Email: $userEmail");
  print("🔑 Password: ${password.text}");
  print("🔑 RePassword: ${repassword.text}");

  if (password.text.isEmpty || repassword.text.isEmpty) {
    print("❌ One or more fields are empty");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  if (password.text != repassword.text) {
    print("❌ Passwords do not match");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  final url = Uri.parse(
    "http://138.68.104.187/api/account/reset-password/",
  );

  print("🌐 Sending request to API...");
  print("➡️ URL: $url");

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": userEmail,
        "code": "0000",
        "new_password": password.text.trim(),
      }),
    );

    print("✅ Response received");
    print("📦 Status Code: ${response.statusCode}");
    print("📨 Raw Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("🎉 Password reset SUCCESS");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Success")),
      );

      Navigator.of(context).pushReplacementNamed("login");
    } else {
      print("⚠️ API returned error");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Error from server")),
      );
    }
  } catch (e) {
    print("🔥 EXCEPTION: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Server error")),
    );
  }
}
//============================

  Widget _confirmPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        
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


@override
void initState() {
  super.initState();

}



@override
void dispose() {
  password.dispose();
  repassword.dispose();
  super.dispose();
}

  



  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.dialogcolor,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: SizedBox(
                  width:MediaQuery.of(context).size.width * 0.85,
                  child: Card(
                    color: AppColors.background,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  179, 170, 234, 245),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.lock_reset_outlined,
                              color: AppColors.n1,
                              size: 50,
                            ),
                          ),

                          const Gap(16),

                          Text(
                            'Reset Password',
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: AppColors.n1,
                            ),
                          ),

                          const Gap(10),

                          SizedBox(
                            width: 230,
                            child: Text(
                              "Enter your new password",
                              textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 27, 27, 27),
                              ),
                            ),
                          ),
                          //Gap(10),
                          
                          _passwordSection("Password", password),
                          _confirmPasswordSection(),
                          
                          Gap(40),
                          SizedBox(
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
                            resetPasswordApi();
                          },
                              child: Text(
                                "Reset Password",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                color: AppColors.dialogcolor,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
  );
}


}

  Widget _passwordSection(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        
        const Gap(8),
        PasswordField(
          phint: "Confirm New Password",
          mycontroller: controller,
          validator: (v) =>
              v == null || v.isEmpty ? "Password is required" : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }




