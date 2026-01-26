import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front/services/token_sevice.dart';  // تأكد من استيراد خدمة التوكن لديك

class Locationtracking {
  Timer? locationtimer;

  // دالة لبدء التحقق الدوري من الموقع
  Future<void> startLocationCheck(Function updateLocationCallback) async {
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
          // تحديث الموقع في SharedPreferences
          await prefs.setDouble('home_lat', currentLat);
          await prefs.setDouble('home_lng', currentLng);

          // استدعاء الكولباك (أو دالة) لتحديث الموقع عبر الـ API
          String currentLocation = "$currentLat,$currentLng";
          int? userId = await getUserId();
          if (userId != null) {
            updateLocationCallback(userId, currentLocation);
          } else {
            print("User ID is null, cannot update location.");
          }
        } else {
          print("Location is the same, no update needed.");
        }
      }
    });
  }

  // دالة للحصول على الموقع الحالي
  Future<Position> currentlocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // 2️⃣ افحص الإذن
  LocationPermission permission = await Geolocator.checkPermission();

  // 3️⃣ إذا ما كان مأذون → اطلب
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // 4️⃣ إذا رفض نهائي
  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  // 5️⃣ الآن خُد الموقع
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  }

  // دالة لإيقاف الـ Timer
  void stopLocationCheck() {
    locationtimer?.cancel();
  }
}
//==================get id
  Future<int?> getUserId() async {
  final user = await TokenService.getUser();
  if (user != null) {
    return user['id'];  // افترض أن الـ "id" هو المعرّف الخاص بالمستخدم
  }
  return null;
}