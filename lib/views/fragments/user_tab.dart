import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/views/pages/download.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/get_avatar.dart';
import 'package:melodyopus/views/widgets/gradient_button.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:melodyopus/views/widgets/song_card_rec.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  Text(user.name, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),),
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
