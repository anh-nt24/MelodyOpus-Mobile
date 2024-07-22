import 'package:melodyopus/data_source/database_helper.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSource {
  final LocalDatabaseHelper _databaseHelper = LocalDatabaseHelper();

  Future<void> insertSong(Song song) async {
    final db = await _databaseHelper.database;
    await db.insert('Songs', song.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Song>> fetchAllSongs() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Songs');
    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  Future<void> insertUser(User user) async {
    final db = await _databaseHelper.database;
    await db.insert('User', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> fetchUser() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Songs');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }
}