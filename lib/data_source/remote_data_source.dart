import 'dart:convert';
import 'dart:io';

import 'package:melodyopus/constants.dart';
import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  Future<PaginatedResponse<Song>> fetchSongs(int page, int pageSize) async {
    final response = await http.get(
        Uri.parse('${Constants.baseApi}/song?page=$page&size=$pageSize'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );

    if (response.statusCode == 200) {
      return PaginatedResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
              (json) => Song.fromJson(json)
      );
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<PaginatedResponse<Song>> fetchSongsOfUser(String jwt, int page, int pageSize) async {
    final response = await http.get(
        Uri.parse('${Constants.baseApi}/song/user?page=$page&size=$pageSize'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        }
    );

    if (response.statusCode == 200) {
      return PaginatedResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
              (json) => Song.fromJson(json)
      );
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<void> addNewSong(Map<String, dynamic> bodyObject) async {
    var uri = Uri.parse('${Constants.baseApi}/song/');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${bodyObject['jwt']}';
    request.fields['title'] = bodyObject['title'];
    request.fields['genre'] = bodyObject['genre'];
    request.fields['lyric'] = bodyObject['lyrics'];
    request.files.add(await http.MultipartFile.fromPath('mp3File', bodyObject['songFile']));
    request.files.add(await http.MultipartFile.fromPath('thumbnail', bodyObject['thumbnail']));

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Error on adding a new song");
    }
  }

  Future<Song> getSongById(int id) async {
    final response = await http.get(
        Uri.parse('${Constants.baseApi}/song/${id}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );

    if (response.statusCode == 200) {
      return Song.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(json.decode(response.body));
    }
  }
}