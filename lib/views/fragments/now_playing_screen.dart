import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/services/like_service.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/custom_alert_dialog.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final AnimationController animationController;
  NowPlayingScreen({super.key, required this.song, required this.animationController});


  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>{
  bool isDownloaded = false;
  bool isLiked = false;
  bool isLoading = true;
  bool isLoggedIn = false;
  IconData likeIcon = Icons.favorite_border;
  IconData downloadIcon = Icons.download;

  final songService = SongService();
  final likeService = LikeService();
  late Song? _song;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSong();
    _initUserData();
  }

  Future<void> _initUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User user = authProvider.user;

    if (user.id == -1) {
      setState(() {
        isLoading = false;
        isLiked = false;
        isLoggedIn = false;
      });
      return;
    }

    bool _isLiked = await likeService.checkLike(widget.song.id, user.jwt);
    setState(() {
      isLoggedIn = true;
      isLiked = _isLiked;
      if (_isLiked) {
        likeIcon = Icons.favorite;
      } else {
        likeIcon = Icons.favorite_border;
      }
      isLoading = false;
    });
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
                _handleLikeSong(),
              ],
            )
          ],
        )
      )
    );
  }

  Widget _handleLikeSong() {
    return MediaButtonController(
      function: () async {
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
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          User user = authProvider.user;
          int songId = widget.song.id;
          String jwt = user.jwt;
          if (isLiked) {
            try {
              await likeService.unLike(songId, jwt);
              setState(() {
                likeIcon = Icons.favorite_border;
                isLiked = false;
              });
              CustomSnackBar.show(
                  context: context,
                  content: "You unliked this song!"
              );
            } catch (e) {
              CustomSnackBar.show(
                  context: context,
                  content: "Unlike unsuccessfully"
              );
            }
          } else {
            try {
              await likeService.addLike(songId, jwt);
              setState(() {
                likeIcon = Icons.favorite;
                isLiked = true;
              });
              CustomSnackBar.show(
                  context: context,
                  content: "You liked this song!"
              );
            } catch (e) {
              CustomSnackBar.show(
                  context: context,
                  content: "Like unsuccessfully"
              );
            }
          }
        }
      },
      icon: likeIcon
    );
  }

  Widget _handleDownloadSong() {
    return MediaButtonController(
      function: () async {
        if (!isDownloaded) {
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
              setState(() {
                isDownloaded = true;
                downloadIcon = Icons.download_done;
              });
            } catch (e) {
              CustomSnackBar.show(
                  context: context,
                  content: "Download failed"
              );
            }
          }
        }
      },
      icon: downloadIcon,
      size: 22,
    );
  }
}
