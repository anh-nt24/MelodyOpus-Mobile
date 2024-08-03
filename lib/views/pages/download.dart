import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:melodyopus/views/widgets/song_card_rec.dart';
import 'package:provider/provider.dart';

class Download extends StatefulWidget {
  final bool showConnection;
  const Download({super.key, this.showConnection = false});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool isSongLoaded = false;
  List<Song> _songs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDownloadedSongs();
  }

  Future<void> _loadDownloadedSongs() async {
    final songService = SongService();
    try {
      final downloadedSongs = await songService.getDownloadedSongs();
      setState(() {
        _songs = downloadedSongs;
        isSongLoaded = true;
      });
    } catch (e) {
      print("Error loading downloaded songs: $e");
      setState(() {
        _songs = [];
        isSongLoaded = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!isSongLoaded)
      return Center(child: Loading());

    final musicPlayer = Provider.of<MusicPlayerProvider>(context);



    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white70,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromRGBO(31, 31, 31, 0.09),
      ),
      body: _songs.isEmpty ? Padding(
        padding: EdgeInsets.only(left: 15, top: 15),
        child: Text("No song downloaded", style: TextStyle(color: Colors.white70, fontSize: 20, fontStyle: FontStyle.italic))
      ) :
      ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return GestureDetector(
            onTap: () {
              musicPlayer.setPlaylist(_songs, index: index);
              musicPlayer.setFullScreen(true);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayMusic())
              );
            },
            child: Container(
              height: 95,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SongCardRec(
                  title: song.title,
                  image: song.thumbnail,
                  author: song.author
              ),
            )
          );
        }
      )
      ,
    );
  }
}
