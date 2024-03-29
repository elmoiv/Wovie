import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/controllers/database_realtime_controller.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/screens/youtube_screen.dart';
import 'package:wovie/utils/transparent_page_route.dart';
import 'package:wovie/widgets/details_section.dart';
import 'package:wovie/widgets/stack_icon_button.dart';
import 'package:wovie/widgets/actors_list_horizontal.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';

class MovieScreen extends StatefulWidget {
  final Movie? movie;
  final String? heroKey;
  MovieScreen({this.movie, this.heroKey});

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final MovieListController movieListController =
      Get.put(MovieListController());

  IconData favIcon = Icons.favorite_border;
  IconData watchIcon = Icons.bookmark_border;

  bool favIcoState = false;
  bool watIcoState = false;
  DbHelper _dbHelper = DbHelper();

  void checkFavAndWatch() async {
    /// Check if exist in SQL DB
    Movie movieFav = await _dbHelper.getMovie(widget.movie!.movieId!, 'fav');
    Movie movieWat = await _dbHelper.getMovie(widget.movie!.movieId!, 'watch');

    /// Change state of fav and watch icons upon existence in DB
    setState(() {
      favIcoState = movieFav.movieId != null;
      watIcoState = movieWat.movieId != null;
      favIcon = favIcoState ? Icons.favorite : Icons.favorite_border;
      watchIcon = watIcoState ? Icons.bookmark : Icons.bookmark_border;
    });
  }

  Future<bool> fetchSqlMovies(String type) async {
    List<Movie> sqlMovies = await DbHelper().getAllMovies(type);
    movieListController.updateMovieList(sqlMovies, type);
    return true;
  }

  @override
  void initState() {
    super.initState();
    checkFavAndWatch();
  }

  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie!;
    TMDB tmdb = TMDB();

    Future<int> getDuration(int movieId) async {
      Movie m = await tmdb.getMovie(movieId);
      return m.movieDuration!;
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    /// Background Movie Image
                    Center(
                      child: OptimizedCacheImage(
                        fadeInDuration: Duration(milliseconds: 300),
                        fadeOutDuration: Duration(milliseconds: 300),
                        imageUrl: movie.movieBackground!,
                        placeholder: (context, url) =>
                            cachedBackgroundPlaceholder(screenHeight),
                        errorWidget: (context, url, error) =>
                            cachedBackgroundPlaceholder(screenHeight,
                                error: true),
                        imageBuilder: (context, imageProvider) =>
                            cachedBackgroundRealImage(
                                screenHeight, imageProvider),
                      ),
                    ),

                    /// Poster Image
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight / 6,
                          ),
                          Hero(
                            tag: widget.heroKey!,
                            child: Card(
                              elevation: 10,
                              child: OptimizedCacheImage(
                                fadeInDuration: Duration(milliseconds: 300),
                                fadeOutDuration: Duration(milliseconds: 300),
                                imageUrl: movie.moviePoster!,
                                placeholder: (context, url) =>
                                    cachedPosterPlaceholder(
                                        screenHeight, screenWidth),
                                errorWidget: (context, url, error) =>
                                    cachedPosterPlaceholder(
                                        screenHeight, screenWidth,
                                        error: true),
                                imageBuilder: (context, imageProvider) =>
                                    cachedPosterRealImage(screenHeight,
                                        screenWidth, imageProvider),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Shadow behind icons
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.0)
                          ],
                          stops: [0.0, 0.8],
                        ),
                      ),
                    ),

                    /// Back Arrow, watch later and favourite icon buttons
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StackIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Row(
                            children: [
                              StackIconButton(
                                icon: Icons.home_outlined,
                                onPressed: () {
                                  Get.offAll(() => MainScreen());
                                },
                              ),
                              StackIconButton(
                                icon: watchIcon,
                                color: watIcoState ? Colors.lime : Colors.white,
                                onPressed: () async {
                                  if (watIcoState) {
                                    await _dbHelper.remMovie(movie, 'wat');
                                    Fluttertoast.showToast(
                                        msg: 'Removed from Watchlist');
                                  } else {
                                    await _dbHelper.addMovie(movie, 'wat');
                                    Fluttertoast.showToast(
                                        msg: 'Added to Watchlist');
                                  }

                                  setState(() {
                                    watchIcon = watIcoState
                                        ? Icons.bookmark_border
                                        : Icons.bookmark;
                                    watIcoState = !watIcoState;
                                  });

                                  await fetchSqlMovies('wat');
                                },
                              ),
                              StackIconButton(
                                icon: favIcon,
                                color: favIcoState ? Colors.red : Colors.white,
                                onPressed: () async {
                                  if (favIcoState) {
                                    await _dbHelper.remMovie(movie, 'fav');
                                    Fluttertoast.showToast(
                                        msg: 'Removed from Favourites');
                                  } else {
                                    await _dbHelper.addMovie(movie, 'fav');
                                    Fluttertoast.showToast(
                                        msg: 'Added to Favourites');
                                  }

                                  setState(() {
                                    favIcon = favIcoState
                                        ? Icons.favorite_border
                                        : Icons.favorite;
                                    favIcoState = !favIcoState;
                                  });

                                  await fetchSqlMovies('fav');
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    /// Youtube Trailer Button
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight / 6 - screenHeight / 9.5,
                          ),
                          RawMaterialButton(
                            constraints: BoxConstraints(
                              maxHeight: screenWidth / 5,
                              maxWidth: screenWidth / 5,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth / 5)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                TransparentRoute(
                                  builder: (context) => YoutubeScreen(
                                    movieId: movie.movieId,
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                width: screenWidth / 8,
                                height: screenWidth / 8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    screenWidth / 8,
                                  ),
                                ),
                                child: Icon(
                                  Icons.play_circle_filled_outlined,
                                  size: screenWidth / 8,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenWidth / 36,
                ),

                /// Movie Title
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      movie.movieTitle!,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: screenWidth / 13,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenWidth / 60,
                ),

                /// Release Date, Genre and Duration
                FutureBuilder<int>(
                    future: getDuration(movie.movieId!),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return underTitleText(context, movie, snapshot.data!);
                      } else {
                        return underTitleText(context, movie, 0);
                      }
                    }),
                SizedBox(
                  height: screenWidth / 51.5,
                ),

                /// Movie Rating Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: movie.movieRate! * .5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: screenWidth / 18,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color(0xfffb6a17),
                      ),
                      unratedColor: Color(0xfffecad7),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.movie!.movieRate!.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: screenWidth / 20,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenWidth / 20,
                ),

                /// Plot Summary Section
                /// TODO: Use ReadMore here
                DetailsSection(
                  title: 'Plot Summary',
                  titleSize: screenWidth / 15,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth / 36, 0, screenWidth / 36, 0),
                    child: Text(
                      '${movie.movieDescription}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Theme.of(context).shadowColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  verticalPadding: screenWidth / 24,
                ),

                /// Cast Section
                DetailsSection(
                  title: 'Cast',
                  titleSize: screenWidth / 15,
                  child: FutureBuilder<List<Actor>>(
                    future: tmdb.getActorsCast(movie.movieId!),
                    builder: (context, AsyncSnapshot<List<Actor>> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.length == 0
                            ? NotFoundWidget(context, 'cast')
                            : castMovieListView(context, snapshot.data!);
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
                  verticalPadding: screenWidth / 24,
                ),

                /// Similar Movies Section
                DetailsSection(
                  title: 'Similar Movies',
                  titleSize: screenWidth / 15,
                  child: FutureBuilder<List<Movie>>(
                    future: tmdb.getMoviesSimilar(movie.movieId!),
                    builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.length == 0
                            ? NotFoundWidget(context, 'movies')
                            : movieHorizontalListView(context, snapshot.data!);
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
                  verticalPadding: screenWidth / 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget underTitleText(context, Movie movie, int duration) {
  return Text(
    '${movie.movieRelease!.split('-')[0]} • ${movie.movieCategory} • ${TMDB.toGoodTime(duration)}',
    style: Theme.of(context).textTheme.headline2!.copyWith(
          fontSize: MediaQuery.of(context).size.width / 24,
          letterSpacing: 1,
          fontWeight: FontWeight.normal,
        ),
  );
}

Widget cachedPosterRealImage(
    double height, double width, ImageProvider imageProvider) {
  return Container(
    height: height / 3.897,
    width: width / 2.769,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget cachedPosterPlaceholder(double height, double width,
    {bool error = false}) {
  return Container(
    height: height / 3.897,
    width: width / 2.769,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
      image: DecorationImage(
        image: AssetImage('images/placeholder${error ? 'Error' : ''}.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget cachedBackgroundRealImage(screenHeight, ImageProvider imageProvider) {
  return Container(
    height: screenHeight / 3,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget cachedBackgroundPlaceholder(screenHeight, {bool error = false}) {
  return Container(
    height: screenHeight / 3,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
      image: DecorationImage(
        image: AssetImage('images/placeholder${error ? 'Error' : ''}.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget NotFoundWidget(context, String errorText) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Center(
      child: Text(
        'No $errorText found!',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              fontSize: MediaQuery.of(context).size.width / 20,
              color: Theme.of(context).accentColor,
            ),
      ),
    ),
  );
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
