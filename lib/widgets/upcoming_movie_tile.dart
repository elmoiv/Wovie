import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/screens/movie_screen.dart';
import 'package:wovie/screens/youtube_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/utils/transparent_page_route.dart';

class UpcomingMovieTile extends StatefulWidget {
  final Movie? movie;
  UpcomingMovieTile({this.movie});

  @override
  _UpcomingMovieTileState createState() => _UpcomingMovieTileState();
}

class _UpcomingMovieTileState extends State<UpcomingMovieTile> {
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie!;

    double screenWidth = MediaQuery.of(context).size.width;
    return RawMaterialButton(
      onPressed: () {
        navPushTo(
          context,
          MovieScreen(
            movie: movie,
            heroKey: '${movie.movieId}-upcoming',
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCircularBorderRadius + 5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCircularBorderRadius + 5),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
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
                    child: Hero(
                      tag: '${movie.movieId}-upcoming',
                      child: OptimizedCacheImage(
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 300),
                        fadeOutDuration: Duration(milliseconds: 300),
                        imageUrl: widget.movie!.movieBackground!,
                        placeholder: (context, url) => cachedPlaceholder(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder: (context, imageProvider) =>
                            cachedRealImage(imageProvider),
                      ),
                    ),
                  ),
                ],
              ),

              /// Shadow under title
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(kCircularBorderRadius + 5),
                  ),
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

              /// Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 1, child: Container()),
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
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  movie.movieTitle!,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: screenWidth / 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SourceSansPro',
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

              /// Youtube Player Button
              Center(
                child: RawMaterialButton(
                  constraints: BoxConstraints(
                    maxHeight: screenWidth / 5,
                    maxWidth: screenWidth / 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth / 5),
                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cachedRealImage(ImageProvider imageProvider) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kCircularBorderRadius + 5),
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
      borderRadius: BorderRadius.circular(kCircularBorderRadius + 5),
      image: DecorationImage(
        image: AssetImage('images/placeholder.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
