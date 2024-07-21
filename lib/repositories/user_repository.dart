import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:melodyopus/constants.dart';
import 'package:melodyopus/models/user.dart';

class UserRepository {
  // singleton
  UserRepository._internal();
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() => _instance;


  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseApi}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> signup(String name, String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseApi}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'username': username,
        'password': password
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}