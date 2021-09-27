import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String iconType =
        'images/icon_letter_${Get.isDarkMode ? "dark" : "light"}.png';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(
            color: Theme.of(context).shadowColor,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Logo
                Container(
                  width: screenWidth / 3.5,
                  height: screenWidth / 3.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(iconType),
                    fit: BoxFit.fill,
                  )),
                ),

                /// Title
                Text(
                  'Wovie',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).shadowColor,
                        fontSize: screenWidth / 17,
                      ),
                ),
                SizedBox(
                  height: screenHeight / 180,
                ),

                /// Wovie version
                Text(
                  'Version 1.0',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).shadowColor.withOpacity(0.6),
                        fontWeight: FontWeight.normal,
                        fontSize: screenWidth / 24,
                      ),
                ),
                SizedBox(
                  height: screenHeight / 30,
                ),

                /// Wovie Info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight / 40),
                  child: Text(
                    'Wovie is a Movie Surfing magazine-like app focused on simplicity, performance and efficiency.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).shadowColor.withOpacity(0.6),
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth / 24,
                        ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                Text(
                  'Powered By',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).shadowColor.withOpacity(0.6),
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: screenWidth / 24,
                      ),
                ),
                SizedBox(
                  height: screenHeight / 100,
                ),
                Container(
                  width: screenWidth / 5,
                  height: screenWidth / (5 * 1.39),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/tmdb.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: RawMaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (await canLaunch('https://www.themoviedb.org/')) {
                        await launch('https://www.themoviedb.org/');
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight / 40),
                  child: Text(
                    'Copyright © Khaled El-Morshedy 2021.\nAll rights reserved.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).shadowColor.withOpacity(0.6),
                          fontSize: screenWidth / 24,
                        ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customPictureButton(
                      picPath: 'images/github.png',
                      squareWidth: screenWidth / 10,
                      url: 'https://github.com/elmoiv',
                    ),
                    SizedBox(
                      width: screenWidth / 18,
                    ),
                    customPictureButton(
                      picPath: 'images/linkedin.png',
                      squareWidth: screenWidth / 10,
                      url: 'https://www.linkedin.com/in/elmoiv/',
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customPictureButton(
      {String? picPath, String? url, double? squareWidth}) {
    return Container(
      width: squareWidth,
      height: squareWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(picPath!),
          fit: BoxFit.fill,
        ),
      ),
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(squareWidth!),
        ),
        onPressed: () async {
          if (await canLaunch(url!)) {
            await launch(url);
          }
        },
      ),
    );
  }
}
