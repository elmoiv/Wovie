import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/bottom_pages/inside_home_screen.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/utils/easy_navigator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TMDB tmdb = TMDB();
  RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    tmdb.resetPages();
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SmartRefresher(
          controller: _controller,
          header: MaterialClassicHeader(
            color: Colors.white,
            backgroundColor: Theme.of(context).accentColor,
          ),
          physics: ScrollPhysics(),
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
    );
  }
}
