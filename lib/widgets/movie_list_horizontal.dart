import 'package:flutter/material.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/widgets/movie_tile.dart';

Widget movieHorizontalListView(context, List<Movie> movieList,
    {double? height}) {
  height = height ?? MediaQuery.of(context).size.height * .3;
  double width = height * .5;
  return Container(
    height: height,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movieList.length,
      itemBuilder: (context, index) {
        return Container(
          width: width,
          child: MovieTile(
            movie: movieList[index],
          ),
        );
      },
    ),
  );
}
