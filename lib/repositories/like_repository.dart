import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:melodyopus/constants.dart';
import 'package:melodyopus/models/song.dart';

class LikeRepository {

  LikeRepository._internal();
  static final LikeRepository _instance = LikeRepository._internal();

  factory LikeRepository() => _instance;

  Future<void> addLike(int songId, String jwt) async {
    final response = await http.post(
        Uri.parse('${Constants.baseApi}/likes/like?songId=${songId}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        }
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body));
    }
  }

  Future<void> unLike(int songId, String jwt) async {
    final response = await http.post(
        Uri.parse('${Constants.baseApi}/likes/unlike?songId=${songId}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        }
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body));
    }
  }


  Future<bool> checkLike(int songId, String jwt) async {
    final response = await http.get(
        Uri.parse('${Constants.baseApi}/likes/check?songId=${songId}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        }
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<List<Song>> getLikedSongs(int userId, String jwt) async {
    final response = await http.get(
        Uri.parse('${Constants.baseApi}/likes/user'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        }
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Song> songs = body.map((dynamic item) => Song.fromJson(item)).toList();
      return songs;
    } else {
      throw Exception(json.decode(response.body));
    }
  }
}
