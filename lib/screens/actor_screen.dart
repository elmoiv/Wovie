import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/models/actor.dart';
import 'package:wovie/models/movie.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/widgets/details_section.dart';
import 'package:wovie/widgets/overscroll_color.dart';
import 'package:wovie/widgets/stack_icon_button.dart';
import '../utils/readmore.dart';
import 'package:wovie/widgets/msg_box.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';

class ActorScreen extends StatefulWidget {
  final Actor? actor;
  ActorScreen({this.actor});

  @override
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  @override
  Widget build(BuildContext context) {
    Actor actor = widget.actor!;
    TMDB tmdb = TMDB();

    Future<Actor> getActor() async {
      try {
        return await tmdb.getActor(actor.actorId!);
      } catch (e) {
        errorMsg(context, e);
        return Actor();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: OverScrollColor(
          direction: AxisDirection.down,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: FutureBuilder<Actor>(
              future: getActor(),
              builder: (context, AsyncSnapshot<Actor> snapshot) {
                if (snapshot.hasData && snapshot.data!.actorId != null) {
                  return actorPage(context, snapshot.data!);
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: SpinKitFadingFour(
                          color: Theme.of(context).accentColor, size: 60),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget actorPage(context, Actor actor) {
  double screenWidth = MediaQuery.of(context).size.width;
  TMDB tmdb = TMDB();
  return Container(
    child: Column(
      children: [
        Stack(
          children: [
            /// Actor Picture
            Center(
              child: OptimizedCacheImage(
                fadeInDuration: Duration(milliseconds: 300),
                fadeOutDuration: Duration(milliseconds: 300),
                imageUrl: actor.actorPhoto!,
                placeholder: (context, url) => cachedActorPlaceholder(context),
                errorWidget: (context, url, error) =>
                    cachedActorPlaceholder(context),
                imageBuilder: (context, imageProvider) =>
                    cachedActorRealImage(context, imageProvider),
              ),
            ),

            /// Gradient over for the name
            gradientUnderImage(context),

            /// Actor Name
            nameOnRealImage(context, actor),

            /// Shadow behind icon
            Container(
              width: double.infinity,
              height: screenWidth / 3.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.0)
                  ],
                  stops: [0.0, 0.8],
                ),
              ),
            ),

            /// Back Arrow Stack Icon Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StackIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                StackIconButton(
                  icon: Icons.home_outlined,
                  onPressed: () {
                    Get.offAll(() => MainScreen());
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),

        /// Birth Info
        DetailsSection(
          title: 'Birth Info',
          titleSize: screenWidth / 15,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: birthDetails(context,
                dateOfBirth: actor.actorBirthday!,
                placeOfBirth: actor.actorBirthplace!),
          ),
          verticalPadding: 15,
        ),

        /// Actor Bio
        DetailsSection(
          title: 'Biography',
          titleSize: screenWidth / 15,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ReadMoreText(
              '${actor.actorBiography}',
              trimLines: 10,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: TextStyle(
                fontSize: screenWidth / 20,
                color: Theme.of(context).shadowColor.withOpacity(0.5),
              ),
              lessStyle: Theme.of(context).textTheme.headline3!.copyWith(
                    fontSize: screenWidth / 20,
                  ),
              moreStyle: Theme.of(context).textTheme.headline3!.copyWith(
                    fontSize: screenWidth / 20,
                  ),
            ),
          ),
          verticalPadding: 15,
        ),

        /// Actor Movies
        DetailsSection(
          title: 'Known For',
          titleSize: screenWidth / 15,
          child: FutureBuilder<List<Movie>>(
            future: tmdb.getActorMovies(actor.actorId!),
            builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return movieHorizontalListView(context, snapshot.data!);
              } else {
                return SpinKitThreeBounce(
                    color: Theme.of(context).accentColor, size: 40);
              }
            },
          ),
          verticalPadding: 15,
        ),
      ],
    ),
  );
}

Widget birthDetails(context,
    {String dateOfBirth = '', String placeOfBirth = ''}) {
  double width = MediaQuery.of(context).size.width;
  TextStyle infoTextStyle = Theme.of(context).textTheme.headline2!;
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: width / 3.2,
            child: Text(
              'Birth Day:',
              style: infoTextStyle.copyWith(
                fontSize: width / 20,
                color: Theme.of(context).shadowColor.withOpacity(0.5),
              ),
            ),
          ),
          Text(
            dateOfBirth,
            style: infoTextStyle.copyWith(
              fontSize: width / 20,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).shadowColor.withOpacity(0.5),
            ),
          )
        ],
      ),
      SizedBox(height: 4),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width / 3.2,
            child: Text(
              'Place of birth:',
              style: infoTextStyle.copyWith(
                fontSize: width / 20,
                color: Theme.of(context).shadowColor.withOpacity(0.5),
              ),
            ),
          ),
          Flexible(
            child: Text(
              placeOfBirth,
              style: infoTextStyle.copyWith(
                fontSize: width / 20,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).shadowColor.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
    ],
  );
}

Widget cachedActorRealImage(context, imageProvider) {
  double height = MediaQuery.of(context).size.height;
  return Container(
    height: height * (5 / 9),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3.1,
            blurRadius: 30.5,
            offset: Offset(0, 10), // changes position of shadow
          )
        ]),
  );
}

Widget nameOnRealImage(context, Actor actor) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: height * (5 / 9),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '${actor.actorName}',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                color: Colors.white,
                fontSize: width / 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Widget gradientUnderImage(context) {
  double height = MediaQuery.of(context).size.height;
  return Container(
    height: height * (5 / 9),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.black.withOpacity(0.85),
          Colors.black.withOpacity(0.0),
        ],
        stops: [0.0, 0.4],
      ),
    ),
  );
}

Widget cachedActorPlaceholder(context) {
  double height = MediaQuery.of(context).size.height;
  return Container(
    height: height * (5 / 9),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
    ),
    child: Center(
      child: Icon(
        Icons.person_rounded,
        size: MediaQuery.of(context).size.width / 3,
      ),
    ),
  );
}
