import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wovie/models/movie.dart';
import 'db_constants.dart';

class DbHelper {
  static DbHelper? _helper;
  DbHelper._getInstance();
  factory DbHelper() {
    if (_helper == null) {
      _helper = DbHelper._getInstance();
    }
    return _helper!;
  }

  Future<String> _getDbPath() async {
    String path = await getDatabasesPath();
    String noteDbPath = path + '/' + Constants.DB_NAME;
    return noteDbPath;
  }

  Future<Database> getDbInstance() async {
    String dbPath = await _getDbPath();
    return openDatabase(
      dbPath,
      version: Constants.DB_VERSION,
      onCreate: (db, version) => _createTables(db),
      onUpgrade: (db, version, sub) => _upgradeTables(db),
    );
  }

  void _createTable(Database db, String tableName) {
    String query =
        'create table $tableName (${Constants.COL_UNIQUE_ID} integer primary key ' +
            'autoincrement, ${Constants.COL_ID} integer,' +
            ' ${Constants.COL_TITLE} text, ${Constants.COL_DESCRIPTION} text,' +
            ' ${Constants.COL_RELEASE} text, ${Constants.COL_RATE} float,' +
            ' ${Constants.COL_CATEGORY} text, ${Constants.COL_DURATION} integer,' +
            ' ${Constants.COL_POSTER} text, ${Constants.COL_BACKGROUND} text,' +
            ' ${Constants.COL_ISADULT} integer)';
    db.execute(query);
  }

  void _createTables(Database db) {
    this._createTable(db, Constants.TABLE_WATCH);
    this._createTable(db, Constants.TABLE_FAVOURITE);
  }

  void _upgradeTables(Database db) {
    _createTables(db);
  }

  String _decideTableName(String type) {
    return type == 'fav' ? Constants.TABLE_FAVOURITE : Constants.TABLE_WATCH;
  }

  Future<int> addMovie(Movie movie, String type) async {
    print('Added: ${movie.movieTitle}');
    String tableName = this._decideTableName(type);
    Database db = await getDbInstance();
    try {
      db.insert(tableName, movie.toMap());
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<int> addAllMovies(List<Movie> movies, String type) async {
    print('Added All: $type');
    Database db = await this.getDbInstance();
    try {
      String tableName = this._decideTableName(type);
      db.transaction((txn) async {
        Batch batch = txn.batch();
        for (Movie movie in movies) {
          batch.insert(tableName, movie.toMap());
        }
        batch.commit();
      });
      return 0;
    } catch (e) {
      print(e);
      return 1;
    }
  }

  Future<int> remMovie(Movie movie, String type) async {
    print('Removed: ${movie.movieTitle}');
    String tableName = this._decideTableName(type);
    Database db = await getDbInstance();
    try {
      db.delete(tableName, where: '${Constants.COL_ID}=${movie.movieId}');
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<int> remAllMovies(String type) async {
    print('Removed all: $type');
    String tableName = this._decideTableName(type);
    Database db = await getDbInstance();
    try {
      db.delete(tableName);
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<Movie> getMovie(int movieId, String type) async {
    String tableName = this._decideTableName(type);
    Database db = await getDbInstance();
    List<Map<String, dynamic>> query = await db.query(tableName,
        where: "${Constants.COL_ID} LIKE '$movieId%'");
    if (query.length == 0) {
      return Movie();
    }
    return query.map((e) => Movie.fromMap(e)).toList().first;
  }

  Future<List<Movie>> getAllMovies(String type) async {
    String tableName = this._decideTableName(type);
    Database db = await getDbInstance();
    List<Map<String, dynamic>> query = await db.query(tableName);
    return query.map((e) => Movie.fromMap(e)).toList();
  }
}
