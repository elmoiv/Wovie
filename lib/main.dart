import 'package:flutter/material.dart';
import 'package:wovie/screens/splash_screen.dart';

void main() {
  runApp(Wovie());
}

class Wovie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wovie',
      // theme: ThemeData.dark().copyWith(
      //   primaryColor: Color(0xff0a0d22),
      //   scaffoldBackgroundColor: Color(0xff0a0d22),
      // ),
      theme: ThemeData(fontFamily: 'SourceSansPro'),
      home: SplashScreen(),
    );
  }
}
