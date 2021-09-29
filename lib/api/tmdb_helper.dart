import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wovie/api/tmdb_constants.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/models/actor.dart';

class TMDB {
  int pageNumber = 1;
  String searchQuery = '';

  /// Static API_KEY
  String? API_KEY;
  bool? dataSavingEnabled;

  /// Single Tone Design Pattern
  static TMDB? _helper;
  TMDB._getInstance({this.API_KEY, this.dataSavingEnabled});

  factory TMDB({String? apiKey, bool? savingEnabled = false}) {
    if (_helper == null) {
      _helper =
          TMDB._getInstance(API_KEY: apiKey, dataSavingEnabled: savingEnabled);
    }
    return _helper!;
  }

  static Future<dynamic> _getJson(String url) async {
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    return jsonDecode(response.body);
  }

  static String toGoodTime(int time) {
    int hours = time ~/ 60;
    int minutes = time - hours * 60;
    return '${hours}h ${minutes}m';
  }

  static Future<bool> isNotValidApiKey({String? apiKey}) async {
    dynamic json = await _getJson('${movieUrl}10000?api_key=$apiKey');
    return json.containsKey('success');
  }

  String? _toGenre(dynamic genreList) {
    dynamic genre = genreList.length != 0 ? genreList[0] : -1;
    return genreIntStr.containsKey(genre) ? genreIntStr[genre] : 'None';
  }

  void resetPages() {
    this.pageNumber = 1;
  }

  dynamic _checkJsonKey(json, key, errorReturn) {
    return json.containsKey(key) ? json[key] : errorReturn;
  }

  Movie _toMovie(dynamic json) {
    dynamic runtime = _checkJsonKey(json, 'runtime', 0);
    dynamic genreList = json.containsKey('genre_ids')
        ? json['genre_ids']
        : [json['genres'][0]['id']];
    dynamic backgroundImg = json['backdrop_path'] != null
        ? (this.dataSavingEnabled!
                ? imageBackgroundUrlSD
                : imageBackgroundUrlHD) +
            json['backdrop_path']
        : 'https://i.stack.imgur.com/y9DpT.jpg';
    dynamic posterImg = json['poster_path'] != null
        ? (this.dataSavingEnabled! ? imagePosterUrlSD : imagePosterUrlHD) +
            json['poster_path']
        : 'https://critics.io/img/movies/poster-placeholder.png';
    dynamic releaseDate =
        _checkJsonKey(json, 'release_date', 'Coming Soon') ?? 'Coming Soon';
    dynamic isAdult = _checkJsonKey(json, 'adult', false);

    return Movie(
      movieId: json['id'],
      movieTitle: json['title'],
      movieDescription: json['overview'],
      movieRelease: releaseDate == "" ? 'Coming Soon' : releaseDate,
      movieRate: double.parse(json['vote_average'].toString()),
      movieCategory: this._toGenre(genreList),
      moviePoster: posterImg,
      movieBackground: backgroundImg,
      movieDuration: runtime,
      movieIsAdult: isAdult ? 1 : 0,
    );
  }

  Actor _toActor(dynamic json) {
    dynamic profilePic = json['profile_path'].runtimeType != Null
        ? (this.dataSavingEnabled! ? imageActorUrlSD : imageActorUrlHD) +
            json['profile_path']
        : 'https://hearhearforbhutan.org/wp-content/uploads/2019/09/avtar.png';
    dynamic bio = _checkJsonKey(json, 'biography', '-');
    dynamic birthday = _checkJsonKey(json, 'birthday', '-');
    dynamic birthplace = _checkJsonKey(json, 'place_of_birth', '-');
    dynamic character = _checkJsonKey(json, 'character', '-');
    dynamic gender = [1, 2].contains(_checkJsonKey(json, 'gender', 0))
        ? ['Female', 'Male'][json['gender'] - 1]
        : 'Unknown';
    dynamic isAdult = _checkJsonKey(json, 'adult', false);

    return Actor(
      actorId: json['id'],
      actorName: json['name'],
      actorBiography: bio == '' ? 'No Biography found.' : bio,
      actorBirthday: birthday ?? 'Unknown',
      actorBirthplace: birthplace ?? 'Unknown',
      actorRate: double.parse(json['popularity'].toString()),
      actorPhoto: profilePic,
      actorGender: gender,
      actorCharacter: character,
      actorIsAdult: isAdult ? 1 : 0,
    );
  }

  Future<Movie> getMovie(int id) async {
    dynamic json = await _getJson('$movieUrl$id?api_key=$API_KEY');
    return this._toMovie(json);
  }

  Future<List<Movie>> getMoviesSearch() async {
    dynamic json = await _getJson(
        '$searchUrl?api_key=$API_KEY&query=${this.searchQuery}&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<String> getMovieVideoKey(int id) async {
    dynamic json = await _getJson('$movieUrl$id/videos?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return '';
    }

    try {
      List<dynamic> youtubeTrailers = json['results']
          .where((e) => e['type'] == 'Trailer' && e['site'] == 'YouTube')
          .toList();
      print(youtubeTrailers);
      return youtubeTrailers[0]['key'];
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<List<Movie>> getMoviesByGenre({String? genre}) async {
    int? genreId = genreStrInt[genre];
    dynamic json = await _getJson(
        '$genreUrl?api_key=$API_KEY&with_genres=$genreId&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getMoviesPopular() async {
    dynamic json =
        await _getJson('$popularUrl?api_key=$API_KEY&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getMoviesUpcoming() async {
    dynamic json =
        await _getJson('$upcomingUrl?api_key=$API_KEY&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getMoviesSimilar(int id) async {
    dynamic json = await _getJson('$movieUrl$id/similar?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return [];
    }

    List<Movie> result =
        json['results'].map<Movie>((e) => this._toMovie(e)).toList();

    // Remove same movie from similarities
    return result.where((e) => e.movieId != id).toList();
  }

  Future<Actor> getActor(int id) async {
    dynamic json = await _getJson('$actorUrl$id?api_key=$API_KEY');
    return this._toActor(json);
  }

  Future<List<Actor>> getActorsCast(int id) async {
    dynamic json = await _getJson('$movieUrl$id/credits?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return [];
    }

    if (!json.containsKey('cast')) {
      return [];
    }

    // Filter Actors only
    List result = json['cast']
        .where((e) => e['known_for_department'] == 'Acting')
        .toList();

    return result.map((e) => this._toActor(e)).toList();
  }

  Future<List<Actor>> getActorsPopular() async {
    dynamic json = await _getJson('${actorUrl}popular?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return [];
    }

    return List<Actor>.from(
        json['results'].map((e) => this._toActor(e)).toList());
  }

  Future<List<Movie>> getActorMovies(int id) async {
    dynamic json =
        await _getJson('$actorUrl$id/movie_credits?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return [];
    }

    if (!json.containsKey('cast')) {
      return [];
    }

    List jsonSorted = json['cast'];
    try {
      jsonSorted.sort((a, b) {
        return int.parse(b['vote_count'].toString())
            .toInt()
            .compareTo(int.parse(a['vote_count'].toString()).toInt());
      });
    } catch (e) {
      jsonSorted = json['cast'];
    }

    int takenItemCount = jsonSorted.length < 20 ? jsonSorted.length : 20;
    return jsonSorted
        .take(takenItemCount)
        .map<Movie>((e) => this._toMovie(e))
        .toList();
  }
}
