import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // ===== User Identity =====
  String? id;
  String? name;
  String? email;
  String? phone;
String? deviceToken; 

  // role == user_type
  String? role; // blind, deaf, assistant, volunteer

  // ===== Abilities =====
  bool canWrite = false;
  bool canSpeakWithSignLanguage = false;

  // ===== State =====
  bool isActive = false;
  bool isLoading = false;
  bool _emergencyEnabled = false;

  // ===== Set User =====
  void setUser({
    required String id,
    required String name,
    required String phone,
    required String role,
    String? email,
    bool canWrite = false,
    bool canSpeakWithSignLanguage = false,
    bool isActive = true,
  }) {
    this.id = id;
    this.name = name;
    this.phone = phone;
    this.role = role;
    this.email = email;
    this.canWrite = canWrite;
    this.canSpeakWithSignLanguage = canSpeakWithSignLanguage;
    this.isActive = isActive;
    notifyListeners();
  }

  // ===== Logout =====
  void clearUser() {
    id = null;
    name = null;
    email = null;
    phone = null;
    role = null;
    canWrite = false;
    canSpeakWithSignLanguage = false;
    isActive = false;
    _emergencyEnabled = false;
    isLoading = false;
    notifyListeners();
  }

  // ===== Getters =====
  bool get isLoggedIn => role != null;
  bool get isBlind => role == 'blind';
  bool get isDeaf => role == 'deaf';
  bool get isAssistant => role == 'assistant';
  bool get isVolunteer => role == 'volunteer';
  bool get emergencyEnabled => _emergencyEnabled;

  // ===== Emergency Mode =====
  void enableEmergency() {
    _emergencyEnabled = true;
    notifyListeners();
  }

  void disableEmergency() {
    _emergencyEnabled = false;
    notifyListeners();
  }

  void toggleEmergency(bool value) {
    _emergencyEnabled = value;
    print("Emergency mode: $value");
    notifyListeners();
  }

  void setDeviceToken(String? token) {
  deviceToken = token;
  notifyListeners();
}
}
