import 'package:flutter/material.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/utils/easy_navigator.dart';

Widget genreTile(context, {String? title, Color? color, dynamic navigateTo}) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: screenWidth / 2.5,
      height: screenWidth / 2.5 * 0.5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kCircularBorderRadius + 10),
        boxShadow: [
          BoxShadow(
            color: color!.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5), // changes position of shadow
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kCircularBorderRadius + 10),
              ),
              onPressed: () {
                navPushTo(context, navigateTo);
              },
              child: Center(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: screenWidth / 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
