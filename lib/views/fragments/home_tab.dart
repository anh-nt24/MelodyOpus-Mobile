import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/services/sharedpreference_service.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/genre_card.dart';
import 'package:melodyopus/views/widgets/get_avatar.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:melodyopus/views/widgets/song_card_rec.dart';
import 'package:melodyopus/views/widgets/song_card_square.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  final SongService _songService = SongService();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  List<Song> _songs = [];
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void dispose() {
    // TODO: implement dispose
    MusicPlayerProvider().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSongs();

    _scrollController1.addListener(() {
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent && !_isLoading) {
        _loadMoreSongs();
      }
    });

    _scrollController2.addListener(() {
      if (_scrollController2.position.pixels == _scrollController2.position.maxScrollExtent && !_isLoading) {
        _loadMoreSongs();
      }
    });
  }

  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      PaginatedResponse<Song> response = await _songService.getAllSongs(
        page: _currentPage,
        pageSize:  _pageSize
      );
      setState(() {
        _songs = response.content;
        _hasMore = _currentPage < response.totalPages - 1;
      });
    } catch (e) {
      print(e);
      CustomSnackBar.show(context: context, content: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreSongs() async {
    if (!_hasMore) {
      CustomSnackBar.show(context: context, content: "You've reached the end of the song list");
      return ;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PaginatedResponse<Song> response = await _songService.getAllSongs(
        page: _currentPage + 1,
        pageSize: _pageSize
      );
      setState(() {
        _currentPage++;
        _songs.addAll(response.content);
        _hasMore = _currentPage < response.totalPages - 1;
      });
    } catch (e) {
      CustomSnackBar.show(context: context, content: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayer = Provider.of<MusicPlayerProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    User user = authProvider.user;

    Map<String, String> genres = {
      "assets/indie.png": "Indie",
      "assets/kpop.png": "K-Pop",
      "assets/pop.png": "Pop",
      "assets/r&b.png": "R&B"
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //   left side
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color.fromRGBO(0, 219, 252, 1), width: 2.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: getUserAvatar(user),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hello
                                Text("Hello,", style: TextStyle(color: Colors.white, fontSize: 20),),
                                Text(
                                  user.username,
                                  style: TextStyle(color: Colors.white70, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        )
                      ],
                    )),


                    //   right side
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: Colors.white, size: 25), SizedBox(width: 20),
                        Icon(Icons.notifications, color: Colors.white, size: 25), SizedBox(width: 20),
                        Icon(Icons.settings, color: Colors.white, size: 25), SizedBox(width: 20),
                      ],
                    )

                  ],
                ),

                SizedBox(height: 30,),

//   CONTINUE LISTENING
                Text(
                    "Continue Listening",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)
                ),

                SizedBox(height: 10,),

                Container(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (int i=0;i<3; ++i)
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: SongCardRec(title: "Nhan Gio May Rang Anh Yeu Em", image: "assets/music_poster.jpg", author: "Hoang Hai", percentage: 0.5,),
                          ),

                        const SizedBox(width: 5),//
                      ],
                    )
                ),

                SizedBox(height: 30,),

// FOR YOU

                Row(
                  children: [
                    Text(
                        "Made for you",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white)
                  ],
                ),

                SizedBox(height: 10),

                Container(
                  height: 230,
                  child: ListView.builder(
                    controller: _scrollController1,
                    scrollDirection: Axis.horizontal,
                    itemCount: _songs.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _songs.length) {
                        return Center(child: Loading());
                      }
                      return GestureDetector(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: SongCardSquare(
                                  title: _songs[index].title,
                                  image: _songs[index].thumbnail,
                                  author: _songs[index].author)
                          ),
                          onTap: () {
                            musicPlayer.setPlaylist([_songs[index]]);
                            musicPlayer.setFullScreen(true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PlayMusic())
                            );
                          },
                        );
                    },
                  ),
                  ),


                SizedBox(height: 30,),

// TRENDING

                Row(
                  children: [
                    Text(
                        "Trending",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white)
                  ],
                ),

                SizedBox(height: 10),

                Container(
                  height: 500,
                  child: ListView.builder(
                    controller: _scrollController2,
                    scrollDirection: Axis.horizontal,
                    itemCount: _songs.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _songs.length) {
                        return Center(child: Loading());
                      }

                      int startIndex = index * 2;
                      int endIndex = (startIndex + 2).clamp(0, _songs.length);

                      return Column(
                        children: [
                          for (int i = startIndex; i < endIndex; i++)
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: SongCardSquare(
                                  title: _songs[i].title,
                                  image: _songs[i].thumbnail,
                                  author: _songs[i].author,
                                ),
                              ),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => PlayMusic())
                                // );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),


                SizedBox(height: 30,),


// NEW HITS

                Row(
                  children: [
                    Text(
                        "New hits",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white)
                  ],
                ),

                SizedBox(height: 10),


                // FutureBuilder<List<Song>>(
                //     future: songs,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         List<Song> songList = snapshot.data!;
                //         return Container(
                //           height: 500,
                //           child: ListView(
                //             scrollDirection: Axis.horizontal,
                //             children: [
                //               for (int i=0; i<songList.length; i+=2)
                //                 Column(
                //                   children: [
                //                     for (int j=0; j<2 && i+j<songList.length;++j)
                //                       GestureDetector(
                //                         child: Padding(
                //                             padding: EdgeInsets.all(5),
                //                             child: SongCardSquare(
                //                                 title: songList[i+j].title,
                //                                 image: songList[i+j].thumbnail,
                //                                 author: songList[i+j].author)
                //                         ),
                //                         onTap: () {
                //                           // Navigator.push(
                //                           //     context,
                //                           //     MaterialPageRoute(builder: (context) => PlayMusic(song: songList[i+j]))
                //                           // );
                //                         },
                //                       )
                //                   ],
                //                 )
                //             ],
                //           ),
                //         );
                //       } else if (snapshot.hasError) {
                //         return Center(child: Text('Error loading songs: ${snapshot.error}', style: TextStyle(color: Colors.white),));
                //       } else {
                //         return Center(child: Loading());
                //       }
                //     }
                // ),

                SizedBox(height: 30,),

// TOP GENRE

                Row(
                  children: [
                    Text(
                        "Top genres",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)
                    ),

                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white)
                  ],
                ),

                SizedBox(height: 10),

                Wrap(
                  spacing: 5.0, // Horizontal spacing between children
                  runSpacing: 5.0, // Vertical spacing between lines
                  children: [
                    for (var e in genres.entries)
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: GenreCard(image: e.key, genre: e.value),
                      ),
                  ],
                ),

                SizedBox(height: 30,),

              ],
            ),
          )
        ],
      )
    );
  }
}