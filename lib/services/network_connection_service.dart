import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';

class NetworkConnectionService {
  final BuildContext context;

  NetworkConnectionService(this.context) {
    monitorNetworkChanges();
  }

  Future<bool> checkNetworkStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void monitorNetworkChanges() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   CustomSnackBar.show(
    //     context: context,
    //     content: 'Checking internet connection...',
    //   );
    // });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // Network restored
        CustomSnackBar.show(
          context: context,
          content: 'Internet network connected',
          backgroundColor: Colors.green,
        );
      } else {
        // No network
        CustomSnackBar.show(
          context: context,
          content: 'No internet network connected',
        );
      }
    });
  }
}