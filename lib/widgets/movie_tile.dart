import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/screens/movie_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:uuid/uuid.dart';

class MovieTile extends StatefulWidget {
  final Movie? movie;
  final bool? blurNsfw;
  MovieTile({this.movie, this.blurNsfw = false});

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie!;

    String uuid = Uuid().v4();

    return Container(
      child: RawMaterialButton(
        onPressed: () {
          navPushTo(
            context,
            MovieScreen(
              movie: movie,
              heroKey: '$uuid',
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
        ),

        /// Shadow behind tile
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCircularBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
                spreadRadius: 1.1,
                blurRadius: 2.5,
                offset: Offset(0, 0), // changes position of shadow
              )
            ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  /// Picture and text container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Hero(
                          tag: '$uuid',
                          child: OptimizedCacheImage(
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 300),
                            fadeOutDuration: Duration(milliseconds: 300),
                            imageUrl: widget.movie!.moviePoster!,
                            placeholder: (context, url) => cachedPlaceholder(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageBuilder: (context, imageProvider) =>
                                cachedRealImage(imageProvider),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(kCircularBorderRadius),
                              bottomRight:
                                  Radius.circular(kCircularBorderRadius),
                            ),
                          ),
                          // child: Text('df'),
                        ),
                      ),
                    ],
                  ),

                  /// Percentage Circular
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 583, child: Container()),
                      Expanded(
                        flex: 217,
                        child: Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: constraints.maxWidth / 17,
                              ),
                              percentIndicator(
                                percent: movie.movieRate! * 10,
                                radius: constraints.maxWidth * 3.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: Container(),
                      ),
                    ],
                  ),

                  /// Title and Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 108, child: Container()),
                      Expanded(
                        flex: 19,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth / 17,
                                    ),
                                    child: Text(
                                      movie.movieTitle!,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            fontSize: constraints.maxWidth / 10,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth / 17,
                                    ),
                                    child: Text(
                                      tmdbDate(movie.movieRelease),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: constraints.maxWidth / 10,
                                            color: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(.5),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

String tmdbDate(String? apiDate) {
  List dateParts = apiDate!.split('-');
  if (dateParts.length < 3) return 'Coming Soon';
  String year = dateParts[0];
  String day = dateParts[2];
  String? month = {
    '01': 'Jan',
    '02': 'Feb',
    '03': 'Mar',
    '04': 'Apr',
    '05': 'May',
    '06': 'Jun',
    '07': 'Jul',
    '08': 'Aug',
    '09': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec'
  }[dateParts[1]];
  return '$month $day, $year';
}

Widget percentIndicator({double percent = 100, double radius = 50}) {
  int relatedColor() {
    if (percent > 69) {
      return 0xff21d07a;
    }
    if (percent > 49) {
      return 0xffd0d330;
    }
    if (percent > 0) {
      return 0xffdb2360;
    }
    return 0xff5b5d5e;
  }

  int percentColor = relatedColor();

  return Container(
    width: radius / 15 + radius / 215,
    height: radius / 15 + radius / 215,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        radius / 15 + radius / 215,
      ),
      color: Color(0xff081c22),
    ),
    child: Center(
      child: CircularPercentIndicator(
        radius: radius / 15,
        lineWidth: radius / 226,
        backgroundColor: Color(percentColor - 0xbb000000),
        progressColor: Color(percentColor),
        percent: percent / 100,
        center: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              percent != 0 ? '${(percent).toInt()}' : 'NR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: radius / 36,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Expanded(flex: 2, child: SizedBox()),
                  Expanded(
                    flex: 5,
                    child: Text(
                      percent != 0 ? '%' : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: radius / 34 - radius / 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget cachedRealImage(ImageProvider imageProvider) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kCircularBorderRadius),
        topRight: Radius.circular(kCircularBorderRadius),
      ),
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget cachedPlaceholder() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kCircularBorderRadius),
        topRight: Radius.circular(kCircularBorderRadius),
      ),
      image: DecorationImage(
        image: AssetImage('images/placeholder.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
