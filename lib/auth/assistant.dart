import 'package:flutter/material.dart';
import 'package:front/component/customdrawer.dart';
class Assistent extends StatefulWidget {
  const Assistent({super.key});

  @override
  State<Assistent> createState() => _AssistentState();
}
class _AssistentState extends State<Assistent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assistent Page"),
      ),
      drawer: CustomDrawer(),
      body:Container(),
    );
  }
}