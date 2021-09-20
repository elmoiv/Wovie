import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import '../controllers/sharedprefs_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void jumpToLoginOrMain() async {
    // Initializing Database
    DbHelper dbHelper = DbHelper();
    await dbHelper.getDbInstance();

    // Initializing SharedPrefs
    dynamic API_KEY = SharedPrefs().prefs!.getString('API_KEY');

    Duration threeSeconds = Duration(seconds: 2);
    await Future.delayed(threeSeconds, () {});

    // Checking for API_KEY
    if (API_KEY == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
      return;
    }

    /// First Time init only for TMDB will save the api key
    TMDB(apiKey: API_KEY);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    this.jumpToLoginOrMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSquareCircle(
          color: Theme.of(context).accentColor,
          size: 80.0,
        ),
      ),
    );
  }
}
