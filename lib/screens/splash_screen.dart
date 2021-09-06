import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:wovie/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;

  void jumpToLoginOrMain() async {
    // Initializing Database
    DbHelper dbHelper = DbHelper();
    await dbHelper.getDbInstance();

    // Initializing SharedPrefs
    prefs = await SharedPreferences.getInstance();
    dynamic API_KEY = prefs!.getString('API_KEY');

    Duration threeSeconds = Duration(seconds: 2);
    await Future.delayed(threeSeconds, () {});

    // Checking for API_KEY
    if (API_KEY == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            prefs: prefs,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(apiKey: API_KEY),
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
          color: Color(0xff2196f3),
          size: 80.0,
        ),
      ),
    );
  }
}
