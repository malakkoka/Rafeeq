import 'package:flutter/material.dart';
import 'package:front/color.dart';

class CustomButtonAuth extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const CustomButtonAuth({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  MediaQuery.of(context).size.height*0.32,
      
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all( 6),
          backgroundColor:AppColors.n10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.dialogcolor,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
