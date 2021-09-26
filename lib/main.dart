import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wovie/screens/splash_screen.dart';
import 'controllers/sharedprefs_controller.dart';
import 'controllers/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Get instance one time only from shared prefs
  /// use it anywhere in the app
  SharedPreferences.getInstance().then((prefs) {
    SharedPrefs(staticPrefs: prefs);
    SharedPrefs().initSettings();
    runApp(Wovie());
  });
}

/// TODO: Find a way to show spinkit before youtube opens (Because youtube is loaded as invisible widgets)
///       and thus feels like user is waiting for nothing
/// TODO: [Optional] Add Guest login without api key with limited features
class Wovie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic _theme = SharedPrefs().getAppTheme();
    return GetMaterialApp(
      /// Use saved theme from shared prefs
      /// Default will be dark
      themeMode: _theme == 'light' ? ThemeMode.light : ThemeMode.dark,
      theme: Themes.light,
      darkTheme: Themes.dark,
      title: 'Wovie',
      home: SplashScreen(),
    );
  }
}
