import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wovie/controllers/database_realtime_controller.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/widgets/movie_grid_view.dart';
import 'package:wovie/widgets/msg_box.dart';

class FavOrWatchScreen extends StatefulWidget {
  final String? screenType;
  final String? screenTitle;
  final IconData? screenBackgroundIcon;

  FavOrWatchScreen(
      {this.screenType, this.screenTitle, this.screenBackgroundIcon});

  @override
  _FavOrWatchScreenState createState() => _FavOrWatchScreenState();
}

class _FavOrWatchScreenState extends State<FavOrWatchScreen> {
  List<Movie> movieList = [];

  final MovieListController movieListController =
      Get.put(MovieListController());

  Future<bool> fetchSqlMovies() async {
    List<Movie> sqlMovies = await DbHelper().getAllMovies(widget.screenType!);
    movieListController.updateMovieList(sqlMovies, widget.screenType!);
    return true;
  }

  Future<bool> removeAllSqlMovies() async {
    await DbHelper().remAllMovies(widget.screenType!);
    movieListController.updateMovieList([], widget.screenType!);
    movieListController.clearCounter('fav');
    movieListController.clearCounter('wat');
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchSqlMovies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    /// Clear badges counters
    return Scaffold(
      extendBody: true,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height / 10),
        child: FloatingActionButton(
          heroTag: null,
          elevation: 1,
          child: Icon(
            Icons.delete_forever,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return MsgBox(
                  title: 'Remove all',
                  content:
                      'You are about to remove all your ${widget.screenTitle!.toLowerCase()} movies!' +
                          '\n\nPress Yes to proceed.',
                  successText: 'Yes',
                  failureText: 'No',
                  onPressedSuccess: () {
                    removeAllSqlMovies();
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FutureBuilder<bool>(
          future: fetchSqlMovies(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return Obx(() {
                String type = widget.screenType!;
                return movieListController.getMovieList(type).length > 0
                    ? movieGridView(
                        context,
                        List<Movie>.from(
                          movieListController
                              .getMovieList(type)
                              .reversed
                              .toList(),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.screenBackgroundIcon,
                              size: height / 5,
                              color:
                                  Theme.of(context).shadowColor.withOpacity(.3),
                            ),
                            SizedBox(
                              height: height / 15,
                            ),
                            Text(
                              'Nothing added in ${widget.screenTitle}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: height / 20,
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(.3),
                              ),
                            )
                          ],
                        ),
                      );
              });
            } else {
              return SpinKitFadingFour(
                color: Theme.of(context).accentColor,
                size: 60,
              );
            }
          },
        ),
      ),
    );
  }
}
