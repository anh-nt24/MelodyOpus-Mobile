import 'package:flutter/material.dart';
import 'package:melodyopus/constants.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final AnimationController animationController;
  NowPlayingScreen({super.key, required this.song, required this.animationController});


  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>{
  @override
  Widget build(BuildContext context) {
    String imageSrc = widget.song.thumbnail;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // THUMBNAIL DISPLAY

            const SizedBox(height: 40),
            Container(
              height: 280,
              width: 280,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(widget.animationController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/music_placeholder.png',
                    image: imageSrc,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/music_placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              )
            ),


            // ONLINE FEATURES: share, download, add to playlist, like
            SizedBox(height: 80),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Mediabuttoncontroller(function: () {}, icon: Icons.share, size: 22,),
                Mediabuttoncontroller(function: () {}, icon: Icons.download, size: 22,),
                Mediabuttoncontroller(function: () {}, icon: Icons.playlist_add),
                Mediabuttoncontroller(function: () {}, icon: Icons.favorite_border_outlined),
              ],
            )
          ],
        )
      )
    );
  }
}
