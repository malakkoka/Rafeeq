import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomText extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
    final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const CustomText({super.key, required this.hinttext, required this.mycontroller, this.validator, this.autovalidateMode, this.keyboardType, this.inputFormatters});
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller ,
      validator: validator,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
                      hintText:hinttext ,
                      hintStyle: TextStyle(fontSize: 14,),
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 20),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: const Color.fromARGB(255, 211, 206, 224))
                      )
                    ),);
  }
}