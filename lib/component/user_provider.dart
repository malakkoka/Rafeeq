// ignore_for_file: file_names

import 'package:flutter/material.dart';
class UserProvider with ChangeNotifier {
  String? name;
  String? email;
  String? role;
  //int? userId;

  void setUser({
    required String name,
    required String email,
    required String role,
    //required int userId, required id,
  }) {
    this.name = name;
    this.email = email;
    this.role = role;
    //this.userId = userId;
    notifyListeners();
  }
}
