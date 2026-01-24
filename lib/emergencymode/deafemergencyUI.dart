import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/color.dart';

class DeafEmergencyUI extends StatefulWidget {
  const DeafEmergencyUI({super.key});

  @override
  State<DeafEmergencyUI> createState() => _DeafEmergencyUIState();
}

class _DeafEmergencyUIState extends State<DeafEmergencyUI> {
  bool isRed = true;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        isRed = !isRed;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isRed ? Colors.red : Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24),
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "I am OK",
            style: TextStyle(color: AppColors.n1),
          ),
        ),
      ),
    );
  }
}
