import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/repositories/song_repository.dart';

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
}