import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:melodyopus/audio_helpers/audio_manager.dart';
import 'package:melodyopus/services/network_connection_service.dart';
import 'package:melodyopus/views/pages/download.dart';
import 'package:melodyopus/views/pages/homepage.dart';
import 'package:melodyopus/views/pages/onboarding.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});



  Future<bool> _checkFirstLaunch() async {
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
      future: _checkFirstLaunch(),
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
          if (isFirstLaunch) {
            return AnimatedSplashScreen(
              splash: Column(
                children: [
                  Center(
                      child: Lottie.asset(
                          "assets/Animation - 1719685180218.json")),
                ],
              ),
              nextScreen: Onboarding(),
              backgroundColor: Color.fromRGBO(35, 25, 69, 1.0),
              splashIconSize: 400,
            );
          }
          return FutureBuilder<bool>(
            future: NetworkConnectionService(context).checkNetworkStatus(),
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
                bool isConnected = snapshot.data ?? false;
                return AnimatedSplashScreen(
                  splash: Column(
                    children: [
                      Center(
                          child: Lottie.asset(
                              "assets/Animation - 1719685180218.json")),
                    ],
                  ),
                  nextScreen: isConnected ? Homepage() :  Download(showConnection: true),
                  backgroundColor: Color.fromRGBO(35, 25, 69, 1.0),
                  splashIconSize: 400,
                );
              }
            },
          );
        }
      },
    );
  }
}
