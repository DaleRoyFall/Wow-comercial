import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:wow_comercial/helper/size_config.dart';

// Check if there is a network connection
Future<bool> verifyConection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) return false;

  return true;
}

// Build snackbar if not connected
void buildLostConnectionSnackBar(BuildContext context) {
  final snackbar = new SnackBar(
    content: Text("Lost connection\nWe'll try to reconnect after 5 seconds",
        style: TextStyle(
            fontSize: SizeConfig.adaptFontSize(4),
            fontWeight: FontWeight.bold)),
    action: SnackBarAction(
      label: "Undo",
      onPressed: () {},
    ),
    duration: Duration(days: 365),
  );

  // Show snackbar
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);
}
