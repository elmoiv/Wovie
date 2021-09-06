import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/model/movie.dart';
import 'package:wovie/widgets/movie_tile.dart';

Widget movieGridView(context, List<Movie> movieList, TMDB tmdb) {
  return GridView.builder(
    physics: ScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: movieList.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1 / 1.887,
    ),
    itemBuilder: (context, index) {
      return MovieTile(
        movie: movieList[index],
        tmdb: tmdb,
      );
    },
  );
}
