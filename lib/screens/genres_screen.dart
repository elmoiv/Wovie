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
              icon: item['icon'],
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
    'icon': Icons.local_police,
  },
  {
    'color': Colors.greenAccent,
    'title': 'Adventure',
    'invert': true,
    'function': getGenreAdventure,
    'icon': Icons.public,
  },
  {
    'color': Colors.redAccent,
    'title': 'Animation',
    'function': getGenreAnimation,
    'icon': Icons.child_care,
  },
  {
    'color': Colors.yellowAccent,
    'title': 'Comedy',
    'invert': true,
    'function': getGenreComedy,
    'icon': Icons.sentiment_very_satisfied,
  },
  {
    'color': Colors.purple,
    'title': 'Crime',
    'function': getGenreCrime,
    'icon': Icons.sports_kabaddi,
  },
  {
    'color': Colors.teal,
    'title': 'Documentary',
    'function': getGenreDocumentary,
    'icon': Icons.videocam,
  },
  {
    'color': Colors.red,
    'title': 'Drama',
    'function': getGenreDrama,
    'icon': Icons.theater_comedy,
  },
  {
    'color': Colors.lightBlueAccent,
    'title': 'Family',
    'function': getGenreFamily,
    'icon': Icons.family_restroom,
  },
  {
    'color': Color(0xffff8671),
    'title': 'Fantasy',
    'function': getGenreFantasy,
    'icon': Icons.flare,
  },
  {
    'color': Color(0xFFFFD700),
    'title': 'History',
    'invert': true,
    'function': getGenreHistory,
    'icon': Icons.history_edu,
  },
  {
    'color': Colors.green,
    'title': 'Horror',
    'function': getGenreHorror,
    'icon': Icons.mood_bad,
  },
  {
    'color': Colors.orange,
    'title': 'Music',
    'function': getGenreMusic,
    'icon': Icons.music_note,
  },
  {
    'color': Color(0xff316167),
    'title': 'Mystery',
    'function': getGenreMystery,
    'icon': Icons.search,
  },
  {
    'color': Colors.pinkAccent,
    'title': 'Romance',
    'function': getGenreRomance,
    'icon': Icons.favorite,
  },
  {
    'color': Color(0xff171722),
    'title': 'Science Fiction',
    'function': getGenreScienceFiction,
    'icon': Icons.smart_toy,
  },
  {
    'color': Color(0xfff7f6a8),
    'title': 'TV Movie',
    'invert': true,
    'function': getGenreTVMovie,
    'icon': Icons.live_tv,
  },
  {
    'color': Color(0xff534a43),
    'title': 'Thriller',
    'function': getGenreThriller,
    'icon': Icons.carpenter,
  },
  {
    'color': Colors.grey,
    'title': 'War',
    'function': getGenreWar,
    'icon': Icons.military_tech,
  },
  {
    'color': Colors.brown,
    'title': 'Western',
    'function': getGenreWestern,
    'icon': Icons.explore,
  },
];
