import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/controllers/backup_restore_controller.dart';
import 'package:wovie/controllers/database_realtime_controller.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/about_screen.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:wovie/custom_dart_packages/settings_ui/settings_ui.dart';
import 'package:wovie/utils/cache_cleaner.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/utils/request_read_write.dart';
import 'package:wovie/utils/toast.dart';
import '../controllers/sharedprefs_controller.dart';
import 'package:wovie/widgets/msg_box.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MovieListController movieListController =
      Get.put(MovieListController());
  bool themeValue = Get.isDarkMode;
  bool dataSavingValue = SharedPrefs().getDataSaving();
  bool netOnStartUpValue = SharedPrefs().getCheckNetOnStartUp();

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
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: SettingsList(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            sections: [
              SettingsSection(
                title: 'Theme',
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
                        SharedPrefs().setAppTheme('light');
                      } else {
                        Get.changeThemeMode(ThemeMode.dark);
                        SharedPrefs().setAppTheme('dark');
                      }
                      setState(() {
                        themeValue = newValue;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Backups',
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
                  SettingsTile(
                    title: 'Backup',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: 'Long Press for a quick backup',
                    leading: Icon(
                      Icons.save_alt,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) async {
                      /// Handle overwriting existing backup
                      bool yesPressed = false;
                      if (File('/storage/emulated/0/Wovie/wovie_settings.json')
                          .existsSync()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => MsgBox(
                            title: 'Old Backup Found!',
                            content:
                                'Do you want to overwrite the existing backup?',
                            successText: 'YES',
                            failureText: 'NO',
                            onPressedSuccess: () async {
                              yesPressed = true;
                              await backupFunction(usePicker: false);
                              Navigator.pop(context);
                            },
                          ),
                        ).then((value) {
                          if (!yesPressed) {
                            toast('Backup has been cancelled!');
                          }
                        });
                      } else {
                        await backupFunction(usePicker: false);
                      }
                    },
                    onPressed: (context) async {
                      await backupFunction(usePicker: true);
                    },
                  ),
                  SettingsTile(
                    title: 'Restore',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: 'Long Press for a quick restore',
                    leading: Icon(
                      Icons.restore,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) async {
                      await restoreFunction(usePicker: false);
                    },
                    onPressed: (context) async {
                      await restoreFunction(usePicker: true);
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Connection',
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
                  SettingsTile.switchTile(
                    title: 'Data Saving Mode',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: dataSavingValue ? 'Enabled' : 'Disabled',
                    switchValue: dataSavingValue,
                    leading: Icon(
                      dataSavingValue
                          ? Icons.data_saver_on
                          : Icons.data_saver_off,
                      color: iconsColor,
                    ),
                    onToggle: (newValue) {
                      SharedPrefs().setDataSaving(newValue);
                      TMDB().dataSavingEnabled = newValue;
                      setState(() {
                        dataSavingValue = newValue;
                      });
                      toast('Refresh Home screen to apply new changes');
                    },
                  ),
                  SettingsTile.switchTile(
                    title: 'Network Check on Startup',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: netOnStartUpValue ? 'Enabled' : 'Disabled',
                    switchValue: netOnStartUpValue,
                    leading: Icon(
                      netOnStartUpValue ? Icons.wifi : Icons.wifi_off,
                      color: iconsColor,
                    ),
                    onToggle: (newValue) {
                      SharedPrefs().setCheckNetOnStartUp(newValue);
                      setState(() {
                        netOnStartUpValue = newValue;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
                  SettingsTile(
                    title: 'Access Token Auth',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6),
                        overflow: TextOverflow.fade),
                    switchActiveColor: iconsColor,
                    subtitle: TMDB().API_KEY,
                    leading: Icon(
                      Icons.vpn_key_outlined,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) {
                      Clipboard.setData(
                        ClipboardData(text: TMDB().API_KEY),
                      );
                      toast('Access Token Auth has been copied');
                    },
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => MsgBox(
                          title: 'Change Access Token Auth',
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
                  SettingsTile(
                    title: 'Clean Cache',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: 'Long Press to clean app cache',
                    leading: Icon(
                      Icons.cleaning_services,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) {
                      cleanAppCache();
                    },
                    onPressed: (_) {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'Credits',
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
                  SettingsTile(
                    title: 'About Wovie',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    leading: Icon(
                      Icons.info_outline,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) {},
                    onPressed: (_) {
                      navPushTo(context, AboutScreen());
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

  Future<bool> fetchSqlMovies(String type) async {
    movieListController.updateMovieList([], type);
    List<Movie> sqlMovies = await DbHelper().getAllMovies(type);
    movieListController.updateMovieList(sqlMovies, type);
    return true;
  }

  Future<bool> addAllSqlMovies(List<Movie> movies, String type) async {
    await DbHelper().addAllMovies(movies, type);
    await fetchSqlMovies(type);
    return true;
  }

  Future<void> backupFunction({bool usePicker = false}) async {
    /// Request Write Access
    if (!await requestReadWrite()) {
      return toast('Can\'t get Write Access!');
    }

    /// Backup Data
    BackupController _backup = BackupController.initBackup(
      favMovies: await DbHelper().getAllMovies('fav'),
      watMovies: await DbHelper().getAllMovies('wat'),
    );
    _backup.backupSettings(usePicker).then((values) {
      switch (values[0]) {
        case RETURN_CODE.EXIT:
          return toast('Backup has been cancelled!');
        case RETURN_CODE.SUCCESS:
          return toast('Backup saved at: "${values[1]}"');
        case RETURN_CODE.NO_ACCESS:
          return toast('Can\'t get Write Access!');
      }
    });
  }

  Future<void> restoreFunction({bool usePicker = false}) async {
    /// Request Read Access
    if (!await requestReadWrite()) {
      return toast('Can\'t get Read Access!');
    }

    /// Restore Backup
    BackupController _backup = BackupController.initRestore();
    _backup.restoreSettings(usePicker).then(
      (value) async {
        switch (value) {
          case RETURN_CODE.NOT_FOUND:
            return showDialog(
              context: context,
              builder: (BuildContext context) => MsgBox(
                title: 'Restore Failed!',
                content: 'Wovie did not find any backups',
              ),
            );
          case RETURN_CODE.EXIT:
            return toast('Restore has been cancelled!');
          case RETURN_CODE.NO_ACCESS:
            return toast('Can\'t get Read Access!');
          case RETURN_CODE.DAMAGED:
            return toast('Damaged Backup File!');
          default:
            restoreInBackground(_backup.json);
        }
      },
    );
  }

  /// Restore backups in background (When not using await with main func)
  Future<void> restoreInBackground(dynamic json) async {
    // // Testing only
    // await Future.delayed(Duration(seconds: 5));
    toast('Restoring...');
    await DbHelper().remAllMovies('fav');
    await DbHelper().remAllMovies('wat');
    await addAllSqlMovies(json['fav']!, 'fav');
    await addAllSqlMovies(json['wat']!, 'wat');
    toast('Backup has been Restored!');
  }
}
