import 'package:flutter/material.dart';
import 'package:front/color.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.hinttext,
    required this.labeltext,
    this.icondata,
    this.mycontroller,
    this.iconButton,
    this.isPassword,
    this.readonly=false, 
  });

  final String? hinttext;
  final String labeltext;
  final IconData? icondata;
  final TextEditingController? mycontroller;
  final IconButton? iconButton;
  final bool? isPassword;
  final bool readonly;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all( 20),
      child: TextFormField(
        obscureText: widget.isPassword ?? false,
        controller: widget.mycontroller,
        readOnly:widget.readonly,
        
        
        decoration: InputDecoration(
            hintText: widget.hinttext,
            hintStyle: TextStyle(fontSize: 16),
            labelStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkprimary),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            label: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(widget.labeltext,style: TextStyle( color: AppColors.darkprimary),)),
            suffixIcon: widget.iconButton,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 54, 35, 23))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 54, 35, 23),
                  width: 3,
            ),
            ),
      ),
    ),
    
    );
  }
}
