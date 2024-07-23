import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/views/pages/download.dart';
import 'package:melodyopus/views/pages/homepage.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';

class NetworkConnectionService {
  final BuildContext context;

  NetworkConnectionService(this.context);

  void monitorNetworkChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // Network restored
        CustomSnackBar.show(
          context: context,
          content: 'Network restored',
          backgroundColor: Colors.green
        );
      }
    });
  }
}