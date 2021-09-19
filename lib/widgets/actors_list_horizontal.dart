import 'package:flutter/material.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/screens/actor_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/actor_tile.dart';

Widget castMovieListView(context, List<Actor> castList) {
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
            navPushTo(
              context,
              ActorScreen(
                actor: castList[index],
              ),
            );
          },
          child: Container(
            width: 100,
            height: 150,
            child: actorTile(
              castList[index],
            ),
          ),
        );
      },
    ),
  );
}
