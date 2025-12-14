import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/main.dart';
import 'package:front/component/customdrawer.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Blind extends StatefulWidget {
  const Blind({super.key});

  @override
  State<Blind> createState() => _BlindState();
}

class _BlindState extends State<Blind> {
  late CameraController controller;
  bool isReady = false;

  Timer? captureTimer;
  bool isSending = false;

  final FlutterTts tts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initCamera();
    setupTTS();
  }

  // ================= CAMERA =================

  Future<void> initCamera() async {
    controller = CameraController(
      cameras![0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();
    if (!mounted) return;

    setState(() => isReady = true);

    startAutoCapture();
  }

  void startAutoCapture() {
    captureTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => captureAndSend(),
    );
  }

  Future<void> captureAndSend() async {
    if (!controller.value.isInitialized) return;
    if (isSending) return;

    try {
      isSending = true;

      final XFile image = await controller.takePicture();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/analyze-image/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final text = jsonDecode(body)['result'] ?? '';

        if (text.isNotEmpty) {
          speakText(text);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSending = false;
    }
  }

  // ================= TTS =================

  void setupTTS() {
    tts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> speakText(String text) async {
    if (isSpeaking) return;

    setState(() {
      isSpeaking = true;
    });

    await tts.speak(text);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Blind Interface"),
        backgroundColor: const Color.fromARGB(255, 35, 85, 82),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          isReady
              ? CameraPreview(controller)
              : const CircularProgressIndicator(),

          Positioned(
            bottom: 30,
            child: AvatarGlow(
              glowColor: const Color.fromARGB(255, 35, 85, 82),
              animate: isSpeaking,
              duration: const Duration(milliseconds: 1500),
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Color.fromARGB(255, 35, 85, 82),
                child: Icon(Icons.graphic_eq, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    captureTimer?.cancel();
    tts.stop();
    controller.dispose();
    super.dispose();
  }
}
