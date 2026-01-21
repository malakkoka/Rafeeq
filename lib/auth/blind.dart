import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/component/customdrawer.dart';
import 'package:front/main.dart';
import 'package:avatar_glow/avatar_glow.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isSpeaking = false;
      });
      playNextIfIdle();
    });

    //Future.delayed(const Duration(seconds: 2), () {
    //tts.speak("Text to speech is working");
    //});
  }

//===========get usertype by token =============
  String exractusertype(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    return payload["user"]["user_type"];
  }

//===========save usertype===================
  Future<void> saveusertype(String token) async {
    final prefs = await SharedPreferences.getInstance();

    String usertype = exractusertype(token);
    await prefs.setString('user_type', usertype);
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

  /*Future<bool> waitForAudio(
  String url, {
  int retries = 5,
  Duration delay = const Duration(milliseconds: 700),
}) async {
  for (int i = 0; i < retries; i++) {
    try {
      final res = await http.head(Uri.parse(url));
      if (res.statusCode == 200) return true;
    } catch (_) {}
    await Future.delayed(delay);
  }
  return false;
}

Future<bool> checkAudioExists(String url) async {
  final res = await http.head(Uri.parse(url));
  return res.statusCode == 200;
}*/

//==================captureAndSend =================

  Future<void> captureAndSend() async {
    debugPrint("CAPTURE STARTED");

    if (!controller.value.isInitialized) return;
    if (isSending) return;
    if (isSpeaking) return; // مهم

    try {
      isSending = true;

      final XFile image = await controller.takePicture();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://138.68.104.187/api/account/vision/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();
      debugPrint("STATUS CODE: ${response.statusCode}");

      final body = await response.stream.bytesToString();
      debugPrint("RAW BODY: $body");

      if (response.statusCode != 200) return;

      final data = jsonDecode(body);

      if (data['success'] == true && data['audio_file'] != null) {
        final audioUrl = "http://138.68.104.187${data['audio_file']}";
        debugPrint("AUDIO URL: $audioUrl");

        if (audioUrl != lastPlayedAudio) {
          await Future.delayed(const Duration(seconds: 1));
          audioQueue.add(audioUrl);
          playNextIfIdle();
        }
      } else {
        debugPrint("NO AUDIO: ${data['message']}");
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    } finally {
      isSending = false;
    }
  }
  /*if (audioUrl != lastPlayedAudio) {
       // final ready = await waitForAudio(audioUrl);

          if (ready) {
      audioQueue.add(audioUrl);
      playNextIfIdle();
    } else {
      debugPrint("AUDIO NEVER BECAME READY: $audioUrl");
    }
      }
    } else {
      debugPrint("NO AUDIO: ${data['message']}");
    }

  } catch (e) {
    debugPrint("ERROR: $e");
  } finally {
    isSending = false;
  }
}
*/

  /// ================= AUDIO PLAYER =================d
  Future<void> playAudio(String url) async {
    if (isSpeaking) return;

    lastPlayedAudio = url;
    setState(() {
      isSpeaking = true;
    });

    try {
      await audioPlayer.stop();

      audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint("AUDIO ERROR: $e");
      setState(() => isSpeaking = false);
    }
  }

  /*await audioPlayer.play(UrlSource(url));
  audioPlayer.onPlayerComplete.listen((event) {
    setState(() {
      isSpeaking = false;
    });
    playNextIfIdle();
    //if (isSpeaking) return;
  });
}*/
//================== QUEUE HANDLER =================
  void playNextIfIdle() {
    if (isSpeaking) return;
    if (audioQueue.isEmpty) return;

    final nextAudio = audioQueue.removeAt(0);
    playAudio(nextAudio);
  }

//=========عشان اطفي الكاميرا ==========
  @override
  void dispose() {
    captureTimer?.cancel();
    audioPlayer.dispose();
    controller.dispose();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "   Blind Page",
          style:
              TextStyle(color: AppColors.background, fontWeight: FontWeight.w500
                  //TextAlign.center,
                  ),
        ),
        backgroundColor: AppColors.n10,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ===== الكاميرا =====
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              height: 600,
              //color: AppColors.c7,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 251, 187, 131),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(255, 251, 187, 131),
                  width: 10,
                ),
              ),
              //#
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
            bottom: 15,
            left: MediaQuery.of(context).size.width * 0.40,
            child: AvatarGlow(
              glowColor: Color.fromARGB(255, 251, 187, 131),
              animate: isSpeaking,
              duration: const Duration(milliseconds: 1500),
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.n10,
                child: Icon(
                  Icons.graphic_eq,
                  color: AppColors.background,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
