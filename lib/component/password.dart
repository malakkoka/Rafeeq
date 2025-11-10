import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController mycontroller;
  final String phint;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  const PasswordField(
    {super.key,
      required this.mycontroller,
        required this.phint,
          this.validator,
            this.autovalidateMode
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
        hintText:widget.phint,
        hintStyle: const TextStyle(fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 199, 197, 197)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
      validator:widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
