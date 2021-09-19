import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/models/movie.dart';
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
  IconData favIcon = Icons.favorite_border;
  IconData watchIcon = Icons.bookmark_border;
  bool favIconDefault = true;
  bool watchIconDefault = true;

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
          physics: ScrollPhysics(),
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
                                    cachedPosterPlaceholder(),
                                errorWidget: (context, url, error) =>
                                    cachedPosterPlaceholder(error: true),
                                imageBuilder: (context, imageProvider) =>
                                    cachedPosterRealImage(imageProvider),
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
                                icon: watchIcon,
                                color: watchIconDefault
                                    ? Colors.white
                                    : Colors.lime,
                                onPressed: () {
                                  setState(() {
                                    watchIcon = watchIconDefault
                                        ? Icons.bookmark
                                        : Icons.bookmark_border;
                                    watchIconDefault = !watchIconDefault;
                                  });
                                },
                              ),
                              StackIconButton(
                                icon: favIcon,
                                color:
                                    favIconDefault ? Colors.white : Colors.red,
                                onPressed: () {
                                  setState(() {
                                    favIcon = favIconDefault
                                        ? Icons.favorite
                                        : Icons.favorite_border;
                                    favIconDefault = !favIconDefault;
                                  });
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
                            height: screenHeight / 6 - 80,
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
                                    tmdb: tmdb,
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
                                  color: Colors.red,
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
                  height: 10,
                ),

                /// Movie Title
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      movie.movieTitle!,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),

                /// Release Date, Genre and Duration
                FutureBuilder<int>(
                    future: getDuration(movie.movieId!),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return underTitleText(movie, snapshot.data!);
                      } else {
                        return underTitleText(movie, 0);
                      }
                    }),
                SizedBox(
                  height: 7,
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
                      itemSize: 20,
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
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),

                /// Plot Summary Section
                /// TODO: Use ReadMore here
                DetailsSection(
                  title: 'Plot Summary',
                  titleSize: screenWidth / 15,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      '${movie.movieDescription}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  verticalPadding: 15,
                ),

                /// Cast Section
                DetailsSection(
                  title: 'Cast',
                  titleSize: screenWidth / 15,
                  child: FutureBuilder<List<Actor>>(
                    future: tmdb.getActorsCast(movie.movieId!),
                    builder: (context, AsyncSnapshot<List<Actor>> snapshot) {
                      if (snapshot.hasData) {
                        return castMovieListView(context, snapshot.data!);
                      } else {
                        return SpinKitThreeBounce(
                            color: kMaterialBlueColor, size: 40);
                      }
                    },
                  ),
                  verticalPadding: 15,
                ),

                /// Similar Movies Section
                DetailsSection(
                  title: 'Similar Movies',
                  titleSize: screenWidth / 15,
                  child: FutureBuilder<List<Movie>>(
                    future: tmdb.getMoviesSimilar(movie.movieId!),
                    builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                      if (snapshot.hasData) {
                        return movieHorizontalListView(context, snapshot.data!);
                      } else {
                        return SpinKitThreeBounce(
                            color: kMaterialBlueColor, size: 40);
                      }
                    },
                  ),
                  verticalPadding: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget underTitleText(Movie movie, int duration) {
  return Text(
    '${movie.movieRelease!.split('-')[0]} • ${movie.movieCategory} • ${TMDB.toGoodTime(duration)}',
    style: TextStyle(
      fontSize: 15,
      letterSpacing: 1,
    ),
  );
}

Widget cachedPosterRealImage(ImageProvider imageProvider) {
  return Container(
    height: 195,
    width: 130,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget cachedPosterPlaceholder({bool error = false}) {
  return Container(
    height: 195,
    width: 130,
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
