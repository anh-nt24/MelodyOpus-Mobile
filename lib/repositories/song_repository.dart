import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:melodyopus/constants.dart';
import 'package:melodyopus/data_source/local_data_source.dart';
import 'package:melodyopus/data_source/remote_data_source.dart';
import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';

class SongRepository {
  SongRepository._internal();

  static final SongRepository _instance = SongRepository._internal();

  factory SongRepository() => _instance;

  final LocalDataSource _localDataSource = LocalDataSource();
  final RemoteDataSource _remoteDataSource = RemoteDataSource();

  Future<void> insertSongLocal(Song song) async {
    await _localDataSource.insertSong(song);
  }

  Future<List<Song>> fetchDownloadedSongs() async {
    return await _localDataSource.fetchAllSongs();
  }

  Future<PaginatedResponse<Song>> getAllSongs(int page, int pageSize) async {
    try {
      return await _remoteDataSource.fetchSongs(page, pageSize);
    } catch (e) {
      rethrow;
    }
  }
}