import 'package:wovie/models/movie.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

enum RETURN_CODE {
  SUCCESS,
  EXIT,
  NO_ACCESS,
  DAMAGED,
  NOT_FOUND,
}

class BackupController {
  List<Movie>? favMovies;
  List<Movie>? watMovies;
  dynamic json;

  BackupController.initBackup(
      {required this.favMovies, required this.watMovies});
  BackupController.initRestore();

  void convertToJson() => this.json = {
        'fav': this.favMovies!.map((e) => e.toMap()).toList(),
        'wat': this.watMovies!.map((e) => e.toMap()).toList(),
      };

  void convertToMovies() => this.json = {
        'fav': List<Movie>.from(
            this.json['fav'].map((e) => Movie.fromMap(e)).toList()),
        'wat': List<Movie>.from(
            this.json['wat'].map((e) => Movie.fromMap(e)).toList()),
      };

  Future<dynamic> backupSettings([bool useFilePicker = false]) async {
    this.convertToJson();
    // /// Pick Directory
    // String? woviePath = await FilePicker.platform.getDirectoryPath();
    // if (woviePath == null) {
    //   Fluttertoast.showToast(msg: 'Backup has been cancelled!');
    // }

    String woviePath = '/storage/emulated/0/Wovie';
    Directory d = Directory(woviePath);

    if (!d.existsSync()) {
      d.createSync();
    }

    /// Convert json to text and save it to selected directory
    try {
      await File('$woviePath/wovie_settings.json')
          .writeAsString(jsonEncode(this.json));
      return RETURN_CODE.SUCCESS;
    } catch (e) {
      print(e.toString());
      return RETURN_CODE.NO_ACCESS;
    }
  }

  Future<dynamic> restoreSettings([bool useFilePicker = false]) async {
    FilePickerResult? result;

    /// Pick settings json file
    try {
      await FilePicker.platform.clearTemporaryFiles();
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null) {
        return RETURN_CODE.EXIT;
      }
    } catch (e) {
      /// Can't get access rights
      print(e.toString());
      return RETURN_CODE.NO_ACCESS;
    }

    /// Read text and convert to json
    try {
      File file = File(result.files.single.path!);
      String settingsRaw = await file.readAsString();
      this.json = jsonDecode(settingsRaw);
      this.convertToMovies();
      return RETURN_CODE.SUCCESS;
    } catch (e) {
      /// Damaged file
      print(e.toString());
      return RETURN_CODE.DAMAGED;
    }
  }
}
