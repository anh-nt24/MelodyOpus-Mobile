import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(
        leftDotColor: Color.fromRGBO(222, 217, 217, 1.0),
        rightDotColor: Color.fromRGBO(233, 112, 142, 1.0),
        size: 30);
  }
}
