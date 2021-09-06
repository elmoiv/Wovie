import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/model/actor.dart';
import 'package:wovie/model/movie.dart';
import 'package:wovie/widgets/movie_cast_horizontal.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';

class MovieScreen extends StatefulWidget {
  final Movie? movie;
  final TMDB? tmdb;
  MovieScreen({this.movie, this.tmdb});

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  Icon favIcon = Icon(Icons.favorite_border, color: Colors.white);
  Icon watchIcon = Icon(Icons.bookmark_border, color: Colors.white);
  bool favIconDefault = true;
  bool watchIconDefault = true;

  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie!;
    TMDB tmdb = widget.tmdb!;

    Future<int> getDuration(int movieId) async {
      Movie m = await tmdb.getMovie(movieId);
      return m.movieDuration!;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: OptimizedCacheImage(
                        fadeOutDuration: Duration(milliseconds: 300),
                        imageUrl: movie.movieBackground!,
                        placeholder: (context, url) =>
                            cachedBackgroundPlaceholder(),
                        errorWidget: (context, url, error) =>
                            cachedBackgroundPlaceholder(error: true),
                        imageBuilder: (context, imageProvider) =>
                            cachedBackgroundRealImage(imageProvider),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                          ),
                          Hero(
                            tag: '${movie.movieId}',
                            child: Card(
                              elevation: 10,
                              child: OptimizedCacheImage(
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
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    watchIcon = watchIconDefault
                                        ? Icon(Icons.bookmark,
                                            color: Colors.lime)
                                        : Icon(Icons.bookmark_border,
                                            color: Colors.white);
                                    watchIconDefault = !watchIconDefault;
                                  });
                                },
                                icon: watchIcon,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    favIcon = favIconDefault
                                        ? Icon(Icons.favorite,
                                            color: Colors.red)
                                        : Icon(Icons.favorite_border,
                                            color: Colors.white);
                                    favIconDefault = !favIconDefault;
                                  });
                                },
                                icon: favIcon,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
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
                FutureBuilder<int>(
                    future: getDuration(movie.movieId!),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return underTitleText(movie, tmdb, snapshot.data!);
                      } else {
                        return underTitleText(movie, tmdb, 0);
                      }
                    }),
                SizedBox(
                  height: 7,
                ),
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
                        fontSize: MediaQuery.of(context).size.width / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                detailsSection(
                  title: 'Plot Summary',
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      '${movie.movieDescription}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  verticalPadding: 15,
                ),
                detailsSection(
                  title: 'Cast',
                  child: FutureBuilder<List<Actor>>(
                    future: tmdb.getCast(movie.movieId!),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return castMovieListView(context, snapshot.data!, tmdb);
                      } else {
                        return SpinKitThreeBounce(
                            color: kMaterialBlueColor, size: 40);
                      }
                    },
                  ),
                  verticalPadding: 15,
                ),
                detailsSection(
                  title: 'Similar Movies',
                  child: FutureBuilder<List<Movie>>(
                    future: tmdb.getSimilar(movie.movieId!),
                    builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                      if (snapshot.hasData) {
                        return movieHorizontalListView(
                            context, snapshot.data!, tmdb);
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

Widget detailsSection({String? title, dynamic child, double? verticalPadding}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            '| ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xfffb6a17),
            ),
          ),
          Text(
            title!,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      child!,
      SizedBox(
        height: verticalPadding!,
      )
    ],
  );
}

Widget underTitleText(Movie movie, TMDB tmdb, int duration) {
  return Text(
    '${movie.movieRelease!.split('-')[0]} • ${movie.movieCategory} • ${tmdb.toGoodTime(duration)}',
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

Widget cachedBackgroundRealImage(ImageProvider imageProvider) {
  return Container(
    height: 250,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
      ),
    ),
  );
}

Widget cachedBackgroundPlaceholder({bool error = false}) {
  return Container(
    height: 250,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
      image: DecorationImage(
        image: AssetImage('images/placeholder${error ? 'Error' : ''}.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
