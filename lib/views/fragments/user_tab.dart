import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/services/history_service.dart';
import 'package:melodyopus/services/like_service.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/download.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/get_avatar.dart';
import 'package:melodyopus/views/widgets/gradient_button.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:melodyopus/views/widgets/song_card_rec.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {

  late final HistoryService _historyService;
  late final SongService _songService;
  late final LikeService _likeService;
  List<Map<String, dynamic>> _songs = [];
  List<Song> _likedSongs = [];

  bool _isLoading = true;
  bool _isLoadingLikedSong = true;

  Timer? _timer;

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _historyService = HistoryService(AudioPlayer());
    _songService = SongService();
    _likeService = LikeService();

    _loadSongs();
    _loadLikedSongs();

    // auto refresh every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _loadSongs(isFirst: false);
      _loadLikedSongs(isFirst: false);
    });
  }

  Future<void> _loadLikedSongs({bool isFirst=true}) async {
    if (isFirst) {
      setState(() {
        _isLoadingLikedSong = true;
      });
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      User user = authProvider.user;
      if (user.id > -1) {
        List<Song> fetchedSong = await _likeService.getLikedSongs(user.id, user.jwt);
        setState(() {
          _likedSongs = fetchedSong.reversed.toList();
        });
      }
    } catch (e) {
      print("Error loading songs: $e");
    } finally {
      setState(() {
        _isLoadingLikedSong = false;
      });
    }
  }

  Future<void> _loadSongs({bool isFirst=true}) async {
    if (isFirst) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final songHistories = await _historyService.getSongsInHistory();
      final List<Map<String, dynamic>> updatedSongs = [];

      for (var songHistory in songHistories.reversed) {
        Song song = await _songService.getSongById(songHistory['song_id']);

        var updatedSongHistory = Map<String, dynamic>.from(songHistory);
        updatedSongHistory['song'] = song;
        updatedSongs.add(updatedSongHistory);
      }

      setState(() {
        _songs = updatedSongs;
      });
    } catch (e) {
      print("Error loading songs: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviver = Provider.of<AuthProvider>(context);
    User user = authProviver.user;

    final musicPlayer = Provider.of<MusicPlayerProvider>(context);

    if (user.id < 0) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Column(
                children: [
                  const SizedBox(height: 200,),
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: getUserAvatar(user),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Sign in to enjoy offline playback\n and other awesome features.',
                    style: TextStyle(color: Colors.white, fontSize: 17,),
                  ),
                ],
              )),


              GradientButton(
                text: "Sign in",
                icon: Icons.login,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login())
                  );
                }),

              SizedBox(height: 50)
            ],
          )
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(top: 20, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MediaButtonController(
                    function: () {},
                    icon: Icons.search,
                  ),
                  MediaButtonController(
                    function: () {},
                    icon: Icons.settings,
                    size: 25,
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  // avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color.fromRGBO(0, 219, 252, 1), width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: getUserAvatar(user, textSize: 30),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // HISTORY
              Row(
                children: [
                  Text(
                      "History",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)
                  ),

                  MediaButtonController(
                      function: () {},
                      icon: Icons.arrow_forward_ios,
                      size: 20,
                  ),
                ],
              ),

              Container(
                height: 110,
                child: _isLoading
                    ? Center(child: Loading())
                    : ListView.builder(
                      itemCount: _songs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final songHistory = _songs[index];
                        Song song = songHistory['song'];
                        double percentage = (song.duration == 0)? 0.0 : (songHistory['position']/song.duration);
                        return GestureDetector(
                            onTap: () {
                              musicPlayer.setPlaylist([song], index: index);
                              musicPlayer.setFullScreen(true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PlayMusic())
                              );
                            },
                            child: Container(
                              height: 123,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: SongCardRec(title: song.title, image: song.thumbnail, author: song.author, percentage: percentage),
                              )
                            )
                        );
                      },
                ),
              ),

              SizedBox(height: 15),

              // PLAYLISTS
              Row(
                children: [
                  Text(
                      "Liked songs",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)
                  ),

                  MediaButtonController(
                    function: () {},
                    icon: Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ],
              ),

              Container(
                height: 105,
                child: _isLoadingLikedSong
                    ? Center(child: Loading())
                    : ListView.builder(
                  itemCount: _likedSongs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Song song = _likedSongs[index];
                    return GestureDetector(
                        onTap: () {
                          musicPlayer.setPlaylist(_likedSongs, index: index);
                          musicPlayer.setFullScreen(true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlayMusic())
                          );
                        },
                        child: Container(
                            height: 123,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: SongCardRec(title: song.title, image: song.thumbnail, author: song.author),
                            )
                        )
                    );
                  },
                ),
              ),

              SizedBox(height: 25),

              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Container(
                  height: 1,
                  color: Colors.white38,
                ),
              ),


              // DOWNLOADS
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Download())
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: MediaButtonController(
                        icon: Icons.download_for_offline_outlined,
                        function: () {},
                      ),
                    ),
                    Text(
                        "Downloads",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,)
                    ),
                  ],
                ),
              ),

              // TIMES LISTENED
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: MediaButtonController(
                      icon: Icons.stacked_line_chart,
                      function: () {},
                    ),
                  ),
                  Text(
                      "Time watched",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,)
                  ),
                ],
              ),
            ],
          ),
        )
      );
    }
  }
}
