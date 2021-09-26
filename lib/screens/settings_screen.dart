import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/controllers/backup_restore_controller.dart';
import 'package:wovie/controllers/database_realtime_controller.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/login_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wovie/utils/cache_cleaner.dart';
import 'package:wovie/utils/request_read_write.dart';
import 'package:wovie/utils/toast.dart';
import '../controllers/sharedprefs_controller.dart';
import 'package:wovie/widgets/msg_box.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MovieListController movieListController =
      Get.put(MovieListController());
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
                    subtitle: 'Create a local backup of your saved movies',
                    leading: Icon(
                      Icons.save_alt,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) {},
                    onPressed: (context) async {
                      /// Request Write Access
                      await requestReadWrite();

                      /// Backup Data
                      BackupController _backup = BackupController.initBackup(
                        favMovies: await DbHelper().getAllMovies('fav'),
                        watMovies: await DbHelper().getAllMovies('wat'),
                      );
                      _backup.backupSettings().then((value) {
                        switch (value) {
                          case RETURN_CODE.SUCCESS:
                            return toast(
                                'Backup saved at: "/storage/emulated/0/Wovie"');
                          case RETURN_CODE.NO_ACCESS:
                            return toast('Can\'t get Write Access!');
                        }
                      });
                    },
                  ),
                  SettingsTile(
                    title: 'Restore',
                    titleTextStyle:
                        TextStyle(color: Theme.of(context).shadowColor),
                    subtitleTextStyle: TextStyle(
                        color: Theme.of(context).shadowColor.withOpacity(0.6)),
                    switchActiveColor: iconsColor,
                    subtitle: 'Restore a local backup',
                    leading: Icon(
                      Icons.restore,
                      color: iconsColor,
                    ),
                    onLongPressed: (context) {},
                    onPressed: (context) async {
                      /// Request Read Access
                      await requestReadWrite();

                      /// Restore Backup
                      BackupController _backup = BackupController.initRestore();
                      _backup.restoreSettings().then(
                        (value) async {
                          switch (value) {
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
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                titleTextStyle: TextStyle(color: Theme.of(context).accentColor),
                tiles: [
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
                    onLongPressed: (context) {
                      Clipboard.setData(
                        ClipboardData(text: TMDB().API_KEY),
                      );
                      toast('API Key has been copied');
                    },
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
                    onPressed: (_) {},
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
