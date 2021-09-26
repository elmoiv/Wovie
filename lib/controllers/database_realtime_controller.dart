import 'package:get/get.dart';

class MovieListController extends GetxController {
  RxList favMoviesList = [].obs;
  RxList watMoviesList = [].obs;
  RxList watListUnique = [].obs;
  RxList favListUnique = [].obs;

  void updateMovieList(List<dynamic> _newMovies, String type) {
    if (type == 'fav') {
      favListUnique.value +=
          updateCounters(_newMovies, favMoviesList, favListUnique);
      favMoviesList.value = _newMovies;
      favListUnique.value =
          newUniqueBeforeOpeningBadges(favListUnique, favMoviesList);
    } else {
      watListUnique.value +=
          updateCounters(_newMovies, watMoviesList, watListUnique);
      watMoviesList.value = _newMovies;
      watListUnique.value =
          newUniqueBeforeOpeningBadges(watListUnique, watMoviesList);
    }
  }

  RxList getMovieList(String type) =>
      type == 'fav' ? favMoviesList : watMoviesList;

  /// [COMES_BEFORE_UPDATING_MAIN_LISTS]
  /// This will update counter lists with new added movies
  /// in order to show them in badges
  List updateCounters(List _newMovies, List currentMovieList, List uniqueList) {
    List diff = _newMovies
        .where((movie) => !currentMovieList
            .map((e) => e.movieId)
            .toList()
            .contains(movie.movieId))
        .toList();
    List uniqueDiff = diff
        .where((movie) =>
            !uniqueList.map((e) => e.movieId).toList().contains(movie.movieId))
        .toList();
    return uniqueDiff;
  }

  /// [COMES_AFTER_UPDATING_MAIN_LISTS]
  /// This will handle this case:
  /// User added something to favourites then removed it before opening
  /// Favourites screen
  /// Here we will also decrease the badge counter
  List newUniqueBeforeOpeningBadges(List unique, List current) {
    return unique
        .where((movie) =>
            current.map((e) => e.movieId).toList().contains(movie.movieId))
        .toList();
  }

  void clearCounter(String type) =>
      type == 'fav' ? favListUnique.value = [] : watListUnique.value = [];
}
