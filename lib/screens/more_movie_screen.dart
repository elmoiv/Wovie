import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/models/movie.dart';
import '../widgets/movie_grid_view.dart';
import 'package:wovie/widgets/msg_box.dart';

class MoreMoviesScreen extends StatefulWidget {
  final String? title;
  final Function? movieFunc;
  final bool? addMoviesWordAtTheEnd;
  final String? customErrorMsg;
  MoreMoviesScreen(
      {this.title,
      this.movieFunc,
      this.addMoviesWordAtTheEnd = true,
      this.customErrorMsg = 'Nothing Found'});

  @override
  _MoreMoviesScreenState createState() => _MoreMoviesScreenState();
}

class _MoreMoviesScreenState extends State<MoreMoviesScreen> {
  TMDB tmdb = TMDB();
  List<Movie> moviesList = [];
  bool firstTimeSearch = true;
  RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    tmdb.resetPages();
    getMovies();
  }

  void getMovies(
      {bool append = false, List<void Function()>? refreshFuncs}) async {
    try {
      dynamic x = await widget.movieFunc!();

      setState(() {
        if (append) {
          moviesList.addAll(x);
        } else {
          moviesList = x;
        }
      });

      if (firstTimeSearch == true && x.length == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) => MsgBox(
            title: 'No Movies Found',
            content: widget.customErrorMsg,
          ),
        );
      }

      firstTimeSearch = false;

      // Success sent from controller
      if (refreshFuncs != null) refreshFuncs[0]();
    } catch (e) {
      // Fail sent from controller
      if (refreshFuncs != null) refreshFuncs[1]();

      setState(() {
        moviesList = append ? moviesList : [];
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => MsgBox(
          title: 'Error Caught',
          content: e.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool movieWord = widget.addMoviesWordAtTheEnd!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.title}${movieWord ? " Movies" : ""}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                    child: movieGridView(context, moviesList),
                    onLoading: () async {
                      // Future.delayed(Duration(milliseconds: 300), () {});
                      getMovies(
                        append: true,
                        refreshFuncs: [
                          _controller.loadComplete,
                          _controller.loadFailed
                        ],
                      );
                    },
                    onRefresh: () async {
                      tmdb.resetPages();
                      getMovies(
                        append: false,
                        refreshFuncs: [
                          _controller.refreshCompleted,
                          _controller.refreshFailed
                        ],
                      );
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
