import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeScreen extends StatefulWidget {
  final int? movieId;
  final TMDB? tmdb;
  YoutubeScreen({this.movieId, this.tmdb});

  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  YoutubePlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x99000000),
      body: SafeArea(
        child: Stack(
          children: [
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: FutureBuilder<String>(
                    future: widget.tmdb!.getMovieVideoKey(widget.movieId!),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        controller = YoutubePlayerController(
                          initialVideoId: snapshot.data!,
                          params: YoutubePlayerParams(
                            autoPlay: true,
                            mute: false,
                          ),
                        );
                        return YoutubePlayerIFrame(
                          controller: controller!,
                        );
                      } else {
                        return SpinKitDoubleBounce(
                          color: kMaterialBlueColor,
                          size: 80,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
