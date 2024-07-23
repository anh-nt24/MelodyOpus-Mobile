import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/views/widgets/song_card_rec.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final musicPlayer = MusicPlayerProvider();
  List<Song> _songs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _songs = musicPlayer.playlist;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return GestureDetector(
              onTap: () {
                musicPlayer.playAtIndex(index);
              },
              child: Container(
                height: 90,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: SongCardRec(
                    title: song.title,
                    image: song.thumbnail,
                    author: song.author,
                    backgroundColor: index == musicPlayer.currentIndex ? Color.fromRGBO(233, 112, 142, 0.8) : null,
                ),
              )
          );
        }
    );
  }
}
