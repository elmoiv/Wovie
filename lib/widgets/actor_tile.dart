import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/models/actor.dart';

Widget actorTile(context, Actor actor) {
  double screenWidth = MediaQuery.of(context).size.width;
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
                width: screenWidth / 4.5,
                height: screenWidth / 4.5,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: screenWidth / 9,
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
                width: screenWidth / 4.5,
                height: screenWidth / 4.5,
                child: Icon(
                  Icons.error,
                  size: screenWidth / 9,
                ),
              ),
            ),
          ),
        ),
        imageBuilder: (context, imageProvider) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: circularContainer(
            child: CircleAvatar(
              radius: screenWidth / 8.5,
              backgroundImage: imageProvider,
            ),
          ),
        ),
      ),
      SizedBox(
        height: screenWidth / 45,
      ),
      Text(
        actor.actorName!,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: screenWidth / 27,
          color: Theme.of(context).shadowColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actor.actorCharacter != '-'
          ? Text(
              actor.actorCharacter!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth / 27.7,
                color: Theme.of(context).shadowColor.withOpacity(0.5),
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
