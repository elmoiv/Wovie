import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/widgets/genre_tile.dart';
import 'package:wovie/widgets/overscroll_color.dart';

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
        centerTitle: true,
        title: Text(
          'Movie Genres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).shadowColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
      ),
      body: OverScrollColor(
        direction: AxisDirection.down,
        child: GridView.builder(
          itemCount: genreTileParams.length,
          physics: ClampingScrollPhysics(),
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
                icon: item['icon'],
                invertTitleColor: item.containsKey('invert'),
                movieFunc: item['function'],
              ),
            );
          },
        ),
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
    'icon': '💣',
  },
  {
    'color': Colors.greenAccent,
    'title': 'Adventure',
    'function': getGenreAdventure,
    'icon': '🗺️',
  },
  {
    'color': Colors.redAccent,
    'title': 'Animation',
    'function': getGenreAnimation,
    'icon': '🏰',
  },
  {
    'color': Colors.yellowAccent,
    'title': 'Comedy',
    'invert': true,
    'function': getGenreComedy,
    'icon': '😂',
  },
  {
    'color': Colors.purple,
    'title': 'Crime',
    'function': getGenreCrime,
    'icon': '💀',
  },
  {
    'color': Colors.teal,
    'title': 'Documentary',
    'function': getGenreDocumentary,
    'icon': '🎥',
  },
  {
    'color': Colors.red,
    'title': 'Drama',
    'function': getGenreDrama,
    'icon': '🎭',
  },
  {
    'color': Colors.lightBlueAccent,
    'title': 'Family',
    'function': getGenreFamily,
    'icon': '👨‍👩‍👦',
  },
  {
    'color': Color(0xffff8671),
    'title': 'Fantasy',
    'function': getGenreFantasy,
    'icon': '✨',
  },
  {
    'color': Color(0xFFFFD700),
    'title': 'History',
    'function': getGenreHistory,
    'icon': '📜',
  },
  {
    'color': Colors.green,
    'title': 'Horror',
    'function': getGenreHorror,
    'icon': '😱',
  },
  {
    'color': Colors.orange,
    'title': 'Music',
    'function': getGenreMusic,
    'icon': '🎵',
  },
  {
    'color': Color(0xff316167),
    'title': 'Mystery',
    'function': getGenreMystery,
    'icon': '🔎‍',
  },
  {
    'color': Colors.pinkAccent,
    'title': 'Romance',
    'function': getGenreRomance,
    'icon': '💘',
  },
  {
    'color': Color(0xff171722),
    'title': 'Science Fiction',
    'function': getGenreScienceFiction,
    'icon': '👽',
  },
  {
    'color': Color(0xfff7f6a8),
    'title': 'TV Movie',
    'invert': true,
    'function': getGenreTVMovie,
    'icon': '📺',
  },
  {
    'color': Color(0xff534a43),
    'title': 'Thriller',
    'function': getGenreThriller,
    'icon': '🔪',
  },
  {
    'color': Colors.grey,
    'title': 'War',
    'function': getGenreWar,
    'icon': '🔫',
  },
  {
    'color': Colors.brown,
    'title': 'Western',
    'function': getGenreWestern,
    'icon': '🤠',
  },
];
