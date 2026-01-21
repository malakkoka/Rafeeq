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

class Speaker extends StatefulWidget {
  const Speaker({super.key});

  @override
  State<Speaker> createState() => _SpeakerState();
}

class _SpeakerState extends State<Speaker> {
  late CameraController controller;
  bool ready=false ;
  bool issending =false ;

  Timer ?capturetimer ;

  String translatedText = "Waiting for sign language...";
  String? audiourl;

  final TextEditingController textController = TextEditingController();
  bool recording =false;

  final AudioPlayer audioPlayer = AudioPlayer();
  bool speaking =false;




@override
  void initState(){
    super.initState();
    initCamera();
  }

  Future<void>initCamera()async{
    controller= CameraController(
      cameras![0],ResolutionPreset.medium,
      enableAudio: false,);

    await controller.initialize();
    if (!mounted)return;
    
    setState(() =>ready= true);
    startAutoCapture();
  }

  void startAutoCapture(){
    capturetimer=Timer.periodic(const Duration(seconds: 1),
    (_)=>captureAndSend(),
    );
  }

  void startRecording(){

  }

  void stopRecording(){

  }

 ///===============frames sending ======================
  Future<void> captureAndSend() async {
    if (!controller.value.isInitialized || issending) return;

    try {
      issending = true;

      final XFile image = await controller.takePicture();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.52.212:8000/api/account/sign/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final data = jsonDecode(body);

        setState(() {
          translatedText = data['text'] ?? translatedText;

          if (data['audio_file'] != null) {
            audiourl =
                "http://192.168.52.212:8000${data['audio_file']}";
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      issending = false;
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
          backgroundColor: AppColors.n1,
      ),
      
      body:SafeArea(
        child: Column(
          children: [
            Gap(10),
            Text("type or speak",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.n1,
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
                      setState(() {
                        recording=!recording;
                      });
                      if (recording)
                      {startRecording();}
                      else{
                        stopRecording();
                      }
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
                      onPressed:(){}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.n10,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(14),
                        ),
                        //padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "translate",
                        style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              
                Gap(15),
              
                Expanded(
                  
                    child: ElevatedButton(
                      onPressed:(){}, 
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
              margin : EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*.5,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.n1,width: 6),
              ),
              
            ),
          ],
        ),
      )
    );
  }
}