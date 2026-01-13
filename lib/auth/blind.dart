import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/main.dart';
import 'package:front/component/customdrawer.dart';
import 'package:avatar_glow/avatar_glow.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';
class Blind extends StatefulWidget {
  const Blind({super.key});

  @override
  State<Blind> createState() => _BlindState();
}

class _BlindState extends State<Blind> {
  late CameraController controller;
  bool isReady = false;
  String? lastPlayedAudio;
  Timer? captureTimer;
  bool isSending = false;
  
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<String> audioQueue = [];
  bool isSpeaking = false;
  String lastSpokenText = '';
  @override
  void initState() {
    super.initState();
    initCamera();


      //Future.delayed(const Duration(seconds: 2), () {
    //tts.speak("Text to speech is working");
  //});
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
      const Duration(seconds: 1),
      (_) => captureAndSend(),
    );
  }

//==================captureAndSend =================

  Future<void> captureAndSend() async {
    if (!controller.value.isInitialized) return;
    if (isSending) return;

    try {
      isSending = true;

      final XFile image = await controller.takePicture();

      final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.52.212:8000/api/account/vision/')


    );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        debugPrint("SERVER RAW RESPONSE: $body");
        final data = jsonDecode(body);
        debugPrint("SERVER DECODED: $data");
        final audioPath = data['audio_file'];

        if (audioPath != null) {
          final audioUrl = "http://192.168.52.212:8000$audioPath";
          audioQueue.add(audioUrl);
          
          if (audioQueue.length > 5) {
          audioQueue.removeAt(0); 
        }
        if (audioUrl != lastPlayedAudio) {
          audioQueue.add(audioUrl);
          playNextIfIdle();
        }
        }
        
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSending = false;
    }
  }
/// ================= AUDIO PLAYER =================d
  Future<void> playAudio(String url) async {
  if (isSpeaking) return;
  lastPlayedAudio = url;
  setState(() {
    isSpeaking = true;
  });
  
  await audioPlayer.play(UrlSource(url));
  audioPlayer.onPlayerComplete.listen((event) {
    setState(() {
      isSpeaking = false;
    });
    playNextIfIdle();
    //if (isSpeaking) return;
  });
}
//================== QUEUE HANDLER =================
    void playNextIfIdle() {
  if (isSpeaking) return;
  if (audioQueue.isEmpty) return;

  final nextAudio = audioQueue.removeAt(0);
  playAudio(nextAudio);

}


  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("   Blind Page", style: TextStyle(
          color: AppColors.background,
          //TextAlign.center,
        ),),
        backgroundColor:AppColors.n4,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
      
          // ===== الكاميرا =====
          Positioned(
            top: 30,
            left:MediaQuery.of(context).size.width * 0.05,
            child: Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
            color:AppColors.n1,
            width:10,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: isReady
              ? CameraPreview(controller)
              : const Center(child: CircularProgressIndicator()),
                  ),
            ),
          ),
      
          const SizedBox(height: 10),
      
          // ===== الصوت =====
          Positioned(
            bottom:10,
            left:MediaQuery.of(context).size.width * 0.40,
            child: AvatarGlow(
                  glowColor:AppColors.n1,
                  animate: isSpeaking,
                  duration: const Duration(milliseconds: 1500),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.n4,
                    child: Icon(Icons.graphic_eq, color:AppColors.background),
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
  audioPlayer.dispose();
  controller.dispose();
  super.dispose();
}
}
