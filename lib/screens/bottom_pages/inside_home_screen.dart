import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/genres_screen.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/actors_list_horizontal.dart';
import 'package:wovie/widgets/details_section.dart';
import 'package:wovie/widgets/genre_tile.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';
import 'package:wovie/widgets/upcoming_movie_tile.dart';

class InsideHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TMDB tmdb = TMDB();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailsSection(
            title: 'Upcoming',
            titleSize: screenWidth / 15,
            verticalPadding: screenWidth / 17,
            viewMoreOnPressed: () => navPushTo(
                context,
                MoreMoviesScreen(
                  title: 'Upcoming',
                  movieFunc: getUpcoming,
                )),
            child: FutureBuilder<List<Movie>>(
              future: tmdb.getMoviesUpcoming(),
              builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return upcomingMoviesSlider(context, snapshot.data!);
                } else {
                  if (snapshot.hasError) {
                    return ErrorWidget(context);
                  } else {
                    return SpinKitThreeBounce(
                        color: Theme.of(context).accentColor,
                        size: screenWidth / 10);
                  }
                }
              },
            ),
          ),
          DetailsSection(
            title: 'Popular',
            titleSize: screenWidth / 15,
            verticalPadding: screenWidth / 17,
            viewMoreOnPressed: () => navPushTo(
                context,
                MoreMoviesScreen(
                  title: 'Popular',
                  movieFunc: getPopular,
                )),
            child: FutureBuilder<List<Movie>>(
              future: tmdb.getMoviesPopular(),
              builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return movieHorizontalListView(
                    context,
                    snapshot.data!.take(10).toList(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return ErrorWidget(context);
                  } else {
                    return SpinKitThreeBounce(
                        color: Theme.of(context).accentColor,
                        size: screenWidth / 10);
                  }
                }
              },
            ),
          ),
          DetailsSection(
            title: 'Genres',
            titleSize: screenWidth / 15,
            verticalPadding: screenWidth / 17,
            viewMoreOnPressed: () => navPushTo(context, GenresScreen()),
            child: Container(
              height: screenWidth * 0.16 * 2 + 8 * 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genreTile(context, tmdb,
                          title: 'Fantasy',
                          color: Color(0xffff8671),
                          movieFunc: getGenreFantasy),
                      SizedBox(
                        width: screenWidth / 36,
                      ),
                      genreTile(context, tmdb,
                          title: 'Action',
                          color: Colors.blueAccent,
                          movieFunc: getGenreAction),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genreTile(context, tmdb,
                          title: 'Romance',
                          color: Colors.pinkAccent,
                          movieFunc: getGenreRomance),
                      SizedBox(
                        width: screenWidth / 36,
                      ),
                      genreTile(context, tmdb,
                          title: 'Drama',
                          color: Colors.red,
                          movieFunc: getGenreDrama),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DetailsSection(
            title: 'Top Actors',
            titleSize: screenWidth / 15,
            verticalPadding: screenWidth / 17,
            child: FutureBuilder<List<Actor>>(
              future: tmdb.getActorsPopular(),
              builder: (context, AsyncSnapshot<List<Actor>> snapshot) {
                if (snapshot.hasData) {
                  return castMovieListView(context, snapshot.data!);
                } else {
                  if (snapshot.hasError) {
                    return ErrorWidget(context);
                  } else {
                    return SpinKitThreeBounce(
                        color: Theme.of(context).accentColor,
                        size: screenWidth / 10);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget ErrorWidget(context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Center(
      child: Text(
        'Connection Error',
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 20,
            color: kMaterialRedColor),
      ),
    ),
  );
}

Widget upcomingMoviesSlider(context, List<Movie> movieList) {
  double height = MediaQuery.of(context).size.height / 4;
  return Container(
    height: height,
    child: CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 500 / 281,
        viewportFraction: 0.9,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
      ),
      items: movieList
          .take(10)
          .map(
            (e) => UpcomingMovieTile(
              movie: e,
            ),
          )
          .toList(),
    ),
  );
}
