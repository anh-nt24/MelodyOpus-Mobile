import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:melodyopus/audio_helpers/audio_manager.dart';
import 'package:melodyopus/views/pages/homepage.dart';
import 'package:melodyopus/views/pages/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> checkFirstLaunch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences.getBool("first_launch") ?? true; // true if first installed
    if (isFirstLaunch) {
      await sharedPreferences.setBool("first_launch", false);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFirstLaunch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error
          return Scaffold(
            body: Center(
              child: Text('Error loading app'),
            ),
          );
        } else {
          bool isFirstLaunch = snapshot.data ?? true;
          return AnimatedSplashScreen(
            splash: Column(
              children: [
                Center(child: Lottie.asset("assets/Animation - 1719685180218.json")),
              ],
            ),
            nextScreen: isFirstLaunch ? Onboarding() : Homepage(),
            backgroundColor: Color.fromRGBO(35, 25, 69, 1.0),
            splashIconSize: 400,
          );
        }
      },
    );
  }
}
