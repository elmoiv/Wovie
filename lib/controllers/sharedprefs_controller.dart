import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  /// Static prefs via different instances
  SharedPreferences? prefs;

  /// Single Tone Design Pattern
  static SharedPrefs? _helper;
  SharedPrefs._getInstance({this.prefs});

  factory SharedPrefs({SharedPreferences? staticPrefs}) {
    if (_helper == null) {
      _helper = SharedPrefs._getInstance(prefs: staticPrefs);
    }
    return _helper!;
  }

  void setApiKey(String val) {
    this.prefs!.setString('API_KEY', val);
  }

  dynamic getApiKey() {
    return this.prefs!.getString('API_KEY');
  }

  void setAppTheme(String val) {
    this.prefs!.setString('APP_THEME', val);
  }

  dynamic getAppTheme() {
    return this.prefs!.getString('APP_THEME');
  }
}
