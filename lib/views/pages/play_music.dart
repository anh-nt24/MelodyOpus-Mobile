import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:marquee/marquee.dart';
import 'package:melodyopus/audio_helpers/duration_state.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/views/fragments/lyrics_screen.dart';
import 'package:melodyopus/views/fragments/now_playing_screen.dart';
import 'package:melodyopus/views/fragments/playlist_screen.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({super.key});


  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> with TickerProviderStateMixin{
  int currentPage = 2;
  PageController pageController = PageController(initialPage: 1);
  late LoopMode loopMode;
  late double currentAnimationPosition;
  late AnimationController animationController;

  Color mainColor = const Color.fromRGBO(233, 112, 142, 1.0);

  final musicPlayer = MusicPlayerProvider();
  late Song? _song;


  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    musicPlayer.addListener(_onMusicPlayerChanged);
    _song = musicPlayer.currentSong;

    loopMode = LoopMode.off;
    currentAnimationPosition = 0.0;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20)
    );

    animationController.forward(from: currentAnimationPosition);
    animationController.repeat();
  }

  void _onMusicPlayerChanged() {
    if (mounted && musicPlayer.oldSong != musicPlayer.currentSong) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() {
          _song = musicPlayer.currentSong;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_song == null)
      return Center(child: Loading());
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          musicPlayer.setFullScreen(false);
        }
      },
      child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Color.fromRGBO(31, 31, 31, 0.09),
                leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, size: 25, color: Colors.white70,),
                  onPressed: () {
                    musicPlayer.setFullScreen(false);
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  SizedBox(width: 40,)
                ],
                elevation: 20,
                title: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _song!.title.length > 20 ?
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            height: 20,
                            child: Marquee(
                              text: _song!.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              showFadingOnlyWhenScrolling: true,
                              scrollAxis: Axis.horizontal,
                              blankSpace: 25.0,
                              velocity: 40.0,
                              accelerationCurve: Curves.linear,
                              decelerationCurve: Curves.easeOut,
                            ),
                          )
                      )
                          :
                      Text(
                        _song!.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 5),
                      Text(
                        _song!.author,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                )
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 25,
                    width: 70,
                    child: StepProgressIndicator(
                      totalSteps: 3,
                      currentStep: currentPage,
                      size: 3,
                      customColor: (index) => index == currentPage-1 ? Color.fromRGBO(0, 219, 252, 1) : Colors.grey,
                      roundedEdges: Radius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 460,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          currentPage = page+1;
                        });
                      },
                      children: [
                        PlaylistScreen(),
                        NowPlayingScreen(song: _song!, animationController: animationController),
                        LyricsScreen(),
                      ],
                    ),
                  ),


                  SizedBox(
                      height: 50,
                      child: _getMusicProgressBar(context)
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getSuffleButton(context),
                      _getPreviousButton(context),
                      _getPlayButton(context),
                      _getNextButton(context),
                      _getLoopMode(context),
                    ],
                  )
                ],
              ),
            )
        )
    );
  }

  Widget _getSuffleButton(BuildContext context) {
    return MediaButtonController(
      function: () {},
      icon: Icons.shuffle, color: Colors.white70,
    );
  }

  Widget _getPreviousButton(BuildContext context) {
    return MediaButtonController(
      function: () {
        currentAnimationPosition = 0.0;
        animationController.forward(from: currentAnimationPosition);
        musicPlayer.playPrevious();
      },
      icon: Icons.skip_previous, useBackground: true, backgroundColor: mainColor, size: 25,
    );
  }

  Widget _getNextButton(BuildContext context) {
    return MediaButtonController(
      function: () {
        currentAnimationPosition = 0.0;
        animationController.forward(from: currentAnimationPosition);
        musicPlayer.playNext();
      },
      icon: Icons.skip_next, useBackground: true, backgroundColor: mainColor, size: 25,
    );
  }

  Widget _getLoopMode(BuildContext context) {
    IconData icon;
    Color color;
    final musicPlayer = MusicPlayerProvider();

    if (loopMode == LoopMode.one) {
      icon = Icons.repeat_one;
      color = mainColor;
    } else if (loopMode == LoopMode.all) {
      icon = Icons.repeat;
      color = mainColor;
    } else {
      icon = Icons.repeat;
      color = Colors.white70;
    }

    return MediaButtonController(
      function: () {
        setState(() {
          if (loopMode == LoopMode.one) {
            loopMode = LoopMode.all;
          } else if (loopMode == LoopMode.all) {
            loopMode = LoopMode.off;
          } else {
            loopMode = LoopMode.one;
          }
          // musicPlayer.setLoopMode(loopMode);
        });
      },
      icon: icon,
      color: color,
    );
  }

  StreamBuilder<PlayerState> _getPlayButton(BuildContext context) {
    final musicPlayer = MusicPlayerProvider();
    return StreamBuilder(
      stream: musicPlayer.getPlayerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;


        if (processingState == ProcessingState.loading
          || processingState == ProcessingState.buffering) {
          return Container(
            margin: EdgeInsets.all(13),
            width: 35,
            height: 35,
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if ( playing != true) {
          return MediaButtonController(
            function: () {
              musicPlayer.play();
              animationController.forward(from: currentAnimationPosition);
              animationController.repeat();
            },
            icon: Icons.play_arrow, useBackground: true, backgroundColor:mainColor, size: 35,
          );
        } else if (processingState != ProcessingState.completed) {
          return MediaButtonController(
            function: () {
              musicPlayer.pause();
              animationController.stop();
              currentAnimationPosition = animationController.value;
            },
            icon: Icons.pause, useBackground: true, backgroundColor: mainColor, size: 35,
          );
        } else {
          currentAnimationPosition = 0.0;
          if (loopMode == LoopMode.off) {
            if ((musicPlayer.currentIndex != musicPlayer.playlist.length - 1)) {
              musicPlayer.playNext();
              return const SizedBox.shrink();
            } else {
              animationController.stop();
              return MediaButtonController(
                function: () {
                  musicPlayer.seekTo(Duration.zero);
                  animationController.forward(from: currentAnimationPosition);
                },
                icon: Icons.replay, useBackground: true, backgroundColor: mainColor, size: 35,
              );
            }
          } else if (loopMode == LoopMode.all) {
            musicPlayer.playNext();
            return const SizedBox.shrink();
          } else {
            musicPlayer.seekTo(Duration.zero);
            return const SizedBox.shrink();
          }
        }
      }
    );
  }

  StreamBuilder<DurationState> _getMusicProgressBar(BuildContext context) {
    final musicPlayer = MusicPlayerProvider();
    return StreamBuilder<DurationState>(
      stream: musicPlayer.durationState,
      builder: (context, snapshot) {
        final duration = snapshot.data;
        final progress = duration?.progress ?? Duration.zero;
        final buffer = duration?.buffer ?? Duration.zero;
        final total = duration?.total ?? Duration.zero;

        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffer,
          onSeek: musicPlayer.seekTo,
          baseBarColor: Colors.grey.withOpacity(0.8),
          progressBarColor: mainColor,  // Use your mainColor here
          thumbColor: mainColor,        // Use your mainColor here
          bufferedBarColor: Colors.white.withOpacity(0.5),
          timeLabelTextStyle: TextStyle(
            color: Colors.white70,
          ),
          barHeight: 2,
          thumbRadius: 5,
        );
      }
    );
  }

}
