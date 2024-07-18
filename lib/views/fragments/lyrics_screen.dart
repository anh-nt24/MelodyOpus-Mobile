import 'package:flutter/material.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Lyrics screen", style: TextStyle(color: Colors.white),);
  }
}
