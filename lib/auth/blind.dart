import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/main.dart';
import 'package:front/component/customdrawer.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';
class Blind extends StatefulWidget {
  const Blind({super.key});

  @override
  State<Blind> createState() => _BlindState();
}

class _BlindState extends State<Blind> {
  late CameraController controller;
  bool isReady = false;

//sound
  final FlutterTts tts = FlutterTts();
  bool isSpeaking = false; 

  @override
  void initState() {
    super.initState();
    initCamera();
    setupTTS();
  }

  Future<void> setupTTS() async {
  //stop waive
    tts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> speakText(String text) async {
    setState(() {
      isSpeaking = true; //waivestart
    });
    await tts.speak(text);
  }

  Future<void> initCamera() async {
    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
      
    );

    await controller.initialize();
    if (!mounted) return;

    setState(() => isReady = true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
      return  Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 85, 82),
          title: const Text("blind interface"),
        ),
            body: Stack(
        alignment: Alignment.center,
        children: [
          // الكاميرا
          isReady
              ? Center(
                  child: Container(
                    width: 350,
                    height: 550,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 145, 143, 143),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 145, 143, 143),
                          blurRadius: 15,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(controller),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),

          // دائرة الموجات أسفل الشاشة
          Positioned(
            bottom: 30,
            child: AvatarGlow(
              glowColor: const Color.fromARGB(255, 35, 85, 82),
              animate: isSpeaking,
              duration: const Duration(milliseconds: 1500),
              glowShape: BoxShape.circle,
              child: Material(
                elevation: 5,
                shape: const CircleBorder(),
                color: const Color.fromARGB(255, 35, 85, 82),
                child: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color.fromARGB(255, 35, 85, 82),
                  child: Icon(
                    Icons.graphic_eq,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    

  }
}
