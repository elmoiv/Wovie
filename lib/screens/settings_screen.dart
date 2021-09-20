import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import '../controllers/sharedprefs_controller.dart';
import 'package:wovie/widgets/msg_box.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool themeValue = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    Color iconsColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SettingsList(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            sections: [
              SettingsSection(
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
                  SettingsTile.switchTile(
                    title: 'Theme Mode',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: themeValue ? 'Dark' : 'Light',
                    switchValue: themeValue,
                    leading: Icon(
                      Icons.color_lens_outlined,
                      color: iconsColor,
                    ),
                    onToggle: (bool newValue) {
                      if (Get.isDarkMode) {
                        Get.changeThemeMode(ThemeMode.light);
                        SharedPrefs().prefs!.setString('APP_THEME', 'light');
                      } else {
                        Get.changeThemeMode(ThemeMode.dark);
                        SharedPrefs().prefs!.setString('APP_THEME', 'dark');
                      }
                      setState(() {
                        themeValue = newValue;
                      });
                    },
                  ),
                  SettingsTile(
                    title: 'API Key',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: TMDB().API_KEY,
                    leading: Icon(
                      Icons.vpn_key_outlined,
                      color: iconsColor,
                    ),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => MsgBox(
                          title: 'Change API Key',
                          content: 'Are you sure?',
                          successText: 'Yes',
                          failureText: 'No',
                          onPressedSuccess: () {
                            Get.offAll(
                              () => LoginScreen(
                                customApiKey: TMDB().API_KEY,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
