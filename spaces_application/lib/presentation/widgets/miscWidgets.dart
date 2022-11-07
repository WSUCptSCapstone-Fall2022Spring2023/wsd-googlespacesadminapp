// Misc Widgets and methods commonly used to avoid redundancy

import 'package:flutter/material.dart';

class MiscWidgets {
  static void showException(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
