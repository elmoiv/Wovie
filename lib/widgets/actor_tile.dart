import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/models/actor.dart';

Widget actorTile(Actor actor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      OptimizedCacheImage(
        fit: BoxFit.cover,
        fadeInDuration: Duration(milliseconds: 300),
        fadeOutDuration: Duration(milliseconds: 300),
        imageUrl: actor.actorPhoto!,
        placeholder: (context, url) => circularContainer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => circularContainer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Icon(
                  Icons.error,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        imageBuilder: (context, imageProvider) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: circularContainer(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        actor.actorName!,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actor.actorCharacter != '-'
          ? Text(
              actor.actorCharacter!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            )
          : Container(),
    ],
  );
}

Widget circularContainer({Widget? child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            offset: Offset.fromDirection(1, 1),
            blurRadius: 2,
            color: Color(0x33000000),
            spreadRadius: 2)
      ],
    ),
    child: child,
  );
}
