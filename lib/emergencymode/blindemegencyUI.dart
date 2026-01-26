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
  Timer? timer;
  bool isTalking = true; // للتحكم في التحدث
  bool isStable = false; // للتحقق من استقرار الحركة
  bool isEmergencyResolved = false; // لتحديد إذا تم تأكيد الطوارئ

  @override
  void initState() {
    super.initState();
    startSpeaking();
    startListeningToAccelerometer();
  }

  void startSpeaking() {
    // تكرار "I am here" حتى يتم التوقف
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (isTalking) {
        await tts.speak("I am here");
      }
    });
  }

  void startListeningToAccelerometer() {
    accelerometerEvents.listen((event) {
      // حساب التسارع
      final total = event.x * event.x + event.y * event.y + event.z * event.z;

      if (total < 10 && !isStable) {
        // إذا كان التسارع صغيرًا فهذا يعني أن الهاتف ثابت
        setState(() {
          isStable = true;
        });
        stopSpeaking();
        // التحدث بـ "Are you okay? If you are, tap the screen."
        askIfOkay();
      } else if (total > 30 && isStable) {
        // إذا كان التسارع كبيرًا فهذا يعني أن الهاتف بدأ يتحرك
        setState(() {
          isStable = false;
        });
        startSpeaking(); // إعادة التحدث
      }
    });
  }

  void stopSpeaking() {
    setState(() {
      isTalking = false;
    });
    tts.stop(); // إيقاف التحدث عندما يكون الهاتف ثابتًا
  }

  void askIfOkay() {
    tts.speak("Are you okay? If you are, tap the screen.");
  }

  void resolveEmergency() {
    setState(() {
      isEmergencyResolved = true;
    });
    tts.stop();
    Navigator.pop(context); // العودة إلى الصفحة السابقة
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
        if (!isEmergencyResolved) {
          resolveEmergency(); // إنهاء حالة الطوارئ عند الضغط على الشاشة
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: isEmergencyResolved
              ? SizedBox.shrink() // إذا تم حل الطوارئ، لا يظهر شيء
              : isStable
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "If you are okay, tap the screen",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  : const Text(
                      "I am here",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
        ),
      ),
    );
  }
}
