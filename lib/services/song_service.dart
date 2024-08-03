import 'dart:io';

import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/repositories/song_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SongService {
  SongService._internal();
  static final SongService _instance = SongService._internal();
  factory SongService() => _instance;

  SongRepository _songRepository = SongRepository();


  Future<PaginatedResponse<Song>> getAllSongs({int page=0, int pageSize=20}) async {
    try {
      return await _songRepository.getAllSongs(page, pageSize);
    } catch (e) {
      rethrow;
    }
  }

  Future<Song> getSongById(int id) async {
    try {
      return await _songRepository.getRemoteSongById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateListen(int id) async {
    try {
      return await _songRepository.updateListen(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<Song>> getSongsOfUser(String jwt, {int page=0, int pageSize=20}) async {
    try {
      return await _songRepository.getSongsOfUser(jwt, page, pageSize);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Song>> getDownloadedSongs() async {
    try {
      return await _songRepository.fetchDownloadedSongs();
    } catch (e) {
      rethrow;
    }
  }

  Future<Song?> getADownLoadedSongById(int id) async {
    try {
      return await _songRepository.fetchDownloadedSongById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadSong(Song song) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final songFilePath = '${directory.path}/${_getCurrentDateTime()}.mp3';
      final thumbnailFilePath = '${directory.path}/${_getCurrentDateTime()}.jpg';

      // download song
      final songResponse = await http.get(Uri.parse(song.filePath));
      final songFile = File(songFilePath);
      await songFile.writeAsBytes(songResponse.bodyBytes);

      // download thumbnail
      final imageResponse = await http.get(Uri.parse(song.thumbnail));
      final imageFile = File(thumbnailFilePath);
      await imageFile.writeAsBytes(imageResponse.bodyBytes);

      final downloadedSong = song.copyWith(
          filePath: songFilePath,
          thumbnail: thumbnailFilePath
      );

      final songRepository = SongRepository();
      await songRepository.insertSongLocal(downloadedSong);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return formattedDateTime;
  }

  Future<void> addNewSong(Map<String, dynamic> bodyObject) async {
    try {
      return await _songRepository.addNewSong(bodyObject);
    } catch (e) {
      rethrow;
    }
  }
}