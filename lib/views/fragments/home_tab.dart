import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/repositories/song_repository.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/genre_card.dart';
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

  late Future<List<Song>> songs;

  @override
  void dispose() {
    // TODO: implement dispose
    MusicPlayerProvider().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SongService _songService = SongService();
    songs = _songService.getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayer = Provider.of<MusicPlayerProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    Map<String, String> genres = {
      "assets/indie.png": "Indie",
      "assets/kpop.png": "K-Pop",
      "assets/pop.png": "Pop",
      "assets/r&b.png": "R&B"
    };
    User? user = authProvider.getUser();
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //   left side
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color.fromRGBO(0, 219, 252, 1), width: 2.0),
                            image: DecorationImage(
                                image: AssetImage(user!.avatar),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hello
                            Text("Hello,", style: TextStyle(color: Colors.white, fontSize: 20),),
                            Text(" " + user!.username, style: TextStyle(color: Colors.white70, fontSize: 15),),
                          ],
                        )
                      ],
                    ),

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

                FutureBuilder<List<Song>>(
                  future: songs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Song> songList = snapshot.data!;
                      return Container(
                        height: 230,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (Song song in songList)
                              GestureDetector(
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: SongCardSquare(
                                        title: song.title,
                                        image: song.thumbnail,
                                        author: song.author)
                                ),
                                onTap: () {
                                  musicPlayer.setPlaylist([song]);
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => PlayMusic())
                                  );
                                },
                              ),

                            const SizedBox(width: 5),

                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading songs: ${snapshot.error}', style: TextStyle(color: Colors.white),));
                    } else {
                      return Center(child: Loading());
                    }
                }),


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

                FutureBuilder<List<Song>>(
                  future: songs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Song> songList = snapshot.data!;
                      return Container(
                        height: 500,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i=0; i<songList.length; i+=2)
                              Column(
                                children: [
                                  for (int j=0; j<2 && i+j<songList.length;++j)
                                    GestureDetector(
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: SongCardSquare(
                                              title: songList[i+j].title,
                                              image: songList[i+j].thumbnail,
                                              author: songList[i+j].author)
                                      ),
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(builder: (context) => PlayMusic())
                                        // );
                                      },
                                    )
                                ],
                              ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading songs: ${snapshot.error}', style: TextStyle(color: Colors.white),));
                    } else {
                      return Center(child: Loading());
                    }
                  }
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


                FutureBuilder<List<Song>>(
                    future: songs,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Song> songList = snapshot.data!;
                        return Container(
                          height: 500,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i=0; i<songList.length; i+=2)
                                Column(
                                  children: [
                                    for (int j=0; j<2 && i+j<songList.length;++j)
                                      GestureDetector(
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: SongCardSquare(
                                                title: songList[i+j].title,
                                                image: songList[i+j].thumbnail,
                                                author: songList[i+j].author)
                                        ),
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(builder: (context) => PlayMusic(song: songList[i+j]))
                                          // );
                                        },
                                      )
                                  ],
                                )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading songs: ${snapshot.error}', style: TextStyle(color: Colors.white),));
                      } else {
                        return Center(child: Loading());
                      }
                    }
                ),

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