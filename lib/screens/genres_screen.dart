import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/widgets/genre_tile.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  Widget build(BuildContext context) {
    TMDB tmdb = TMDB();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Genres',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GridView.builder(
        itemCount: genreTileParams.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          dynamic item = genreTileParams[index];
          return GridTile(
            child: genreTile(
              context,
              tmdb,
              color: item['color'],
              title: item['title'],
              invertTitleColor: item.containsKey('invert'),
              movieFunc: item['function'],
            ),
          );
        },
      ),
    );
  }
}

/// Colors inspired from https://ux.stackexchange.com/q/108294
List<Map<String, dynamic>> genreTileParams = [
  {
    'color': Colors.blueAccent,
    'title': 'Action',
    'function': getGenreAction,
  },
  {
    'color': Colors.greenAccent,
    'title': 'Adventure',
    'function': getGenreAdventure,
  },
  {
    'color': Colors.redAccent,
    'title': 'Animation',
    'function': getGenreAnimation,
  },
  {
    'color': Colors.yellowAccent,
    'title': 'Comedy',
    'invert': true,
    'function': getGenreComedy,
  },
  {
    'color': Colors.purple,
    'title': 'Crime',
    'function': getGenreCrime,
  },
  {
    'color': Colors.teal,
    'title': 'Documentary',
    'function': getGenreDocumentary,
  },
  {
    'color': Colors.red,
    'title': 'Drama',
    'function': getGenreDrama,
  },
  {
    'color': Colors.lightBlueAccent,
    'title': 'Family',
    'function': getGenreFamily,
  },
  {
    'color': Color(0xffff8671),
    'title': 'Fantasy',
    'function': getGenreFantasy,
  },
  {
    'color': Color(0xFFFFD700),
    'title': 'History',
    'function': getGenreHistory,
  },
  {
    'color': Colors.green,
    'title': 'Horror',
    'function': getGenreHorror,
  },
  {
    'color': Colors.orange,
    'title': 'Music',
    'function': getGenreMusic,
  },
  {
    'color': Color(0xff316167),
    'title': 'Mystery',
    'function': getGenreMystery,
  },
  {
    'color': Colors.pinkAccent,
    'title': 'Romance',
    'function': getGenreRomance,
  },
  {
    'color': Color(0xff171722),
    'title': 'Science Fiction',
    'function': getGenreScienceFiction,
  },
  {
    'color': Color(0xfff7f6a8),
    'title': 'TV Movie',
    'invert': true,
    'function': getGenreTVMovie,
  },
  {
    'color': Color(0xff534a43),
    'title': 'Thriller',
    'function': getGenreThriller,
  },
  {
    'color': Colors.grey,
    'title': 'War',
    'function': getGenreWar,
  },
  {
    'color': Colors.brown,
    'title': 'Western',
    'function': getGenreWestern,
  },
];
