import 'dart:async';

import 'package:astro_app/screens/base_screen.dart';
import 'package:astro_app/utils/img_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 1), navigateMainScreen);
    super.initState();
  }

  navigateMainScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => BaseScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Image.asset(
          logo,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width*0.5,
        ),
      ),
    );
  }
}
