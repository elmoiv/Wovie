import 'package:flutter/material.dart';
import 'package:wovie/constants.dart';

class Themes {
  /// Light Theme
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
      elevation: 1,
    ),
    sliderTheme: SliderThemeData().copyWith(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      thumbColor: kMaterialBlueColor,
      activeTrackColor: kMaterialBlueColor,
      inactiveTrackColor: kMaterialBlueColor.withOpacity(0.5),
    ),
  );

  /// Dark Theme
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    accentColor: kMaterialRedColor,
    colorScheme: ColorScheme.dark().copyWith(
      secondary: kMaterialRedColor,
    ),
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
        color: kMaterialRedColor,
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
        color: kMaterialRedColor,
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
      elevation: 1,
    ),
    sliderTheme: SliderThemeData().copyWith(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      thumbColor: kMaterialRedColor,
      activeTrackColor: kMaterialRedColor,
      inactiveTrackColor: kMaterialRedColor.withOpacity(0.5),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kMaterialRedColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: kMaterialRedColor,
      unselectedItemColor: Colors.white.withOpacity(.8),
      selectedLabelStyle: TextStyle(
        color: kMaterialRedColor,
        fontFamily: 'SourceSansPro',
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.white.withOpacity(.7),
        fontFamily: 'SourceSansPro',
      ),
    ),
  );
}
