import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _SimpleVideoCallState();
}

class _SimpleVideoCallState extends State<VideoCall> {
  RtcEngine? _engine; // جعلناه Nullable للتحقق من الحالة

  int? remoteUid;
  bool joined = false;
  bool micMuted = false;

  // إعدادات أجورا
  static const String appId = "32ffa50575d141e1bd70d4ff78d7a3d1";
  static const String channelName = "test_call";

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (!statuses.values.every((s) => s.isGranted)) {
      debugPrint("Permissions not granted");
      return;
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user joined: ${connection.localUid}");
          if (mounted) setState(() => joined = true);
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("Remote user joined: $uid");
          if (mounted) setState(() => remoteUid = uid);
        },
        onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint("Remote user left: $uid");
          if (mounted) setState(() => remoteUid = null);
        },
        onError: (err, msg) {
          debugPrint("Agora Error: $err - $msg");
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: "",
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  Future<void> _disposeAgora() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
    }
  }

  Widget _callButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blueGrey,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: remoteUid != null
                ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine!,
                canvas: VideoCanvas(uid: remoteUid),
                connection: const RtcConnection(channelId: channelName),
              ),
            )
                : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    "Waiting for the other user...",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          if (joined)
            Positioned(
              top: 40,
              right: 20,
              width: 120,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0), // 0 دائماً للفيديو المحلي
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callButton(
                  icon: micMuted ? Icons.mic_off : Icons.mic,
                  color: micMuted ? Colors.redAccent : Colors.white24,
                  onTap: () async {
                    setState(() => micMuted = !micMuted);
                    await _engine?.muteLocalAudioStream(micMuted);
                  },
                ),
                _callButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  size: 70,
                  onTap: () => Navigator.pop(context),
                ),
                _callButton(
                  icon: Icons.cameraswitch,
                  color: Colors.white24,
                  onTap: () async => await _engine?.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}