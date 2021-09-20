import 'package:flutter/material.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/screens/actor_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/actor_tile.dart';
import 'package:wovie/widgets/overscroll_color.dart';

Widget castMovieListView(context, List<Actor> castList) {
  return Container(
    height: 150,
    child: OverScrollColor(
      direction: AxisDirection.right,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
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
                context,
                castList[index],
              ),
            ),
          );
        },
      ),
    ),
  );
}
