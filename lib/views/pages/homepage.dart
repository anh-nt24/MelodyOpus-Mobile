import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:melodyopus/views/widgets/mini_player.dart';
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
          Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
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