import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  LocalDatabaseHelper._internal();
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'melody_opus.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {

    // create song table
    await db.execute('''
      CREATE TABLE Songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        genre TEXT,
        lyric TEXT,
        duration INTEGER,
        releaseDate TEXT,
        filePath TEXT,
        thumbnail TEXT,
        listened INTEGER,
        author_id INTEGER,
        author TEXT
      )
    ''');

    // create history database
    await db.execute('''
      CREATE TABLE History (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_id INTEGER,
        timestamp INTEGER,
        position INTEGER,
        FOREIGN KEY(song_id) REFERENCES Songs(id)
      )
    ''');

    // create watch later database
    // await db.execute('''
    //   CREATE TABLE WatchLater (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     song_id TEXT,
    //     added_timestamp INTEGER,
    //     FOREIGN KEY(song_id) REFERENCES Songs(song_id)
    //   )
    // ''');

    // create usage tracking database
    await db.execute('''
      CREATE TABLE UsageTracking (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        usage_time INTEGER
      )
    ''');
  }
}
