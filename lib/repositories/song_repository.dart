import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:melodyopus/constants.dart';

class SongRepository {
  SongRepository._internal();

  static final SongRepository _instance = SongRepository._internal();

  factory SongRepository() => _instance;

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('${Constants.baseApi}$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    else {
      throw Exception('Failed to load data');
    }
  }
}