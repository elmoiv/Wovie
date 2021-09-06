import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/model/movie.dart';
import '../../widgets/movie_grid_view.dart';
import 'package:wovie/widgets/msg_box.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.apiKey});
  String? apiKey;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TMDB? tmdb;
  List<Movie> homeMovieList = [];
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
    // TODO: resetPages is temp func to test, remove it later
    return Scaffold(
      body: SafeArea(
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
                        ErrorMsg(context, e);
                        _controller.loadFailed();
                        return;
                      }
                      setState(() {
                        homeMovieList.addAll(x);
                      });
                      _controller.loadComplete();
                    },
                    onRefresh: () async {
                      tmdb!.resetPages();
                      dynamic x = [];
                      try {
                        x = await tmdb!.getPopular();
                      } catch (e) {
                        ErrorMsg(context, e);
                        _controller.refreshFailed();
                        return;
                      }
                      setState(() {
                        homeMovieList = [];
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
