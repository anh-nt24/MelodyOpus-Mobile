import 'package:melodyopus/data_source/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class HistoryRepository {
  final LocalDatabaseHelper _databaseHelper = LocalDatabaseHelper();

  Future<void> addHistory(int songId) async {
    final _database = await _databaseHelper.database;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // query the most recent record
    final result = await _database.query(
      'History',
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    // check if the most recent record's song_id is the same as the new one
    if (result.isEmpty || result.first['song_id'] != songId) {
      await _database.insert(
        'History',
        {
          'song_id': songId,
          'timestamp': timestamp,
          'position': 0, // initial position
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> updatePosition(int songId, int position) async {
    final _database = await _databaseHelper.database;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _database.update(
      'History',
      {
        'position': position,
        'timestamp': timestamp,
      },
      where: 'song_id = ?',
      whereArgs: [songId],
    );
  }

  Future<void> stopListening(int songId) async {
    final _database = await _databaseHelper.database;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _database.update(
      'History',
      {
        'timestamp': timestamp,
      },
      where: 'song_id = ?',
      whereArgs: [songId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllSongsInHistory() async {
    final _database = await _databaseHelper.database;
    return await _database.query('History');
  }
}
