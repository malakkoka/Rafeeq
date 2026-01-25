import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/component/customdrawer.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:front/color.dart';
import 'package:front/main.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Deaf extends StatefulWidget {
  const Deaf({super.key});

  @override
  State<Deaf> createState() => _DeafState();
}

class _DeafState extends State<Deaf> {
  late CameraController controller;
  bool ready=false ;
  bool issending =false ;

  Timer ?capturetimer ;

  String translatedText = "Waiting for sign language...";
  String? audiourl;

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

  @override
void dispose() {
  controller.dispose();
  super.dispose();
}

  void startAutoCapture(){
    capturetimer=Timer.periodic(const Duration(seconds: 1),
    (_)=>captureAndSend(),
    );
  }

  String exractusertype(String token){
    Map<String , dynamic> payload = Jwt.parseJwt(token);

    return payload["user"]["user_type"];
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
  ///==========location===============
  Future<bool>locationreq()async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever){
      return false;
    }

    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  ///=========current location========
  Future<Position>currentlocation()async {
    return await Geolocator.getCurrentPosition(
    desiredAccuracy:  LocationAccuracy.high,
    );
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
      drawer: CustomDrawer(),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "   Deaf Page",
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w500
          ),),
          backgroundColor: AppColors.n4,
      ),
      body: Column(
        children: [
          
          Container(
            margin : EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height*.6,
            width: MediaQuery.of(context).size.height*.5,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.n4,width: 6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: ready
              ?CameraPreview(controller)
              : const Center(child:CircularProgressIndicator()),
            ),
          ),
          Gap(10),
          Row(
            children: [
              Gap(20),
              Container(
                padding: EdgeInsets.all(16),
                
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border :Border.all(color : AppColors.n7,width: 2),
                ),
                child: Text(translatedText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.n9,
                )),
              ),
              Gap(10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.n10,
                  borderRadius: BorderRadius.circular(30),
                ),
                
                
                child: IconButton(
                  onPressed:(){},
                  icon:Icon(speaking? Icons.volume_up : Icons.play_arrow,
                  color: AppColors.background,
                            ),),
              )
          ,
            ],
          ),
          Gap(16),
          /*ElevatedButton.icon(
            onPressed: playaudio,
            icon: Icon(speaking? Icons.volume_up : Icons.play_arrow,
            ),
            label: Text("",style: TextStyle(color: AppColors.background,fontSize: 18),),
            style:  ElevatedButton.styleFrom(
              backgroundColor: AppColors.n10,
              iconSize: 30,
              iconColor: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 12),
            ),
            label: Text("play voice translation",
            style: TextStyle(color: AppColors.background,fontSize: 18),),
            style:  ElevatedButton.styleFrom(
              backgroundColor: AppColors.n10,
              iconSize: 30,
              iconColor: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 12),
            ),
          ),*/
          Gap(15)
        ],
      )
    );
  }
}