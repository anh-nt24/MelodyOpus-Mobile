import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';

class AlbumTab extends StatefulWidget {
  final User user;
  const AlbumTab({super.key, required this.user});

  @override
  State<AlbumTab> createState() => _AlbumTabState();
}

class _AlbumTabState extends State<AlbumTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Hello", style: TextStyle(color: Colors.white),)),
    );
  }
}
