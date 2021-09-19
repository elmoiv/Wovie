import 'package:flutter/material.dart';

void navPushTo(context, screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void navPushRepTo(context, screen, {bool noAnimation = false}) {
  Navigator.pushReplacement(
    context,
    noAnimation
        ? PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => screen,
            transitionDuration: Duration.zero,
          )
        : MaterialPageRoute(
            builder: (context) => screen,
          ),
  );
}
