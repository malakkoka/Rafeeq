import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class Livecall extends StatefulWidget {
  const Livecall({super.key});

  @override
  State<Livecall> createState() => _LivecallState();
}

class _LivecallState extends State<Livecall> {
  final JitsiMeet _jitsiMeet = JitsiMeet();

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }
Future<void> _joinMeeting() async {
    final options = JitsiMeetConferenceOptions(
      room: "rafeeq_demo_room", // ✅ roomId ثابت
      serverURL: "https://meet.jit.si",
      userInfo: JitsiMeetUserInfo(
        displayName: "Rafeeq User",
      ),
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
      },
      featureFlags: {
        "welcomepage.enabled": false,
      },
    );

    await _jitsiMeet.join(options);
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Joining call...",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
