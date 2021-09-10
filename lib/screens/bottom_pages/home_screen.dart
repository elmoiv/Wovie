import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/genres_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/details_section.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/widgets/genre_tile.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';
import 'package:wovie/widgets/upcoming_movie_tile.dart';

class HomeScreen extends StatefulWidget {
  final String? apiKey;
  HomeScreen({this.apiKey});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TMDB? tmdb;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userSearch = TextEditingController();
  String searchText = '';
  bool isSearchButtonPressed = false;
  RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    tmdb = TMDB();
    tmdb!.API_KEY = widget.apiKey!;
    tmdb!.resetPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        /// wrapping all home in a Gesture detector to be able
        /// to un-focus TextField when clicking anywhere else
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Center(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                            searchText = value;
                          },
                          controller: _userSearch,
                          validator: (value) =>
                              value!.isEmpty && isSearchButtonPressed
                                  ? 'Text Required'
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'Search for a movie',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              splashRadius: 30,
                              onPressed: () {
                                isSearchButtonPressed = true;
                                if (!_formKey.currentState!.validate()) {
                                  isSearchButtonPressed = false;
                                  return;
                                }
                                // TODO: Implement Search Function
                                // Search function will be outside before build()
                                // It will check if search is empty show warning and do nothing
                                // If there is query, run search and show results
                                isSearchButtonPressed = false;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                width: 1,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SmartRefresher(
                      controller: _controller,
                      child: HomeMainScreen(tmdb: tmdb),
                      onLoading: () {
                        setState(() {});
                        _controller.refreshCompleted();
                      },
                      onRefresh: () {
                        navPushRepTo(
                          context,
                          MainScreen(
                            apiKey: tmdb!.API_KEY,
                          ),
                        );
                        _controller.refreshCompleted();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMainScreen extends StatefulWidget {
  final TMDB? tmdb;
  HomeMainScreen({this.tmdb});

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TMDB tmdb = widget.tmdb!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailsSection(
            title: 'Upcoming',
            titleSize: screenWidth / 15,
            verticalPadding: 20,
            child: FutureBuilder<List<Movie>>(
              future: tmdb.getUpcoming(),
              builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return upcomingMoviesSlider(context, snapshot.data!, tmdb);
                } else {
                  return SpinKitThreeBounce(
                      color: kMaterialBlueColor, size: 40);
                }
              },
            ),
          ),
          DetailsSection(
            title: 'Popular',
            titleSize: screenWidth / 15,
            verticalPadding: 20,
            viewMoreOnPressed: () =>
                navPushTo(context, MoreMoviesScreen(apiKey: tmdb.API_KEY)),
            child: FutureBuilder<List<Movie>>(
              future: tmdb.getPopular(),
              builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return movieHorizontalListView(
                    context,
                    snapshot.data!.take(10).toList(),
                    tmdb,
                  );
                } else {
                  return SpinKitThreeBounce(
                      color: kMaterialBlueColor, size: 40);
                }
              },
            ),
          ),
          DetailsSection(
            title: 'Genres',
            titleSize: screenWidth / 15,
            verticalPadding: 20,
            viewMoreOnPressed: () => navPushTo(context, GenresScreen()),
            child: Container(
              height: screenWidth * 0.2 * 2 + 8 * 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genreTile(context,
                          title: 'Fantasy', color: Colors.blueAccent),
                      genreTile(context,
                          title: 'Action', color: Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genreTile(context,
                          title: 'Romance', color: Colors.pinkAccent),
                      genreTile(context,
                          title: 'Drama', color: Colors.greenAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget upcomingMoviesSlider(context, List<Movie> movieList, TMDB tmdb) {
  tmdb.resetPages();
  double height = MediaQuery.of(context).size.height / 4;
  return Container(
    height: height,
    child: CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 500 / 281,
        viewportFraction: 0.9,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
      ),
      items: movieList
          .take(10)
          .map(
            (e) => UpcomingMovieTile(
              movie: e,
              tmdb: tmdb,
            ),
          )
          .toList(),
    ),
  );
}
