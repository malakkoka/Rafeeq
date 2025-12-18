import 'package:flutter/material.dart';
class UserProvider with ChangeNotifier {
  String? name;
  String? email;
  String? role;

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
}
