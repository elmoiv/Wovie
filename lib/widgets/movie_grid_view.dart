import 'package:flutter/material.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/widgets/movie_tile.dart';

Widget movieGridView(context, List<Movie> movieList,
    {int crossAxisCount = 3, bool reverse = false}) {
  return GridView.builder(
    reverse: reverse,
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: movieList.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1 / 1.887,
    ),
    itemBuilder: (context, index) {
      return MovieTile(
        movie: movieList[index],
      );
    },
  );
}
