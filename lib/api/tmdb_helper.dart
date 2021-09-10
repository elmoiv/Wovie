import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wovie/api/tmdb_constants.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/models/actor.dart';

class TMDB {
  int pageNumber = 1;
  String API_KEY = '';

  // Single Tone Design Pattern
  static TMDB? _helper;
  TMDB._getInstance();
  factory TMDB() {
    if (_helper == null) {
      _helper = TMDB._getInstance();
    }
    return _helper!;
  }

  void resetPages() => this.pageNumber = 1;

  dynamic _checkJsonKey(json, key, errorReturn) {
    return json.containsKey(key) ? json[key] : errorReturn;
  }

  String? _toGenre(dynamic genreList) {
    dynamic genre = genreList.length != 0 ? genreList[0] : -1;
    return genreIntStr.containsKey(genre) ? genreIntStr[genre] : 'None';
  }

  Future<dynamic> _getJson(String url) async {
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    return jsonDecode(response.body);
  }

  Movie _toMovie(dynamic json) {
    // Handle runtime for any api request
    dynamic runtime = _checkJsonKey(json, 'runtime', 0);
    // Handle genres in movie api and popular api
    dynamic genreList = json.containsKey('genre_ids')
        ? json['genre_ids']
        : [json['genres'][0]['id']];

    dynamic backgroundImg = json['backdrop_path'] != null
        ? imageUrl + json['backdrop_path']
        : 'https://i.stack.imgur.com/y9DpT.jpg';

    dynamic posterImg = json['poster_path'] != null
        ? imageUrl + json['poster_path']
        : 'https://critics.io/img/movies/poster-placeholder.png';

    // Some release dates does not exist
    dynamic release = _checkJsonKey(json, 'release_date', 'Coming Soon');
    dynamic releaseDate = release ?? 'Coming Soon';

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
    );
  }

  Actor _toActor(dynamic json) {
    dynamic profilePic = json['profile_path'].runtimeType != Null
        ? imageUrl + json['profile_path']
        : 'https://hearhearforbhutan.org/wp-content/uploads/2019/09/avtar.png';
    dynamic bio = json['biography'];
    dynamic birthday = json['birthday'];
    dynamic birthplace = json['place_of_birth'];
    dynamic character = _checkJsonKey(json, 'character', '-');
    dynamic gender = [1, 2].contains(json['gender'])
        ? ['Female', 'Male'][json['gender'] - 1]
        : 'Unknown';

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
    );
  }

  String toGoodTime(int time) {
    int hours = time ~/ 60;
    int minutes = time - hours * 60;
    return '${hours}h ${minutes}m';
  }

  Future<bool> isNotValidApiKey() async {
    dynamic json = await this._getJson('${movieUrl}10000?api_key=$API_KEY');
    return json.containsKey('success');
  }

  Future<Movie> getMovie(int id) async {
    dynamic json = await this._getJson('$movieUrl$id?api_key=$API_KEY');
    return this._toMovie(json);
  }

  Future<List<Movie>> searchMovie(String query) async {
    String queryEncoded = Uri.encodeComponent(query);
    print(queryEncoded);
    dynamic json =
        await this._getJson('$searchUrl?api_key=$API_KEY&query=$queryEncoded');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<String> getMovieVideoKey(int id) async {
    dynamic json = await this._getJson('$movieUrl$id/videos?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return '';
    }

    return json['results'][0]['key'];
  }

  Future<List<Movie>> getByGenre({String? genre}) async {
    int? genreId = genreStrInt[genre];
    dynamic json =
        await this._getJson('$genreUrl?api_key=$API_KEY&with_genres=$genreId');

    if (json.containsKey('errors')) {
      return [];
    }

    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getPopular() async {
    dynamic json =
        await this._getJson('$popularUrl?api_key=$API_KEY&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    this.pageNumber++;
    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getUpcoming() async {
    dynamic json =
        await this._getJson('$upcomingUrl?api_key=$API_KEY&page=$pageNumber');

    if (json.containsKey('errors')) {
      return [];
    }

    return json['results'].map<Movie>((e) => this._toMovie(e)).toList();
  }

  Future<List<Movie>> getSimilar(int id) async {
    dynamic json = await this._getJson('$movieUrl$id/similar?api_key=$API_KEY');

    if (json.containsKey('errors')) {
      return [];
    }

    List<Movie> result =
        json['results'].map<Movie>((e) => this._toMovie(e)).toList();

    // Remove same movie from similarities
    return result.where((e) => e.movieId != id).toList();
  }

  Future<List<Actor>> getCast(int id) async {
    dynamic json = await this._getJson('$movieUrl$id/credits?api_key=$API_KEY');

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

  Future<Actor> getActor(int id) async {
    dynamic json = await this._getJson('$actorUrl$id?api_key=$API_KEY');
    return this._toActor(json);
  }

  Future<List<Movie>> getActorMovies(int id) async {
    dynamic json =
        await this._getJson('$actorUrl$id/movie_credits?api_key=$API_KEY');

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

// void main() async {
//   TMDB tmdb = TMDB();
//   tmdb.API_KEY = '85a2339b494ed248f326dd9bf8502026';
//   print('Checking API Key...');
//   if (await tmdb.isNotValidApiKey()) {
//     print('Incorrect API KEY');
//     return;
//   }
//   print('Connecting...');
//   var x = await tmdb.searchMovie('Spider man 2');
//   print(x[0].toMap());
// }
