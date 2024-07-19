import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/repositories/song_repository.dart';

class SongService {
  SongService._internal();
  static final SongService _instance = SongService._internal();
  factory SongService() => _instance;

  SongRepository _songRepository = SongRepository();

  Future<List<Song>> getAllSongs() async {
    Map<String, dynamic> response = await _songRepository.get('/song/');
    List<dynamic> content = response['content'];
    List<Song> songs = content.map((json) => Song.fromJson(json)).toList();
    return songs;
  }
}