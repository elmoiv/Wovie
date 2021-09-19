import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';

Widget genreTile(
  context,
  TMDB tmdb, {
  String? title,
  Color? color,
  Function? movieFunc,
  bool invertTitleColor = false,
}) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: screenWidth / 2.5,
      height: screenWidth / 2.5 * 0.4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kCircularBorderRadius + 10),
        boxShadow: [
          BoxShadow(
            color: color!.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5), // changes position of shadow
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kCircularBorderRadius + 10),
              ),
              onPressed: () {
                navPushTo(
                    context,
                    MoreMoviesScreen(
                      movieFunc: movieFunc,
                      title: title,
                    ));
              },
              child: Center(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: screenWidth / 20,
                    color: invertTitleColor ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Function getPopular = () => TMDB().getMoviesPopular();
Function getGenreAction = () => TMDB().getMoviesByGenre(genre: 'Action');
Function getGenreAdventure = () => TMDB().getMoviesByGenre(genre: 'Adventure');
Function getGenreAnimation = () => TMDB().getMoviesByGenre(genre: 'Animation');
Function getGenreComedy = () => TMDB().getMoviesByGenre(genre: 'Comedy');
Function getGenreCrime = () => TMDB().getMoviesByGenre(genre: 'Crime');
Function getGenreDocumentary =
    () => TMDB().getMoviesByGenre(genre: 'Documentary');
Function getGenreDrama = () => TMDB().getMoviesByGenre(genre: 'Drama');
Function getGenreFamily = () => TMDB().getMoviesByGenre(genre: 'Family');
Function getGenreFantasy = () => TMDB().getMoviesByGenre(genre: 'Fantasy');
Function getGenreHistory = () => TMDB().getMoviesByGenre(genre: 'History');
Function getGenreHorror = () => TMDB().getMoviesByGenre(genre: 'Horror');
Function getGenreMusic = () => TMDB().getMoviesByGenre(genre: 'Music');
Function getGenreMystery = () => TMDB().getMoviesByGenre(genre: 'Mystery');
Function getGenreRomance = () => TMDB().getMoviesByGenre(genre: 'Romance');
Function getGenreScienceFiction =
    () => TMDB().getMoviesByGenre(genre: 'Science Fiction');
Function getGenreTVMovie = () => TMDB().getMoviesByGenre(genre: 'TV Movie');
Function getGenreThriller = () => TMDB().getMoviesByGenre(genre: 'Thriller');
Function getGenreWar = () => TMDB().getMoviesByGenre(genre: 'War');
Function getGenreWestern = () => TMDB().getMoviesByGenre(genre: 'Western');
