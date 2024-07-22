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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'lyric': lyric,
      'duration': duration,
      'releaseDate': releaseDate,
      'filePath': filePath,
      'thumbnail': thumbnail,
      'listened': listened,
      'author_id': author_id,
      'author': author,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      lyric: map['lyric'],
      duration: map['duration'],
      releaseDate: map['releaseDate'],
      filePath: map['filePath'],
      thumbnail: map['thumbnail'],
      listened: map['listened'],
      author_id: map['author_id'],
      author: map['author'],
    );
  }

  Song copyWith({
    int? id,
    String? title,
    String? genre,
    String? lyric,
    int? duration,
    String? releaseDate,
    String? filePath,
    String? thumbnail,
    int? listened,
    int? author_id,
    String? author,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      lyric: lyric ?? this.lyric,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      filePath: filePath ?? this.filePath,
      thumbnail: thumbnail ?? this.thumbnail,
      listened: listened ?? this.listened,
      author_id: author_id ?? this.author_id,
      author: author ?? this.author,
    );
  }
}