import 'package:flutter/material.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/screens/actor_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/actor_tile.dart';

Widget castMovieListView(context, List<Actor> castList) {
  return Container(
    height: 150,
    child: ListView.builder(
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
            width: MediaQuery.of(context).size.width / 3.5,
            height: MediaQuery.of(context).size.height / 5,
            child: actorTile(
              context,
              castList[index],
            ),
          ),
        );
      },
    ),
  );
}
