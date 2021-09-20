import 'package:flutter/material.dart';
import 'package:wovie/constants.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    accentColor: kMaterialBlueColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    shadowColor: Colors.black,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'SourceSansPro',
      ),

      /// "|" in Details Section
      headline1: TextStyle(
        color: kMaterialBlueColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// Title in Details Section
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// "View All" Button Text Color in Details Section
      headline3: TextStyle(
        color: kMaterialBlueColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// Movie Tile
      headline4: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),
    ),
    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      foregroundColor: Colors.black,
    ),
    sliderTheme: SliderThemeData().copyWith(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      thumbColor: kMaterialBlueColor,
      activeTrackColor: kMaterialBlueColor,
      inactiveTrackColor: kMaterialBlueColor.withOpacity(0.5),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    accentColor: Color(0xffda1b37),
    cardColor: Colors.black,
    shadowColor: Colors.white,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'SourceSansPro',
      ),

      /// "|" in Details Section
      headline1: TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// Title in Details Section
      headline2: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// "View All" Button Text Color in Details Section
      headline3: TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),

      /// Movie Tile
      headline4: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
      ),
    ),
    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: Colors.black,
      shadowColor: Colors.white,
      foregroundColor: Colors.white,
    ),
    sliderTheme: SliderThemeData().copyWith(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      thumbColor: Colors.redAccent,
      activeTrackColor: Colors.redAccent,
      inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    ).copyWith(
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.white.withOpacity(.7),
      selectedLabelStyle: TextStyle(
        color: Colors.redAccent,
        fontFamily: 'SourceSansPro',
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.white.withOpacity(.7),
        fontFamily: 'SourceSansPro',
      ),
    ),
  );
}
