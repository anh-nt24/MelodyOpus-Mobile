import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/views/widgets/mini_player.dart';
import 'package:provider/provider.dart';
import '../fragments/explore_tab.dart';
import '../fragments/home_tab.dart';
import '../fragments/library_tab.dart';
import '../fragments/user_tab.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  bool _showMiniPlayer = true;
  late MusicPlayerProvider musicPlayer;

  @override
  void initState() {
    super.initState();
    musicPlayer = Provider.of<MusicPlayerProvider>(context, listen: false);
    musicPlayer.addListener(_onMusicPlayerChanged);
  }

  void _onMusicPlayerChanged() {
    if (mounted) {
      setState(() {
        if (musicPlayer.isPlaying) {
          print('Music playing');
          setState(() {
            _showMiniPlayer = true;
          });
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var selectedIconColor = Color.fromRGBO(140, 131, 234, 1.0);
  var unselectedIconColor = Color.fromRGBO(142, 142, 142, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              HomeTab(),
              ExploreTab(),
              LibraryTab(),
              UserTab(),
            ],
          ),
          if (_showMiniPlayer)
            Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(onDismiss: () {
                setState(() {
                  _showMiniPlayer = false;
                });
              }),
            ),
        ],
      ),

      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizontal,
          bubbleFillStyle: BubbleFillStyle.fill,
          unselectedIconColor: unselectedIconColor,
        ),
        items: [
          BottomBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text('Home'),
            selectedColor: selectedIconColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.search_outlined),
            title: Text('Explore'),
            selectedColor: selectedIconColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.library_music_outlined),
            title: Text('Library'),
            selectedColor: selectedIconColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Me'),
            selectedColor: selectedIconColor,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.09),

      ),
    );

  }
}