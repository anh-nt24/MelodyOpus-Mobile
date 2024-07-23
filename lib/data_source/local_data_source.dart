import 'package:melodyopus/data_source/database_helper.dart';
import 'package:melodyopus/models/song.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSource {
  final LocalDatabaseHelper _databaseHelper = LocalDatabaseHelper();

  Future<void> insertSong(Song song) async {
    final db = await _databaseHelper.database;
    await db.insert('Songs', song.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Song?> fetchSongById(int id) async {
    final db = await _databaseHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'Songs',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Song.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Song>> fetchAllSongs() async {
    final db = await _databaseHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('Songs');
      if (maps.isEmpty) {
        return [];
      }
      return List.generate(maps.length, (i) {
        return Song.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error');
      return [];
    }
  }
}