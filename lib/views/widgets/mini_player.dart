import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:provider/provider.dart';


class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final musicPlayer = Provider.of<MusicPlayerProvider>(context);
    Song? currentSong = musicPlayer.currentSong;

    setState(() {
      isPlaying = musicPlayer.isPlaying;
    });

    if (currentSong == null || !musicPlayer.isPlaying) {
      return const SizedBox.shrink(); // empty widget
    }

    return GestureDetector(
      onTap: () {
        musicPlayer.setPlaylist(musicPlayer.playlist, index: musicPlayer.currentIndex);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayMusic()),
        );
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Color.fromRGBO(140, 131, 234, 0.99),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  currentSong.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/music_placeholder.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentSong.title,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.author,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ),

            Container(
              width: 30,
              padding: EdgeInsets.zero,
              child: Mediabuttoncontroller(
                function: () {
                  musicPlayer.playPrevious();
                },
                icon: Icons.skip_previous,
                size: 25,
              ),
            ),

            Container(
              width: 30,
              padding: EdgeInsets.zero,
              child: Mediabuttoncontroller(
                function: () {
                  if (!isPlaying) {
                    musicPlayer.pause();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    musicPlayer.play();
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                icon: isPlaying ? Icons.pause : Icons.play_arrow,
                size: 25,
              ),
            ),

            Container(
              width: 30,
              padding: EdgeInsets.zero,
              child: Mediabuttoncontroller(
                function: () {
                  musicPlayer.playNext();
                },
                icon: Icons.skip_next,
                size: 25,
              )
            ),


          ],
        ),
      ),
    );
  }
}
