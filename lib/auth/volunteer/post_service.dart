import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front/auth/volunteer/post_model.dart';

class PostService {
  static const String baseUrl = "http://172.20.10.2:8000";

  static Future<List<Post>> getPosts() async {
    print("get posts called");
    final response = await http.get(
      Uri.parse("$baseUrl/api/account/posts/"),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer MHlnQqke0r96lzWOElsoBuaz6bxJ6jGb",
      },
    );
    print('Status Code: ${response.statusCode}');
    print('response Body: ${response.body}');
    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
