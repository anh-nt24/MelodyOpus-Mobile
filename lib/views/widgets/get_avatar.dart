import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';

Widget getUserAvatar(User user) {
  if (user.id == -1) {
    return CircleAvatar(
      backgroundImage: AssetImage(user.avatar),
      radius: 25,
    );
  } else {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/user.jpg',
      image: user.avatar,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) {
        return CircleAvatar(
          radius: 25,
          backgroundColor: _getRandomColorForWhiteText(),
          child: Text(user.avatar, style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20
          )),
        );
      },
    );
  }
}

Color _getRandomColorForWhiteText() {
  final random = Random();

  Color color;
  do {
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);
    color = Color.fromRGBO(red, green, blue, 1.0);
  } while (_getLuminance(color) > 0.8); // Ensure luminance is low enough

  return color;
}

double _getLuminance(Color color) {
  final r = color.red / 255.0;
  final g = color.green / 255.0;
  final b = color.blue / 255.0;

  // Convert to linear space
  final rLinear = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
  final gLinear = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
  final bLinear = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

  // Calculate luminance
  return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
}