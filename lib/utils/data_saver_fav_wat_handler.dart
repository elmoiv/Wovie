import 'package:wovie/api/tmdb_constants.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/models/movie.dart';

Movie handleImageUrl(Movie model) {
  String poster = imagePosterUrlHD;
  String bgd = imageBackgroundUrlHD;

  if (TMDB().dataSavingEnabled!) {
    poster = imagePosterUrlSD;
    bgd = imageBackgroundUrlSD;
  }

  if (model.moviePoster!.contains('.themoviedb.'))
    model.moviePoster = poster + '/' + model.moviePoster!.split('/').last;
  if (model.movieBackground!.contains('.tmdb.') ||
      model.movieBackground!.contains('.themoviedb.'))
    model.movieBackground = bgd + '/' + model.movieBackground!.split('/').last;

  return model;
}
