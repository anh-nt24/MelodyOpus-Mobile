import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black, // Default color, similar to a toast background
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: duration,
        backgroundColor: backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}