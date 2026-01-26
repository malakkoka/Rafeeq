import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/emergencymode/blindemegencyUI.dart';
import 'package:front/emergencymode/deafemergencyUI.dart';
import 'package:front/main.dart';
import 'package:front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FallDetectorService {
  static StreamSubscription<AccelerometerEvent>? _accelSub;
  static bool _fallDetected = false;

  static const double fallThreshold = 300;

  static void start(BuildContext context) {
    if (_accelSub != null) return;

    _accelSub = accelerometerEvents.listen((event) async {
      final total = event.x * event.x +
          event.y * event.y +
          event.z * event.z;

      if (total > fallThreshold && !_fallDetected) {
        _fallDetected = true;
        _handleFall();
        _fallDetected = false;
      }
    });
  }

  static void _handleFall() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final user = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    if (!user.emergencyEnabled) return;

    if (user.isBlind) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const BlindEmergencyUI(),
        ),
      );
    } else if (user.isDeaf) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const DeafEmergencyUI(),
        ),
      );
    }
  }

  static void stop() {
    _accelSub?.cancel();
    _accelSub = null;
  }
}
