import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/emergencymode/blindemegencyUI.dart';
import 'package:front/emergencymode/deafemergencyUI.dart';
import 'package:front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FallDetectorService {
  static StreamSubscription<AccelerometerEvent>? _accelSub;
  static bool _fallDetected = false;

  static const double fallThreshold = 300;

  static void start(BuildContext context) {
    if (_accelSub != null) return; // already running

    _accelSub = accelerometerEvents.listen((event) async {
      final total = event.x * event.x + event.y * event.y + event.z * event.z;

      if (total > fallThreshold && !_fallDetected) {
        _fallDetected = true;
        await _handleFall(context);
        _fallDetected = false;
      }
    });
  }

  static Future<void> _handleFall(BuildContext context) async {
    final user = context.read<UserProvider>();

    if (!user.emergencyEnabled) return;
    if (!context.mounted) return;

    if (user.isBlind) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const BlindEmergencyUI()),
      );
    } else if (user.isDeaf) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const DeafEmergencyUI()),
      );
    }
  }

  static void stop() {
    _accelSub?.cancel();
    _accelSub = null;
  }
}
