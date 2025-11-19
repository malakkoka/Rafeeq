import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/main.dart';


class Blind extends StatefulWidget {
  const Blind({super.key});

  @override
  State<Blind> createState() => _BlindState();
}

class _BlindState extends State<Blind> {
  late CameraController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    controller = CameraController(
      cameras![0],
      ResolutionPreset.medium,
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
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CameraPreview(controller),
    );
  }
}
