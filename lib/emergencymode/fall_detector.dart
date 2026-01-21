import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/emergencymode/blindemegencyUI.dart';
import 'package:front/emergencymode/deafemergencyUI.dart';
import 'package:front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FallDetector extends StatefulWidget {
  const FallDetector({super.key});

  @override
  State<FallDetector> createState() => _FallDetectorState();
}

class _FallDetectorState extends State<FallDetector> {
  StreamSubscription<AccelerometerEvent>? accelSub;
  bool fallDetected = false;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    try {
      accelSub = accelerometerEvents.listen((event) {
        final total =
            (event.x * event.x) + (event.y * event.y) + (event.z * event.z);

        if (total > 150 && !fallDetected) {
          fallDetected = true;
          handleFall();
        }
      });
    } catch (e) {
      debugPrint("❌ Accelerometer error: $e");
    }
  }

  void handleFall() {
    final user = context.read<UserProvider>();
    if (!user.emergencyEnabled) return;

    if (user.isBlind) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BlindEmergencyUI()),
      );
    } else if (user.isDeaf) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DeafEmergencyUI()),
      );
    }
  }

  @override
  void dispose() {
    accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Monitoring for fall..."),
      ),
    );
  }
}
