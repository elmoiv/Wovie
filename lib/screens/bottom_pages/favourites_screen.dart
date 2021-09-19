import 'package:flutter/material.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/widgets/movie_tile.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: MovieTile(
              movie: Movie(
                movieId: 588228,
                movieDuration: 0,
                moviePoster:
                    'https://image.tmdb.org/t/p/w500/34nDCQZwaEvsy4CFO5hkGRFDCVU.jpg',
                movieCategory: 'Action',
                movieRate: 7.8,
                movieBackground:
                    'https://image.tmdb.org/t/p/w500/yizL4cEKsVvl17Wc1mGEIrQtM2F.jpg',
                movieDescription: 'Nice',
                movieRelease: '2021-09-03',
                movieTitle: 'The Tomorrow War',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
