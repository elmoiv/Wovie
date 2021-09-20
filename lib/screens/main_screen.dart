import 'package:flutter/material.dart';
import 'package:wovie/screens/bottom_pages/favourite_or_watchlist_screen.dart';
import 'bottom_pages/home_screen.dart';

class MainScreen extends StatefulWidget {
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.75))
          ],
        ),
        child: BottomNavigationBar(
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
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => curIndex = index);
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      curIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    });
  }
}
