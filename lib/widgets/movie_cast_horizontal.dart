import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/actor_screen.dart';
import 'package:wovie/widgets/cast_tile.dart';

Widget castMovieListView(context, List castList, TMDB tmdb) {
  return Container(
    height: 150,
    child: ListView.builder(
      physics: ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: castList.length,
      itemBuilder: (context, index) {
        return RawMaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActorScreen(
                  actor: castList[index],
                  tmdb: tmdb,
                ),
              ),
            );
          },
          child: Container(
            width: 100,
            height: 150,
            child: castTile(
              castList[index],
            ),
          ),
        );
      },
    ),
  );
}
