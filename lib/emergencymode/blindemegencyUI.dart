import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BlindEmergencyUI extends StatefulWidget {
  const BlindEmergencyUI({super.key});

  @override
  State<BlindEmergencyUI> createState() => _BlindEmergencyUIState();
}

class _BlindEmergencyUIState extends State<BlindEmergencyUI> {
  final FlutterTts tts = FlutterTts();

  StreamSubscription? accelerometerSub;
  Timer? speakingTimer;
  Timer? emergencyTimer;

  bool emergencyActive = false;
  bool movementDetectedAfterFall = false;
  bool awaitingUserConfirmation = false;

  static const double fallThreshold = 40; // تسارع قوي = سقوط
  static const Duration speakingDuration = Duration(seconds: 45);
  static const Duration speakInterval = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _configureTts();
    _listenToAccelerometer();
  }

  /// إعدادات الصوت – مهمة جدًا للكفيف
  Future<void> _configureTts() async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.45); // أبطأ من الطبيعي
    await tts.setVolume(1.0); // أعلى صوت
    await tts.setPitch(1.0); // نبرة طبيعية
  }

  /// مراقبة التسارع
  void _listenToAccelerometer() {
    accelerometerSub = accelerometerEvents.listen((event) {
      final double total =
          event.x * event.x + event.y * event.y + event.z * event.z;

      // اشتباه سقوط
      if (total > fallThreshold && !emergencyActive) {
        _startEmergencyFlow();
      }

      // حركة بعد السقوط
      if (emergencyActive &&
          !movementDetectedAfterFall &&
          total > 15) {
        movementDetectedAfterFall = true;
        _onPhoneFound();
      }
    });
  }

  /// بدء وضع الطوارئ
  void _startEmergencyFlow() {
    emergencyActive = true;
    movementDetectedAfterFall = false;

    _startSpeakingIamHere();

    // عدّاد 45 ثانية
    emergencyTimer = Timer(speakingDuration, () {
      if (!movementDetectedAfterFall) {
        _triggerEmergency();
      }
    });
  }

  /// تكرار "I am here"
  void _startSpeakingIamHere() {
    speakingTimer =
        Timer.periodic(speakInterval, (_) async {
      await tts.speak("I am here");
    });
  }

  /// عند العثور على الهاتف
  void _onPhoneFound() {
    speakingTimer?.cancel();
    emergencyTimer?.cancel();

    awaitingUserConfirmation = true;

    tts.speak(
      "If you are okay, tap the screen now.",
    );

    // انتظار ضغط المستخدم (10 ثواني مثلاً)
    Timer(const Duration(seconds: 10), () {
      if (awaitingUserConfirmation) {
        _triggerEmergency();
      }
    });
  }

  /// المستخدم أكد أنه بخير
  void _resolveEmergency() {
    awaitingUserConfirmation = false;
    emergencyActive = false;

    tts.stop();

    Navigator.pop(context);
  }

  /// تصعيد الطوارئ (إشعار المساعد)
  void _triggerEmergency() {
    awaitingUserConfirmation = false;
    emergencyActive = false;

    tts.stop();

    // TODO: هنا ترسل إشعار للمساعد (API / Firebase / SMS)
    // مثال:
    // sendEmergencyNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Emergency alert sent to assistant"),
        ),
      );
    }
  }

  @override
  void dispose() {
    accelerometerSub?.cancel();
    speakingTimer?.cancel();
    emergencyTimer?.cancel();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (awaitingUserConfirmation) {
          _resolveEmergency();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            emergencyActive
                ? "Emergency mode active"
                : "Monitoring...",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
