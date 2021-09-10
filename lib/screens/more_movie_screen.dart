import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/models/movie.dart';
import '../widgets/movie_grid_view.dart';
import 'package:wovie/widgets/msg_box.dart';

class MoreMoviesScreen extends StatefulWidget {
  final String? apiKey;
  MoreMoviesScreen({this.apiKey});

  @override
  _MoreMoviesScreenState createState() => _MoreMoviesScreenState();
}

class _MoreMoviesScreenState extends State<MoreMoviesScreen> {
  TMDB? tmdb;
  List<Movie> homeMovieList = [];
  RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    tmdb = TMDB();
    tmdb!.resetPages();
    tmdb!.API_KEY = widget.apiKey!;
    getPopular();
  }

  void getPopular() async {
    try {
      dynamic x = await tmdb!.getPopular();
      setState(() {
        homeMovieList = x;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => MsgBox(
          title: 'Error Caught',
          content: e.toString(),
        ),
      );
      setState(() {
        homeMovieList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular Movies',
          style: TextStyle(color: kMaterialBlueColor),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: kMaterialBlueColor),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: true,
                    controller: _controller,
                    header: null,
                    footer: ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
                    child: movieGridView(context, homeMovieList, tmdb!),
                    onLoading: () async {
                      Future.delayed(Duration(milliseconds: 500), () {});
                      dynamic x = [];
                      try {
                        x = await tmdb!.getPopular();
                      } catch (e) {
                        errorMsg(context, e);
                        _controller.loadFailed();
                        return;
                      }
                      setState(() {
                        homeMovieList.addAll(x);
                      });
                      _controller.loadComplete();
                    },
                    onRefresh: () async {
                      setState(() {
                        homeMovieList = [];
                      });
                      tmdb!.resetPages();
                      dynamic x = [];
                      try {
                        x = await tmdb!.getPopular();
                      } catch (e) {
                        errorMsg(context, e);
                        _controller.refreshFailed();
                        return;
                      }
                      setState(() {
                        homeMovieList = x;
                      });
                      _controller.refreshCompleted();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
