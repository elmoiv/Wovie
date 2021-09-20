import 'package:get/get.dart';

class MovieListController extends GetxController {
  RxList favMoviesList = [].obs;
  RxList watMoviesList = [].obs;

  void updateMovieList(List<dynamic> _newMovies, String type) {
    if (type == 'fav') {
      favMoviesList.value = _newMovies;
    } else {
      watMoviesList.value = _newMovies;
    }
  }

  RxList getMovieList(String type) {
    if (type == 'fav') {
      return favMoviesList;
    } else {
      return watMoviesList;
    }
  }
}
