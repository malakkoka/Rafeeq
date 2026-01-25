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

  static const double fallThreshold = 220; // 🔥 قيمة منطقية

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    accelSub = accelerometerEvents.listen((event) async {
      final total =
          event.x * event.x + event.y * event.y + event.z * event.z;

      if (total > fallThreshold && !fallDetected) {
        fallDetected = true;
        await handleFall();
        fallDetected = false; // 🔁 جاهز لسقوط جديد
      }
    });
  }

  Future<void> handleFall() async {
    final user = context.read<UserProvider>();

    if (!user.emergencyEnabled) return;

    if (!mounted) return;

    if (user.isBlind) {
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const BlindEmergencyUI()),
      );
    } else if (user.isDeaf) {
      await Navigator.of(context, rootNavigator: true).push(
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
