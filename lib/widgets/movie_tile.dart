import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/model/movie.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/screens/movie_screen.dart';

class MovieTile extends StatefulWidget {
  final Movie? movie;
  final TMDB? tmdb;
  MovieTile({this.movie, this.tmdb});

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie!;
    TMDB tmdb = widget.tmdb!;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieScreen(
                movie: movie,
                tmdb: tmdb,
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
        ),
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCircularBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1.1,
                blurRadius: 2.5,
                offset: Offset(0, 0), // changes position of shadow
              )
            ],
          ),
          child: Stack(
            children: [
              /// Picture and text container
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: Hero(
                      tag: '${movie.movieId}',
                      child: OptimizedCacheImage(
                        fit: BoxFit.cover,
                        fadeOutDuration: Duration(milliseconds: 300),
                        imageUrl: widget.movie!.moviePoster!,
                        placeholder: (context, url) => cachedPlaceholder(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder: (context, imageProvider) =>
                            cachedRealImage(imageProvider),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(kCircularBorderRadius),
                          bottomRight: Radius.circular(kCircularBorderRadius),
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
                  Expanded(flex: 6, child: Container()),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 6,
                          ),
                          percentIndicator(
                            percent: movie.movieRate! * 10,
                            radius: screenWidth - 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),

              /// Title and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 109, child: Container()),
                  Expanded(
                    flex: 18,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  movie.movieTitle!,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: screenWidth / 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  tmdbDate(movie.movieRelease),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: screenWidth / 38,
                                      color: Color(0x77000000)),
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
          ),
        ),
      ),
    );
  }
}

/// Old Movie Tile Backup
// class _MovieTileState extends State<MovieTile> {
//   @override
//   Widget build(BuildContext context) {
//     Movie movie = widget.movie!;
//     TMDB tmdb = widget.tmdb!;
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: Container(
//         child: RawMaterialButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MovieScreen(
//                   movie: movie,
//                   tmdb: tmdb,
//                 ),
//               ),
//             );
//           },
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(kCircularBorderRadius),
//           ),
//           child: Stack(
//             children: [
//               Hero(
//                 tag: '${movie.movieTitle}',
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   fadeOutDuration: Duration(milliseconds: 300),
//                   imageUrl: widget.movie!.moviePoster!,
//                   placeholder: (context, url) => cachedPlaceholder(),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                   imageBuilder: (context, imageProvider) =>
//                       cachedRealImage(imageProvider),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(kCircularBorderRadius),
//                   ),
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.7),
//                       Colors.black.withOpacity(0.0)
//                     ],
//                     stops: [0.0, 0.6],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 5,
//                 left: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width / 3.3,
//                       child: Text(
//                         '${widget.movie!.movieTitle}',
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.width / 30,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RatingBar.builder(
//                           ignoreGestures: true,
//                           initialRating: movie.movieRate! * .5,
//                           minRating: 1,
//                           direction: Axis.horizontal,
//                           allowHalfRating: true,
//                           itemCount: 5,
//                           itemSize: MediaQuery.of(context).size.width / 30,
//                           itemBuilder: (context, _) => Icon(
//                             Icons.star,
//                             color: Color(0xfffb6a17),
//                           ),
//                           unratedColor: Colors.white,
//                           onRatingUpdate: (rating) {},
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           '${widget.movie!.movieRate!.toStringAsFixed(1)}',
//                           style: TextStyle(
//                             fontSize: MediaQuery.of(context).size.width / 30,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
    width: radius / 15 + 3,
    height: radius / 15 + 3,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        radius / 15 + 3,
      ),
      color: Color(0xff081c22),
    ),
    child: Center(
      child: CircularPercentIndicator(
        radius: radius / 15,
        lineWidth: 1.5,
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
                        fontSize: radius / 34 - 5,
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
      image: DecorationImage(
        image: AssetImage('images/placeholder.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
