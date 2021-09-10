import 'package:flutter/material.dart';
import 'bottom_pages/favourites_screen.dart';
import 'bottom_pages/home_screen.dart';
import 'bottom_pages/watchlist_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({this.apiKey});
  final String? apiKey;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curIndex = 1;
  PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onItemTapped(index),
        currentIndex: curIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Watchlist',
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favourites',
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => curIndex = index);
        },
        children: [
          WatchlistScreen(),
          HomeScreen(apiKey: widget.apiKey),
          FavouritesScreen(),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      curIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
