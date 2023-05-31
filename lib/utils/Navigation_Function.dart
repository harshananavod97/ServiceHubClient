import 'package:flutter/material.dart';

class NavigationUtillfunction {
  static void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ));
  }
}
