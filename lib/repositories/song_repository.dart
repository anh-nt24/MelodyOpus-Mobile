import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/services/song_service.dart';

class SongRepository {
  SongService _songService = SongService.songInstance;

  Future<List<Song>> getAllSongs() async {
    Map<String, dynamic> response = await _songService.get('/song/');
    List<dynamic> content = response['content'];
    List<Song> songs = content.map((json) => Song.fromJson(json)).toList();
    return songs;
  }
}