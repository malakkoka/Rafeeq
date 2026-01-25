import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:front/main.dart';
import 'package:front/color.dart';
import 'package:front/services/token_sevice.dart';

class Deaf extends StatefulWidget {
  const Deaf({super.key});

  @override
  State<Deaf> createState() => _DeafState();
}

class _DeafState extends State<Deaf> {
  late CameraController controller;

  bool ready = false;
  bool isBusy = false; // ✅ واحد فقط للتحكم بكل عمليات الكاميرا + الارسال

  // STT result:
  Uint8List? sttAudioBytes; // لو رجع صوت كبايتس
  String? sttAudioUrl; // لو رجع audio_file

  final AudioPlayer audioPlayer = AudioPlayer();
  bool speaking = false;

  // location
  Timer? locationtimer;

  // UI text
  String translatedText = "Waiting for sign language...";

  @override
  void initState() {
    super.initState();
    initCamera();
    savecurrent();
    startLocationCheck();
  }

  // ================= CAMERA INIT =================
  Future<void> initCamera() async {
    
    controller = CameraController(
      cameras![0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg, // ✅ يساعد يقلل مشاكل
    );

    await controller.initialize();
    if (!mounted) return;

    setState(() => ready = true);
  }

  @override
  void dispose() {
    locationtimer?.cancel();
    audioPlayer.dispose();
    controller.dispose();
    super.dispose();
  }

  // ================= STT SEND (JSON frames) =================
  Future<void> captureAndSendSTT() async {
    if (!controller.value.isInitialized) return;

    // ✅ حماية قوية ضد أي استدعاء مزدوج
    if (isBusy || controller.value.isTakingPicture) {
      debugPrint("⛔ Busy / isTakingPicture = true");
      return;
    }

    isBusy = true;
    debugPrint("🟥 زر الكاميرا انكبس");
    debugPrint("🚀 STT: start captureAndSendSTT");

    try {
      // 1) take picture
      final XFile image = await controller.takePicture();
      final bytes = await image.readAsBytes();

      // 2) base64
      final base64Frame = base64Encode(bytes);
      debugPrint("📦 frame base64 length: ${base64Frame.length}");

      // 3) send to backend (frames as JSON)
      final response = await http.post(
        Uri.parse("http://138.68.104.187/api/account/stt/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json,audio/mpeg,*/*",
        },
        body: jsonEncode({
          "frames": [base64Frame],
        }),
      );

      debugPrint("📡 STATUS: ${response.statusCode}");
      final contentType = response.headers["content-type"] ?? "";
      debugPrint("📄 content-type: $contentType");

      if (response.statusCode == 200) {
        // ✅ حالتين: يا بيرجع صوت bytes أو بيرجع json فيه audio_file
        if (contentType.contains("audio") || contentType.contains("mpeg")) {
          sttAudioBytes = response.bodyBytes;
          sttAudioUrl = null;
          debugPrint("✅ Audio bytes received: ${sttAudioBytes!.length} bytes");
        } else {
          // json
          final data = jsonDecode(response.body);
          final audioFile = data["audio_file"];
          final text = data["text"];

          if (text != null) {
            setState(() => translatedText = text.toString());
          }

          if (audioFile != null) {
            // مرات بيرجع كامل، مرات بيرجع path
            final s = audioFile.toString();
            sttAudioUrl = s.startsWith("http") ? s : "http://138.68.104.187$s";
            sttAudioBytes = null;
            debugPrint("✅ Audio URL saved: $sttAudioUrl");
          } else {
            debugPrint("⚠️ 200 but no audio_file in JSON");
          }
        }
      } else {
        debugPrint("❌ BODY: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ STT ERROR: $e");
    } finally {
      isBusy = false;
      debugPrint("🔁 isBusy = false");
      if (mounted) setState(() {});
    }
  }

  // ================= PLAY =================
  Future<void> playSTTAudio() async {
    if (speaking) return;

    // إذا ما في ولا bytes ولا url
    if (sttAudioBytes == null && (sttAudioUrl == null || sttAudioUrl!.isEmpty)) {
      debugPrint("⛔ No audio to play");
      return;
    }

    setState(() => speaking = true);

    try {
      await audioPlayer.stop();

      if (sttAudioBytes != null) {
        await audioPlayer.play(BytesSource(sttAudioBytes!));
      } else {
        await audioPlayer.play(UrlSource(sttAudioUrl!));
      }
    } catch (e) {
      debugPrint("❌ Audio play error: $e");
      setState(() => speaking = false);
      return;
    }

    audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;
      setState(() => speaking = false);
    });
  }

  // ================= USER ID =================
  Future<int?> getUserId() async {
    final user = await TokenService.getUser();
    if (user != null) return user['id'];
    return null;
  }

  // ================= LOCATION =================
  Future<bool> locationreq() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return false;
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position> currentlocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> savecurrent() async {
    bool granted = await locationreq();
    if (!granted) return;

    Position position = await currentlocation();
    double lat = position.latitude;
    double lng = position.longitude;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('home_lat', lat);
    await prefs.setDouble('home_lng', lng);

    String currentLocation = "$lat,$lng";
    int? userId = await getUserId();
    if (userId != null) {
      updateUserLocation(userId, currentLocation);
    }
  }

  Future<void> updateUserLocation(int userId, String currentLocation) async {
    String? token = await TokenService.getToken();
    if (token == null) return;

    final String url = 'http://138.68.104.187/api/account/users/$userId/';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'current_location': currentLocation}),
    );

    debugPrint("📍 update location status: ${response.statusCode}");
  }

  Future<void> startLocationCheck() async {
    locationtimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      Position currentPosition = await currentlocation();
      double currentLat = currentPosition.latitude;
      double currentLng = currentPosition.longitude;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      double? savedLat = prefs.getDouble('home_lat');
      double? savedLng = prefs.getDouble('home_lng');

      if (savedLat != null && savedLng != null) {
        if (currentLat != savedLat || currentLng != savedLng) {
          await prefs.setDouble('home_lat', currentLat);
          await prefs.setDouble('home_lng', currentLng);

          String currentLocation = "$currentLat,$currentLng";
          int? userId = await getUserId();
          if (userId != null) {
            updateUserLocation(userId, currentLocation);
          }
        }
      }
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Deaf Page",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.n4,
      ),
      body: Column(
        children: [
          const Gap(20),
          Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * .6,
            width: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.n4, width: 6),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ready
                      ? CameraPreview(controller)
                      : const Center(child: CircularProgressIndicator()),
                ),

                // زر التصوير/الإرسال
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (isBusy) return;
                      await captureAndSendSTT();
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isBusy ? Colors.grey : Colors.red,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Icon(
                        isBusy ? Icons.hourglass_top : Icons.fiber_manual_record,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(10),

          Row(
            children: [
              const Gap(20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.n7, width: 2),
                  ),
                  child: Text(
                    translatedText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.n9,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.n10,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: playSTTAudio,
                  icon: Icon(
                    speaking ? Icons.volume_up : Icons.play_arrow,
                    color: AppColors.background,
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ],
      ),
    );
  }
}
