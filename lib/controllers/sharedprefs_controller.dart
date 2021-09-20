import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  /// Static API_KEY
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
}
