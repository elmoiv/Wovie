import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/bottom_pages/inside_home_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/screens/more_movie_screen.dart';
import 'package:wovie/screens/settings_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';

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
  bool isSearchFocused = false;
  bool isSearchButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    tmdb.resetPages();
    return Scaffold(
      body: FocusScope(
        child: SafeArea(
          /// wrapping all home in a Gesture detector to be able
          /// to un-focus TextField when clicking anywhere else
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 30,
                        child: Focus(
                          onFocusChange: (focus) {
                            setState(() {
                              isSearchFocused = focus;
                            });
                          },
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 5.0, 10.0),
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).accentColor,
                                    style: TextStyle(
                                      color: Theme.of(context).shadowColor,
                                      fontWeight: FontWeight.normal,
                                    ),
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
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            fontSize: screenWidth / 22,
                                            color: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.normal,
                                          ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: isSearchFocused
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context)
                                                  .shadowColor
                                                  .withOpacity(0.6),
                                        ),
                                        splashRadius: 30,
                                        onPressed: () {
                                          isSearchButtonPressed = true;
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            isSearchButtonPressed = false;
                                            return;
                                          }
                                          tmdb.searchQuery =
                                              _userSearch.value.text;
                                          navPushTo(
                                            context,
                                            MoreMoviesScreen(
                                              title: 'Search Results',
                                              movieFunc: () =>
                                                  tmdb.getMoviesSearch(),
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
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.6),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context).accentColor,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .shadowColor
                                              .withOpacity(0.6),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: IconButton(
                                splashRadius: 30,
                                onPressed: () {
                                  Get.to(() => SettingsScreen());
                                },
                                icon: Icon(
                                  Icons.settings,
                                  size: 30,
                                  color: Theme.of(context).shadowColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SmartRefresher(
                        controller: _controller,
                        header: MaterialClassicHeader(
                          color: Colors.white,
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        physics: ClampingScrollPhysics(),
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
      ),
    );
  }
}
