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

  Future<Song?> fetchDownloadedSongById(int id) async {
    try {
      return await _localDataSource.fetchSongById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<Song> getRemoteSongById(int id) async {
    try {
      return await _remoteDataSource.getSongById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateListen(int id) async {
    try {
      return await _remoteDataSource.updateListen(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Song>> fetchDownloadedSongs() async {
    try {
      return await _localDataSource.fetchAllSongs();
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<Song>> getAllSongs(int page, int pageSize) async {
    try {
      return await _remoteDataSource.fetchSongs(page, pageSize);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<Song>> getSongsOfUser(String jwt, int page, int pageSize) async {
    try {
      return await _remoteDataSource.fetchSongsOfUser(jwt, page, pageSize);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNewSong(Map<String, dynamic> bodyObject) async {
    try {
      return await _remoteDataSource.addNewSong(bodyObject);
    } catch (e) {
      rethrow;
    }
  }
}