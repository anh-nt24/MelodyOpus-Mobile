import 'package:flutter/material.dart';

class MediaButtonController extends StatefulWidget {
  final void Function()? function;
  final IconData icon;
  final double size;
  final Color color;
  final bool useBackground;
  final Color backgroundColor;

  const MediaButtonController({
    super.key,
    required this.function,
    required this.icon,
    this.size = 25,
    this.color = Colors.white,
    this.useBackground = false,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<MediaButtonController> createState() => _MediaButtonControllerState();
}

class _MediaButtonControllerState extends State<MediaButtonController> {
  @override
  Widget build(BuildContext context) {
    if (widget.useBackground == true) {
      return CircleAvatar(
        child: IconButton(
            onPressed: widget.function,
            icon: Icon(widget.icon, size: widget.size, color: widget.color)
        ),
        backgroundColor: widget.backgroundColor,
        radius: widget.size - 5,
      );
    } else {
      return IconButton(
        onPressed: widget.function,
        icon: Icon(widget.icon, size: widget.size, color: widget.color),
      );
    }
  }
}
