import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // هادي بيانات اليوزر
  String? name;
  String? email;
  String? role;

 //هادا عند الsignup وال login
  void setUser({
    required String name,
    required String email,
    required String role,
  }) {
    this.name = name;
    this.email = email;
    this.role = role;
    notifyListeners();
  }

  
  // هادا عند الlogout
  void clearUser() {
    name = null;
    email = null;
    role = null;
    notifyListeners();
  }

  
  bool get isLoggedIn => role != null;
  bool get isAssistant => role == 'assistant';
  bool get isBlind => role == 'blind';
  bool get isVolunteer => role == 'volunteer';
  bool get isDeaf => role == 'deaf';
}
