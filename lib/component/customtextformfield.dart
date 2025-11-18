import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.hinttext,
    required this.labeltext,
    this.icondata,
    this.mycontroller,
    this.iconButton,
    this.isPassword,
  });

  final String? hinttext;
  final String labeltext;
  final IconData? icondata;
  final TextEditingController? mycontroller;
  final IconButton? iconButton;
  final bool? isPassword;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText: widget.isPassword ?? false,
        controller: widget.mycontroller,
        decoration: InputDecoration(
            hintText: widget.hinttext,
            hintStyle: TextStyle(fontSize: 14),
            labelStyle: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            label: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(widget.labeltext)),
            suffixIcon: widget.iconButton,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(width: 3, color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 95, 111, 206), width: 3),
            )),
      ),
    );
  }
}
