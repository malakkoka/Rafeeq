import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/services/token_sevice.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:front/color.dart';
import 'package:front/main.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deaf extends StatefulWidget {
  const Deaf({super.key});

  @override
  State<Deaf> createState() => _DeafState();
}

class _DeafState extends State<Deaf> {
  late CameraController controller;
  bool ready=false ;
  bool issending =false ;

  Timer? locationtimer;

  Timer ?capturetimer ;

  String translatedText = "Waiting for sign language...";
  String? audiourl;

  final AudioPlayer audioPlayer = AudioPlayer();
  
  bool speaking =false;


@override
  void initState(){
    super.initState();
    initCamera();
    savecurrent(); 
    startLocationCheck();
  }


//==================get id
  Future<int?> getUserId() async {
  final user = await TokenService.getUser();
  if (user != null) {
    return user['id'];  // افترض أن الـ "id" هو المعرّف الخاص بالمستخدم
  }
  return null;
}




  /*Future<void> fetchToken() async {
  String? token = await TokenService.getToken();  // استخدام await هنا لأن getToken() هي async
  if (token != null) {
    print("Token: $token");
    // الآن يمكنك استخدام التوكين في أي مكان آخر، مثلًا لإجراء API requests
  } else {
    print("No token found");
  }
}
*/

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
  locationtimer?.cancel();
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

      Position position = await currentlocation();
      double lat = position.latitude;
      double lng = position.longitude;

      String currentLocation = "$lat,$lng";

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.52.212:8000/api/account/sign/'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      request.fields['current_location'] = currentLocation;

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

//===============save current location==========
  Future<void>savecurrent()async{
    print("============Starting savecurrent function...");

    bool granted = await locationreq();
    print("==============Location permission granted: $granted");


    if (!granted){
      print("Permission denied");
    return;
    }

  Position position = await currentlocation();

  print("==================Current location: Lat = ${position.latitude}, Lng = ${position.longitude}");

  double lat = position.latitude;
  double lng = position.longitude;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('home_lat', lat);
  await prefs.setDouble('home_lng', lng);
  print("============================Home location saved: $lat, $lng");

  double? savedLat = prefs.getDouble('home_lat');
  double? savedLng = prefs.getDouble('home_lng');

  print("===================Saved Lat: $savedLat, Saved Lng: $savedLng");

  String currentLocation = "$lat,$lng";
  int? userId = await getUserId();
  if (userId != null) {
    updateUserLocation(userId, currentLocation); // استدعاء دالة تحديث الموقع
  } else {
    print("==============================User ID is null, cannot update location.");
  }
  }

  //=================
  Future<void> updateUserLocation(int userId, String currentLocation) async {
 
 


  String? token = await TokenService.getToken();  // استرجاع التوكين

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
      body: body,  // إرسال البيانات
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

  //==========location traking==========
  Future<void> startLocationCheck() async {
  // بدء التحقق المستمر كل 30 ثانية
  locationtimer = Timer.periodic(const Duration(seconds: 30), (_) async {
    // احصل على الموقع الحالي
    Position currentPosition = await currentlocation();
    double currentLat = currentPosition.latitude;
    double currentLng = currentPosition.longitude;

    // استرجاع الموقع المخزن من SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedLat = prefs.getDouble('home_lat');
    double? savedLng = prefs.getDouble('home_lng');

    // تحقق إذا كان الموقع قد تغير
    if (savedLat != null && savedLng != null) {
      if (currentLat != savedLat || currentLng != savedLng) {
        print("========================Location changed! Updating location...");
        
        // تحديث الموقع في SharedPreferences
        await prefs.setDouble('home_lat', currentLat);
        await prefs.setDouble('home_lng', currentLng);

        // قم بتحديث الموقع في الـ API
        String currentLocation = "$currentLat,$currentLng";
        int? userId = await getUserId();
        if (userId != null) {
          updateUserLocation(userId, currentLocation);
        } else {
          print("=============================User ID is null, cannot update location.");
        }
      } else {
        print("==============================Location is the same, no update needed.");
      }
    }
  });
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
                  onPressed:(){
                    String currentLocation = "Amman, Jordan"; // مؤقتًا مثال

    //await updateUserLocation(userId, currentLocation);
                  },
                  icon:Icon(speaking? Icons.volume_up : Icons.play_arrow,
                  color: AppColors.background,
                            ),),
              )
          ,
            ],
          ),
          
      
          /* ElevatedButton.icon(
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
          
        ],
      )
    );
  }
}