import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';


class Livecall extends StatefulWidget {
  const Livecall({super.key});

  @override
  State<Livecall> createState() => _LivecallState();
}

class _LivecallState extends State<Livecall> {
  late RtcEngine _engine;

  bool isMicOn = true;
  bool isCameraOn = true;

  final String appId = "32ffa50575d141e1bd70d4ff78d7a3d1"; // Agora App ID
  final String channelName = "test"; // نفس الاسم بالجهازين

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(appId: appId),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: "", // 🔴 فاضي (Test mode)
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Rafeeq Video Call",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ===== Big Video (Other User) =====
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),

          // ===== Small Self Camera =====
          Positioned(
            top: 90,
            right: 16,
            child: SizedBox(
              width: 110,
              height: 160,
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                  useFlutterTexture: true,
                ),
              ),
            ),
          ),

          // ===== Controls =====
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circleButton(
                  icon: isMicOn ? Icons.mic : Icons.mic_off,
                  onTap: () async {
                    setState(() => isMicOn = !isMicOn);
                    await _engine.muteLocalAudioStream(!isMicOn);
                  },
                ),
                _circleButton(
                  icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
                  onTap: () async {
                    setState(() => isCameraOn = !isCameraOn);
                    await _engine.muteLocalVideoStream(!isCameraOn);
                  },
                ),
                _endCallButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _endCallButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _engine.leaveChannel();
        Navigator.pop(context);
      },
      child: const CircleAvatar(
        radius: 32,
        backgroundColor: Colors.red,
        child: Icon(Icons.call_end, color: Colors.white),
      ),
    );
  }
}
 