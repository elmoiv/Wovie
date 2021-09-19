import 'package:flutter/material.dart';
import 'package:wovie/screens/splash_screen.dart';

void main() {
  runApp(Wovie());
}

/// TODO: Find a way to show spinkit before youtube opens (Because youtube is loaded as invisible widgets)
///       and thus feels like user is waiting for nothing
/// TODO: Implement fav and watch list
/// TODO: Implement Search
/// TODO: [Optional] Add Guest login without api key with limited features
class Wovie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wovie',
      theme: ThemeData(fontFamily: 'SourceSansPro'),
      home: SplashScreen(),
    );
  }
}
