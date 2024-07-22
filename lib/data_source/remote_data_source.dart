import 'dart:convert';

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
}