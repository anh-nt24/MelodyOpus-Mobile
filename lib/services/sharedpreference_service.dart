import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Import your User model

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;

  static const String userKey = 'user';

  SharedPreferencesService._internal();


  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, jsonEncode(user.toMap()));
    prefs.setBool("isLoggedIn", true);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(userKey);

    if (userString != null) {
      final userMap = jsonDecode(userString);
      prefs.setBool("isLoggedIn", true);
      return User.fromMap(userMap);
    }

    prefs.setBool("isLoggedIn", true);
    return User.guest();
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userKey);
  }

  Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool("isLoggedIn") ?? false;
  }
}