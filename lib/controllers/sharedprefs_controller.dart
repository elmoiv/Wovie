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

  void initSettings() {
    if (getDataSaving() == null) {
      setDataSaving(false);
    }
    if (getCheckNetOnStartUp() == null) {
      setCheckNetOnStartUp(true);
    }
    if (getAppTheme() == null) {
      setAppTheme('dark');
    }
  }

  void setCheckNetOnStartUp(bool val) {
    this.prefs!.setBool('CHECK_NET_STARTUP', val);
  }

  dynamic getCheckNetOnStartUp() {
    return this.prefs!.getBool('CHECK_NET_STARTUP');
  }

  void setDataSaving(bool val) {
    this.prefs!.setBool('DATA_SAVING', val);
  }

  dynamic getDataSaving() {
    return this.prefs!.getBool('DATA_SAVING');
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
