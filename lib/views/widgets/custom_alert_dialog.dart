import 'package:flutter/material.dart';

class CustomAlertDialog {
  static void show({
    required BuildContext context,
    String title = '',
    required String message,
    required String button,
    required void Function() function,
  }) {

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(button),
      onPressed: () {
        Navigator.of(context).pop();
        function();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message, style: TextStyle(fontSize: 16)),
      backgroundColor: Colors.white,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
