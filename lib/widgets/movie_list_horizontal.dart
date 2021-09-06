import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/model/movie.dart';
import 'package:wovie/widgets/movie_tile.dart';

Widget movieHorizontalListView(context, List<Movie> movieList, TMDB tmdb) {
  return Container(
    height: MediaQuery.of(context).size.height * .3,
    child: ListView.builder(
      physics: ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: movieList.length,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.height * .3 * .5,
          child: MovieTile(
            movie: movieList[index],
            tmdb: tmdb,
          ),
        );
      },
    ),
  );
}
