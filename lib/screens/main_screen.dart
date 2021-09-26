import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/controllers/database_realtime_controller.dart';
import 'package:wovie/database/db_helper.dart';
import 'package:wovie/screens/bottom_pages/favourite_or_watchlist_screen.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/screens/settings_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/msg_box.dart';
import 'bottom_pages/home_screen.dart';
import 'package:wovie/widgets/anim_search_bar/anim_search_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curIndex = 1;
  final MovieListController movieListController =
      Get.put(MovieListController());
  PageController _pageController = PageController(initialPage: 1);
  TextEditingController _userSearch = TextEditingController();
  bool isSearchFocused = false;
  bool isSearchButtonPressed = false;
  double searchBoxWidth = 300;
  TMDB tmdb = TMDB();

  Future<bool> fetchSqlMovies() async {
    movieListController.favMoviesList.value =
        await DbHelper().getAllMovies('fav');
    movieListController.watMoviesList.value =
        await DbHelper().getAllMovies('wat');
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchSqlMovies();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String iconType =
        'images/icon_letter_${Get.isDarkMode ? "dark" : "light"}.png';
    return GestureDetector(
      onTap: () {
        unfocusKeyboard();
      },
      child: FocusScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Container(
              child: Row(
                children: [
                  Hero(
                    tag: 'wovie',
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(iconType),
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  Text(
                    'ovie',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: screenWidth / 10,
                        ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        isSearchFocused = focus;
                      });
                    },
                    child: AnimSearchBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).shadowColor,
                      helpText: 'Search for a movie',
                      fontSize: screenWidth / 20,
                      width: screenWidth / 1.2,
                      textController: _userSearch,
                      onSubmitted: (_) => onSearchPressed(),
                      onSuffixTap: () {
                        setState(() {
                          _userSearch.clear();
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            Get.to(() => SettingsScreen());
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 0.5,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: BottomNavigationBar(
              onTap: (index) => _onItemTapped(index),
              currentIndex: curIndex,
              items: [
                BottomNavigationBarItem(
                  label: 'Watchlist',
                  icon: Obx(
                    () => Badge(
                      showBadge:
                          movieListController.watListUnique.value.length != 0,
                      badgeContent: Text(
                        movieListController.watListUnique.value.length
                            .toString(),
                      ),
                      child: Icon(Icons.bookmark),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Favourites',
                  icon: Obx(
                    () => Badge(
                      showBadge:
                          movieListController.favListUnique.value.length != 0,
                      badgeContent: Text(
                        movieListController.favListUnique.value.length
                            .toString(),
                      ),
                      child: Icon(Icons.favorite),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                curIndex = index;
              });
            },
            children: [
              FavOrWatchScreen(
                screenType: 'watch',
                screenTitle: 'Watchlist',
                screenBackgroundIcon: Icons.bookmark,
              ),
              HomeScreen(),
              FavOrWatchScreen(
                screenType: 'fav',
                screenTitle: 'Favourites',
                screenBackgroundIcon: Icons.favorite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    /// Clear badges counters when user opens any of fav or wat
    if ([0, 2].contains(index)) {
      movieListController.clearCounter(index == 0 ? 'wat' : 'fav');
    }

    setState(() {
      curIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    });
  }

  void onSearchPressed() {
    isSearchButtonPressed = true;
    if (_userSearch.value.text == '') {
      isSearchButtonPressed = false;
      showDialog(
        context: context,
        builder: (BuildContext context) => MsgBox(
          title: 'Hey There',
          content: 'Search can not be empty!',
        ),
      );
      return;
    }
    unfocusKeyboard();
    tmdb.searchQuery = _userSearch.value.text;
    navPushTo(
      context,
      MoreMoviesScreen(
        title: 'Search Results',
        movieFunc: () => tmdb.getMoviesSearch(),
        addMoviesWordAtTheEnd: false,
        customErrorMsg: 'No results found for: "${tmdb.searchQuery}"',
      ),
    );
    isSearchButtonPressed = false;
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
