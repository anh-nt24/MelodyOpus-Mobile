import 'package:melodyopus/constants.dart';

class Song {
  final int id;
  final String title;
  final String genre;
  final String lyric;
  final int duration;
  final String releaseDate;
  final String filePath;
  final String thumbnail;
  final int listened;
  final int author_id;
  final String author;

  Song({
    required this.id,
    required this.title,
    required this.genre,
    required this.lyric,
    required this.duration,
    required this.releaseDate,
    required this.filePath,
    required this.thumbnail,
    required this.listened,
    required this.author_id,
    required this.author,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      lyric: json['lyric'],
      duration: json['duration'],
      releaseDate: json['releaseDate'],
      filePath: Constants.baseUrl + json['filePath'],
      thumbnail: Constants.baseUrl + json['thumbnail'],
      listened: json['listened'],
      author_id: json['userId'],
      author: json['userName'],
    );
  }
}