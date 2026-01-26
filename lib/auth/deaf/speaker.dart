import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:front/color.dart';
import 'package:front/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class Speaker extends StatefulWidget {
  const Speaker({super.key});

  @override
  State<Speaker> createState() => _SpeakerState();
}

class _SpeakerState extends State<Speaker> {

  VideoPlayerController? videoController;

  final TextEditingController textController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool recording =false;
  bool ready=false ;
  bool issending =false ;
  bool isLoading = false;
  bool speaking =false;
  String? audiourl;
  String? signVideoUrl;
  String? recordedFilePath;
  //final AudioRecorder _recorder = AudioRecorder();


  



  
  




@override
  void initState(){
    super.initState();
    
  }

  
/*  
//================start recording
  Future<void> startRecording() async {
  final micStatus = await Permission.microphone.request();
  if (!micStatus.isGranted) return;

  final dir = await getTemporaryDirectory();
  recordedFilePath = '${dir.path}/voice.m4a';

  await _recorder.start(
    const RecordConfig(
      encoder: AudioEncoder.aacLc,
    ),
    path: recordedFilePath!,
  );

  setState(() {
    recording = true;
  });
}
//=================stop recording
  Future<void> stopRecording() async {
  await _recorder.stop();

  setState(() {
    recording = false;
  });

  if (recordedFilePath != null) {
    await sendVoiceToSign(recordedFilePath!);
  }
}

/=============send voice
  Future<void> sendVoiceToSign(String path) async {
  setState(() => isLoading = true);

  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://138.68.104.187/api/account/sign-language/"),
    );

    request.fields["input_type"] = "audio";
    request.files.add(
      await http.MultipartFile.fromPath("input_data", path),
    );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      final url = data["video_url"];

      await videoController?.dispose();
      videoController = VideoPlayerController.network(url);
      await videoController!.initialize();
      videoController!
        ..setLooping(true)
        ..play();

      setState(() {
        signVideoUrl = url;
      });
    }
  } catch (e) {
    debugPrint("❌ Voice Error: $e");
  } finally {
    setState(() => isLoading = false);
  }
}


  ///=============audio===============
  Future<void>playaudio()async{
    if (audiourl==null|| speaking)return;
    setState(() => speaking = true);

    await audioPlayer.play(UrlSource(audiourl!));
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() => speaking = false);
    });
  }
*/
  //=========send text

 Future<void> sendTextToSign() async {
  if (textController.text.trim().isEmpty) return;

  setState(() => isLoading = true);

  try {
    final response = await http.post(
      Uri.parse("http://138.68.104.187/api/account/sign-language/"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "input_type": "text",
        "input_data": textController.text.trim(),
      }),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final url = data['video_url'];

      if (url != null) {
        // تخلّص من أي فيديو قديم
        await videoController?.dispose();

        videoController = VideoPlayerController.network(url);

        // ⬅️ لازم await
        await videoController!.initialize();

        videoController!
          ..setLooping(true)
          ..play();

        setState(() {
          signVideoUrl = url;
        });
      }
    }
  } catch (e) {
    debugPrint("❌ ERROR: $e");
  } finally {
    // ⬅️ مهم جداً
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}


//========================
  @override
void dispose() {
  videoController?.dispose();

  super.dispose();
}
//===============clear==================
  Future<void> clearAll() async {

  try {
    await audioPlayer.stop();
  } catch (_) {}


  if (videoController != null) {
    await videoController!.pause();
    await videoController!.dispose();
    videoController = null;
  }


  setState(() {
    textController.clear();
    recording = false;
    ready = false;
    issending = false;
    isLoading = false;
    speaking = false;
    audiourl = null;
    signVideoUrl = null;
  });
}


//====================ui==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Speaker Page",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: AppColors.n4,
      ),
      
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(10),
              Text("type or speak",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.n4,
              ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height:100,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "type here ...",
                      filled: true,
                      fillColor: AppColors.inputField,
                      border: 
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color:  AppColors.n10,
                          width: 8
                        ),
                      ),
                      
              enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.n10),
          
              ),
              focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.n10),
              ),
            
                      suffixIcon: IconButton(
                      icon: Icon(
                        recording ?  Icons.stop : Icons.mic,
                        color : recording ? AppColors.n10: AppColors.n10
                      ),
                      onPressed: () {
                        
                      },)
                    ),),
                ),
              Container(
                alignment:Alignment.center,
                width: 320,
                //padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                      onPressed: isLoading ? null : sendTextToSign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.n10,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "translate",
                              style: TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold,
                                color:AppColors.dialogcolor
                                ) ,
                            ),
                    ),
                    ),
                
                  Gap(15),
                
                  Expanded(
                    
                      child: ElevatedButton(
                        onPressed:clearAll, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.n1,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(14),
                          ),
                          //padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "clear",
                          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
  margin: const EdgeInsets.all(20),
  height: 300,
  width: MediaQuery.of(context).size.width * 0.9,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.n1, width: 6),
    color: Colors.black,
  ),
  child: signVideoUrl == null
      ? const Center(
          child: Text(
            "No video yet",
            style: TextStyle(color: Colors.white),
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: videoController != null &&
                  videoController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio:
                      videoController!.value.aspectRatio,
                  child: VideoPlayer(videoController!),
                )
              : const Center(
                  child: CircularProgressIndicator(
                      color: Colors.white),
                ),
        ),
),

              
            ],
          ),
        ),
      )
    );
  }
}