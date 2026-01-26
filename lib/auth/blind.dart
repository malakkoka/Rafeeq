import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/auth/call/calling.dart';
import 'package:front/component/customdrawer.dart';
import 'package:front/component/locationtracking.dart';
import 'package:front/main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:front/services/token_sevice.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';


class Blind extends StatefulWidget {
  const Blind({super.key});

  @override
  State<Blind> createState() => _BlindState();
}

class _BlindState extends State<Blind> {
  late CameraController controller;
  late Locationtracking locationtracking;
  bool isReady = false;
  String? lastPlayedAudio;
  Timer? captureTimer;
  bool isSending = false;
  bool isCameraActive = true;
  int _tapCount = 0;
DateTime? _lastTapTime;

//final FlutterLocalNotificationsPlugin notificationsPlugin =
  //  FlutterLocalNotificationsPlugin();

  final AudioPlayer audioPlayer = AudioPlayer();
  final List<String> audioQueue = [];
  final FlutterTts flutterTts = FlutterTts();

  bool isSpeaking = false;
  String lastSpokenText = '';
  @override
  void initState() {
    super.initState();
    initCamera();
    locationtracking = Locationtracking(); 

    locationtracking.startLocationCheck(updateUserLocation);

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

   Future<void> updateUserLocation(int userId, String currentLocation) async {
    String? token = await TokenService.getToken();

    if (token == null) {
      print("No token found. Please log in again.");
      return;
    }

    final String url = 'http://138.68.104.187/api/account/users/$userId/';  

    final Map<String, dynamic> data = {
      'current_location': currentLocation,
    };

    final String body = json.encode(data);

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("=======================User location updated successfully!");
      } else {
        print("=============================Failed to update user location: ${response.statusCode}");
      }
    } catch (e) {
      print("====================Error: $e");
    }
  }
  //========
  void startVideoCall() {
  debugPrint("VIDEO CALL STARTED");
  stopCamera();
 Navigator.push(
   context,
   MaterialPageRoute(builder: (_) => Calling()),
 );
}

//=========vedio call taps
  void handleBlindGesture() {
  final now = DateTime.now();

  if (_lastTapTime == null ||
      now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
    _tapCount = 1;
  } else {
    _tapCount++;
  }

  _lastTapTime = now;

  if (_tapCount == 3) {
    _tapCount = 0;

    // تأكيد صوتي
    flutterTts.speak("Starting video call");

    // تشغيل الكول
    startVideoCall();
  }
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
//=============stop camera
  void stopCamera() {
  captureTimer?.cancel();
  captureTimer = null;

  if (controller.value.isInitialized) {
    controller.dispose();
  }

  setState(() {
    isCameraActive = false;
    isReady = false;
  });
}


//==================captureAndSend =================




  Future<void> captureAndSend() async {
    debugPrint("CAPTURE STARTED");
    if (!isCameraActive) return;

    if (!controller.value.isInitialized) return;
    if (isSending) return;
    if (isSpeaking) return; // مهم
   // if (isSending && audioQueue.length > 3) return;


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
          await Future.delayed(const Duration(milliseconds:1000));
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
  return GestureDetector(
    behavior: HitTestBehavior.opaque, // 👈 مهم جداً
    onTapDown: (_) => handleBlindGesture(), // 👈 هنا السحر
    child: Scaffold(
      backgroundColor: AppColors.background,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "   Blind Page",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
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
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 251, 187, 131),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 251, 187, 131),
                  width: 10,
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

          // ===== الصوت =====
          Positioned(
            bottom: 15,
            left: MediaQuery.of(context).size.width * 0.40,
            child: AvatarGlow(
              glowColor: const Color.fromARGB(255, 251, 187, 131),
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
    ),
  );
}
}