import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const FlutterSecureStorage _storage= FlutterSecureStorage();

static const String _tokenKey = 'auth_token';
static const String _userKey = 'auth_user';

  //هادا الفنكشن عشان احفظ التوكن بعد ما اسجل دخول او اني أنشئ حساب جديد 
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);

  }

  //هادا الفنكشن عشان اجلب او انه يعني أودي التوكن على أي Api
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  //وهادا الفنكشن لما عشان بس اعمل تسجيل خروج يحذف التوكن ما يخليه 
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

   // حفظ user (المريض)
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user),
    );
  }

  //  جلب user (المريض)
  static Future<Map<String, dynamic>?> getUser() async {
    final userStr = await _storage.read(key: _userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }
 }