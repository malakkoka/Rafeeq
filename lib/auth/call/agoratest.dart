import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:front/services/token_sevice.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = "32ffa50575d141e1bd70d4ff78d7a3d1"; // App ID تبعك
const String channelName = "test";

class Agoratest extends StatefulWidget {
  const Agoratest({super.key});

  @override
  State<Agoratest> createState() => _AgoratestState();
}

class _AgoratestState extends State<Agoratest> {
  late RtcEngine _engine;
   late String? token ; 

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  

  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();
   // String? token = await TokenService.getToken();  

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: appId),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: "", // Testing mode
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

   String exractusertype(String token){
    Map<String , dynamic> payload = Jwt.parseJwt(token);

    return payload["user"]["user_type"];
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agora Test Call")),
      body: const Center(
        child: Text(
          "Camera should be ON الآن 🎥",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
