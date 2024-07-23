import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/providers/music_play_provider.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final musicPlayer = MusicPlayerProvider();
  late Song _song;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _song = musicPlayer.currentSong!;
    musicPlayer.addListener(_onMusicPlayerChanged);
  }

  void _onMusicPlayerChanged() {
    if (mounted && musicPlayer.oldSong != musicPlayer.currentSong) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _song = musicPlayer.currentSong!;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30), // Adjust padding as needed
      child: SingleChildScrollView(
        child: Text(
          _song.lyric,
          style: TextStyle(color: Colors.white, fontSize: 16), // Adjust font size as needed
        ),
      ),
    );
  }
}
