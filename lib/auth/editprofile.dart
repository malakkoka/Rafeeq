// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import '../component/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

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
    getData();
  }

  bool isPasswordHidden = true;
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYzNDQyODMwLCJpYXQiOjE3NjMzNTY0MzAsImp0aSI6IjAwYjVhNzFiZWQ3NzQxOTQ5YWFkYTUzZGJkNjFiYTMwIiwidXNlcl9pZCI6IjUifQ.tg2K8R21ZVUmC9BS6BMS-NBQyNozpOjoXWwSbJlgrxY";
  final url = "http://10.0.2.2:8000/api/account/users/5/";
  Future<void> getData() async {
    final response = await http.get(Uri.parse(url), headers: {
      "accept": "application/json",
      "Authorization": "Bearer $token",
    });
    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        usernameController.text = data["username"] ?? "";
        emailController.text = data["email"] ?? "";
        phoneNoController.text = data["phone"] ?? "";
        addressController.text = data["address"] ?? "";
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> updateProfile() async {
    final url = Uri.parse("http://10.0.2.2:8000/api/account/users/5/");
    final response = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "username": usernameController.text,
          "address": addressController.text,
          "phone": phoneNoController.text,
          if (passwordController.text.isNotEmpty)
            "password": passwordController.text,
        }));
    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Your information has been updated successfully ✔")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                updateProfile();
              },
              icon: Icon(Icons.check),
              color: Colors.green,
              iconSize: 28,
            ),
          )
        ],
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 20),
                width: 90,
                height: 90,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.asset(
                      "images/OIP.webp",
                      fit: BoxFit.cover,
                    )))
          ],
        ),
        SizedBox(height: 40),
        Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              children: [
                CustomTextFormField(
                  labeltext: "User Name",
                  mycontroller: usernameController,
                ),
                SizedBox(height: 12),
                CustomTextFormField(
                  labeltext: "Address",
                  mycontroller: addressController,
                ),
                SizedBox(height: 12),
                CustomTextFormField(
                  hinttext: "********",
                  labeltext: "Password",
                  mycontroller: passwordController,
                  isPassword: isPasswordHidden,
                  iconButton: IconButton(
                      padding: EdgeInsets.only(right: 20),
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      }),
                ),
                SizedBox(height: 12),
                CustomTextFormField(
                  labeltext: "Phone No",
                  mycontroller: phoneNoController,
                ),
              ]),
        )
      ]),
    );
  }
}
