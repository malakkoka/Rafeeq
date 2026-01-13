import 'package:flutter/material.dart';
import 'package:front/color.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController mycontroller;
  final String phint;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  const PasswordField({
    super.key,
    required this.mycontroller,
    required this.phint,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mycontroller,
      obscureText: !_isVisible,
      decoration: InputDecoration(
        hintText: widget.phint,
        hintStyle: const TextStyle(fontSize: 16, color:Colors.black,),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        filled: true,
        fillColor: AppColors.dialogcolor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.n1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.n1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.n1,
          ),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
