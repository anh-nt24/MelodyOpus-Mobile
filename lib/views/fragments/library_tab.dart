import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/views/fragments/album_tab.dart';
import 'package:melodyopus/views/fragments/song_tab.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/get_avatar.dart';
import 'package:melodyopus/views/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authProviver = Provider.of<AuthProvider>(context);
    User user = authProviver.user;
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
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Color.fromRGBO(35, 11, 61, 1.0),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.music_note), text: "Your songs"),
              Tab(icon: Icon(CupertinoIcons.music_albums_fill), text: "Your Albums",)
            ],
            labelColor: Color.fromRGBO(140, 131, 234, 1.0),
            unselectedLabelColor: Color.fromRGBO(142, 142, 142, 1),
            padding: EdgeInsets.zero,
            dividerHeight: 0,
            indicatorColor: Color.fromRGBO(140, 131, 234, 1.0),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SongTab(user: user),
            AlbumTab(user: user)
          ],
        ),
      );
    }
  }
}
