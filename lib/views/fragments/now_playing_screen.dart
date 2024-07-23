import 'dart:io';

import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/services/sharedpreference_service.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/custom_alert_dialog.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final AnimationController animationController;
  NowPlayingScreen({super.key, required this.song, required this.animationController});


  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>{
  bool isDownloaded = false;

  final songService = SongService();
  late Song? _song;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSong();
  }

  void _initSong() async {
    _song = await songService.getADownLoadedSongById(widget.song.id);
    if (_song != null) {
      setState(() {
        isDownloaded = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    String imageSrc = widget.song.thumbnail;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: isDownloaded ?
                  Image.file(
                    File(imageSrc),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/music_placeholder.png', fit: BoxFit.cover);
                    },
                  ) :
                  FadeInImage.assetNetwork(
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
                MediaButtonController(function: () {}, icon: Icons.share, size: 22,),
                _handleDownloadSong(),
                MediaButtonController(function: () {}, icon: Icons.playlist_add),
                MediaButtonController(function: () {}, icon: Icons.favorite_border),
              ],
            )
          ],
        )
      )
    );
  }

  Widget _handleDownloadSong() {
    return MediaButtonController(
      function: () async {
        if (!isDownloaded) {
          final sharePrefService = SharedPreferencesService();
          bool isLoggedIn = await sharePrefService.isLoggedIn();
          if (!isLoggedIn) {
            CustomAlertDialog.show(
                context: context,
                title: "Alert",
                message: "You have to log in to use this feature",
                button: "Log in",
                function: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login())
                  );
                }
            );
          } else {
            try {
              print('Downloading');
              CustomSnackBar.show(
                  context: context,
                  content: "Downloading"
              );
              final songService = SongService();
              await songService.downloadSong(widget.song);
              CustomSnackBar.show(
                  context: context,
                  content: "Download successfully"
              );
              print('Download successfully');
            } catch (e) {
              print('Download failed');
              print(e);
              CustomSnackBar.show(
                  context: context,
                  content: "Download failed"
              );
            }
          }
        }
      },
      icon: isDownloaded ? Icons.download_done : Icons.download,
      size: 22,
    );
  }
}
