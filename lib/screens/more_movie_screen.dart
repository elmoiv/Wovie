import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/models/movie.dart';
import '../widgets/movie_grid_view.dart';
import 'package:wovie/widgets/msg_box.dart';

class MoreMoviesScreen extends StatefulWidget {
  final String? title;
  final Function? movieFunc;
  final bool? addMoviesWordAtTheEnd;
  final String? customErrorMsg;
  MoreMoviesScreen({
    this.title,
    this.movieFunc,
    this.addMoviesWordAtTheEnd = true,
    this.customErrorMsg = 'Nothing Found',
  });

  @override
  _MoreMoviesScreenState createState() => _MoreMoviesScreenState();
}

class _MoreMoviesScreenState extends State<MoreMoviesScreen> {
  TMDB tmdb = TMDB();
  List<Movie> moviesList = [];
  bool firstTimeSearch = true;
  bool firstTimeBuild = true;
  bool isMovieFuncRunning = false;
  RefreshController _controller = RefreshController(initialRefresh: false);
  bool isLoading = false;
  Widget? smartRefresherChild;
  double _currentSliderValue = 3;

  @override
  void initState() {
    super.initState();
    tmdb.resetPages();
  }

  @override
  Widget build(BuildContext context) {
    bool movieWord = widget.addMoviesWordAtTheEnd!;
    double width = MediaQuery.of(context).size.width;

    /// Run getMovies one time only
    /// Moved from initState due to widget rebuild inheritance issues
    if (firstTimeBuild) {
      getMovies();
      firstTimeBuild = false;
    }

    String title = '${widget.title}${movieWord ? " Movies" : ""}';
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: width / 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
            ),
            SizedBox(
                width: width / 2.5 - title.length, child: TileSizeSlider()),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SmartRefresher(
                    header: MaterialClassicHeader(
                      color: Colors.white,
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    physics: ClampingScrollPhysics(),
                    enablePullUp: true,
                    enablePullDown: true,
                    controller: _controller,
                    footer: ClassicFooter(
                      loadStyle: LoadStyle.ShowWhenLoading,
                      loadingIcon: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    child: smartRefresherChild,
                    onLoading: () async {
                      getMovies(
                        append: true,
                        refreshFuncs: [
                          _controller.loadComplete,
                          _controller.loadFailed
                        ],

                        /// Don't show loading on Load
                        isRefresh: false,
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

  void getMovies({
    bool append = false,
    List<void Function()>? refreshFuncs,
    bool isRefresh = true,
  }) async {
    isMovieFuncRunning = true;
    try {
      /// Smart Refresher Child is a loading widget before fetching movies
      /// Only done on refresh not load (Using isRefresh switch)
      if (isRefresh) {
        setState(() {
          smartRefresherChild = Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingFour(
                    color: Theme.of(context).accentColor,
                    size: 60,
                  ),
                  SizedBox(
                    height: 56,
                  ),
                ],
              ),
            ),
          );
        });
      }

      dynamic x = await widget.movieFunc!();

      setState(() {
        if (append) {
          moviesList.addAll(x);
        } else {
          moviesList = x;
        }
      });

      /// If no results found show custom error msg (search specific)
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

      /// Success sent from controller
      if (refreshFuncs != null) refreshFuncs[0]();

      /// Smart Refresher Child is moviesGridView
      setState(() {
        smartRefresherChild = movieGridView(
          context,
          moviesList,
          crossAxisCount: _currentSliderValue.toInt(),
        );
      });
    } catch (e) {
      /// Fail sent from controller
      if (refreshFuncs != null) refreshFuncs[1]();

      setState(() {
        moviesList = append ? moviesList : [];
      });

      /// Error msg on Internet or TMDB errors
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => MsgBox(
      //     title: 'Error Caught',
      //     content: e.toString(),
      //   ),
      // );
      connectionErrorMsg(context);
    }
    isMovieFuncRunning = false;
  }

  Widget TileSizeSlider() {
    /// Slider to change
    return Slider(
      value: _currentSliderValue,
      min: 1,
      max: 5,
      divisions: 4,
      label: _currentSliderValue.toInt().toString(),
      onChangeEnd: (double value) {
        if (!isMovieFuncRunning) {
          setState(() {
            smartRefresherChild = movieGridView(
              context,
              moviesList,
              crossAxisCount: _currentSliderValue.toInt(),
            );
          });
        }
      },
      onChanged: (double value) {
        setState(() {
          if (!isMovieFuncRunning) {
            _currentSliderValue = value;
          }
        });
      },
    );
  }
}
