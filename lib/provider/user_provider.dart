import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // هادي بيانات اليوزر
  String? name;
  String? email;
  String? role;
  bool _emergencyEnabled = false;
  //هادا عند الsignup وال login
  void setUser({
    required String name,
    required String email,
    required String role,
  }) {
    this.name = name;
    this.email = email;
    this.role = role;
    notifyListeners(); //هادابخلي كل الواجهات اللي بتستخدم يوزر بروفايدر تتحدث تلقائي
    //يعني هون بكون خلص فاهم مين اليوزر وبحدث عأساس مين هو
  }

  // هادا عند الlogout
  void clearUser() {
    name = null;
    email = null;
    role = null;
    _emergencyEnabled = false; //نطفي المود الطوارئ عند تسجيل الخروج
    notifyListeners();
  }

  //هدول عشان نقرأ حالتهم من أي صفحة
  bool get isLoggedIn => role != null;
  bool get isAssistant => role == 'assistant';
  bool get isBlind => role == 'blind';
  bool get isVolunteer => role == 'volunteer';
  bool get isDeaf => role == 'deaf';
  bool get emergencyEnabled => _emergencyEnabled;

  void enabledEmegency() {
    _emergencyEnabled = true;
    notifyListeners();
  }

  void disableEmergency() {
    _emergencyEnabled = false;
    notifyListeners();
  }

  void toggleEmergency(bool value) {
    _emergencyEnabled = value;
    notifyListeners();
  }
}
