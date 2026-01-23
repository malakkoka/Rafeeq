import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BlindEmergencyUI extends StatefulWidget {
  const BlindEmergencyUI({super.key});

  @override
  State<BlindEmergencyUI> createState() => _BlindEmergencyUIState();
}

class _BlindEmergencyUIState extends State<BlindEmergencyUI> {
  final FlutterTts tts = FlutterTts();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startSpeaking();
  }

  void startSpeaking() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      tts.speak("I am here." /*If you are okay, tap the screen."*/);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            "Emergency Mode",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
