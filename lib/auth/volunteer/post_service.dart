import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;
import 'package:front/auth/volunteer/post_model.dart';

class PostService {
  static Future<List<Post>> getPosts() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/api/account/posts/?state=0"), // Pending فقط
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);

return decoded
    .map((e) => Post.fromJson(e))
    .where((post) => post.state == 0) // 👈 Pending فقط
    .toList();

    } else {
      throw Exception("Failed to load posts");
    }
  }
}
