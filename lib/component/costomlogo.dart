import 'package:flutter/material.dart';
import 'package:front/color.dart';

class Customlogo extends StatelessWidget {
  const Customlogo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
width: double.infinity,
      height: double.infinity,
 color: AppColors.background, // غيري اللون براحتك
      alignment: Alignment.center,
      child: Image.asset(
        "images/refeeqlogo.jpeg",
        width: size.width * 1.9,   // كبريها قد ما بدك
        height: size.height * 1.4, // 👈 هاي المفتاح
        fit: BoxFit.contain,
      ),
    );
  }
}
