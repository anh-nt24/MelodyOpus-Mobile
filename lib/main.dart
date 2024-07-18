import 'package:flutter/material.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/providers/music_play_provider.dart';
import 'package:melodyopus/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
    ],
    child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melody Opus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Base color for generating the color scheme
          background: Color.fromRGBO(35, 11, 61, 1.0), // Custom background color
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}