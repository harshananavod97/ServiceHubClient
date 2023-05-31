import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub_client/provider/auth_provider.dart';
import 'package:servicehub_client/widget/app_name_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Provider.of<AuthProvider>(context, listen: false).initializeUser(context);
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (BuildContext context) => const ProfileScreen()));
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Center(child: AppNameWidget()),
      ),
    );
  }
}
