import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/bottom_pages/inside_home_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';
import 'package:wovie/widgets/genre_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TMDB tmdb = TMDB();
  RefreshController _controller = RefreshController(initialRefresh: false);
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userSearch = TextEditingController();
  String searchText = '';
  bool isSearchButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    tmdb.resetPages();
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
                            hintStyle: TextStyle(fontSize: screenWidth / 22),
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
                                tmdb.searchQuery = _userSearch.value.text;
                                navPushTo(
                                  context,
                                  MoreMoviesScreen(
                                    title: 'Search Results',
                                    movieFunc: () => tmdb.getMoviesSearch(),
                                    addMoviesWordAtTheEnd: false,
                                    customErrorMsg:
                                        'No results found for: "${tmdb.searchQuery}"',
                                  ),
                                );
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
                      child: InsideHomeScreen(),
                      onLoading: () {
                        setState(() {});
                        _controller.refreshCompleted();
                      },
                      onRefresh: () {
                        navPushRepTo(
                          context,
                          MainScreen(),
                          noAnimation: true,
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
