import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/services/sharedpreference_service.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/get_avatar.dart';
import 'package:melodyopus/views/widgets/gradient_button.dart';
import 'package:melodyopus/views/widgets/loading.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  late User _user;
  bool isUserLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final sharedPreferencesService = SharedPreferencesService();
    final loadedUser = await sharedPreferencesService.getUserInfo();

    if (loadedUser != null) {
      setState(() {
        _user = loadedUser;
        isUserLoaded = true;
      });
    } else {
      setState(() {
        isUserLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserLoaded) {
      return Scaffold(
        body: Center(child: Loading())
      );
    }
    if (_user == null || _user!.id < 0) {
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
                      child: getUserAvatar(_user!),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      );
    }
  }
}
