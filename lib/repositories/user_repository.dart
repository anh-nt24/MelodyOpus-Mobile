import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:melodyopus/constants.dart';

class UserRepository {
  // singleton
  UserRepository._internal();
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() => _instance;


  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$Constants.baseApi$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
}