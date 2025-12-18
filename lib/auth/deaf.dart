import 'package:flutter/material.dart';
import 'package:front/component/customdrawer.dart';


class Deaf extends StatefulWidget {
  const Deaf({super.key});

  @override
  State<Deaf> createState() => _DeafState();
}

class _DeafState extends State<Deaf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deaf User Page"),
      ),
      drawer: CustomDrawer(),
      body: const Center(
        child: Text("Welcome, Deaf User!"),
      ),
    );
  }
}