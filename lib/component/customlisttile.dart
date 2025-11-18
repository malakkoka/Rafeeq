import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.icon,
      required this.color,
      required this.textTitle,
      required this.onTap});
  final IconData icon;
  final String textTitle;
  final Color color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(textTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          )),
      onTap: onTap,
    );
  }
}
