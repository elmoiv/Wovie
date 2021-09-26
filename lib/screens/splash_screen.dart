import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/widgets/msg_box.dart';
import '../controllers/sharedprefs_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isError = false;

  @override
  void initState() {
    super.initState();
    jumpToLoginOrMain();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String iconType =
        'images/icon_letter_${Get.isDarkMode ? "dark" : "light"}.png';
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'wovie',
                child: Container(
                  width: screenWidth / 2,
                  height: screenWidth / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconType),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: screenHeight / 1.7,
                ),
                Center(
                  child: Text(
                    'Wovie',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: screenWidth / 10,
                        ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SpinKitSquareCircle(
                  color: Theme.of(context).accentColor,
                  size: screenWidth / 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLoginOrMain() async {
    isError = false;
    // Initializing Database
    DbHelper dbHelper = DbHelper();
    await dbHelper.getDbInstance();

    await Future.delayed(Duration(milliseconds: 1750));

    // get API_KEY
    dynamic API_KEY = SharedPrefs().getApiKey();

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

    // Check for Internet issues first
    try {
      // Checking if API_KEY is correct
      if (await TMDB.isNotValidApiKey(apiKey: API_KEY)) {
        showDialog(
          context: context,
          builder: (BuildContext context) => MsgBox(
            title: 'Invalid API Key!',
            content: 'Please check your key or get one from TMDB',
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        return;
      }
    } catch (e) {
      isError = true;
      showDialog(
        context: context,
        builder: (BuildContext context) => MsgBox(
          hideFailureButton: true,
          title: 'Network Error!',
          content: 'Please check your connection or use a VPN.',
        ),
      ).then((value) => jumpToLoginOrMain());
    }
    if (!isError) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    }
  }
}
