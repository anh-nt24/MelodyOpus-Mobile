import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/models/paginated_response.dart';
import 'package:melodyopus/models/song.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/pages/add_new_song.dart';
import 'package:melodyopus/views/pages/play_music.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:melodyopus/views/widgets/song_card_rec_option.dart';
import 'package:provider/provider.dart';

class SongTab extends StatefulWidget {
  final User user;
  const SongTab({super.key, required this.user});

  @override
  State<SongTab> createState() => _SongTabState();
}

class _SongTabState extends State<SongTab> {
  final SongService _songService = SongService();
  final ScrollController _scrollController = ScrollController();
  List<Song> _songs = [];
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSongs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _loadMoreSongs();
      }
    });
  }



  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      PaginatedResponse<Song> response = await _songService.getSongsOfUser(
        widget.user.jwt,
        page: _currentPage,
        pageSize:  _pageSize
      );
      setState(() {
        _songs = response.content;
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

  Future<void> _loadMoreSongs() async {
    if (!_hasMore) {
      CustomSnackBar.show(context: context, content: "You've reached the end of the song list");
      return ;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PaginatedResponse<Song> response = await _songService.getSongsOfUser(
          widget.user.jwt,
          page: _currentPage,
          pageSize:  _pageSize
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: _songs.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _songs.length) {
            return Center(child: Loading());
          }

          Song song = _songs[index];
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
                height: 90,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: SongCardRecOption(
                  title: song.title,
                  image: song.thumbnail,
                  author: song.author,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                ),
              )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>AddNewSong())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
