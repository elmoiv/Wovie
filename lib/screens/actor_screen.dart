import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/constants.dart';
import 'package:wovie/model/actor.dart';
import 'package:wovie/model/movie.dart';
import '../utils/readmore.dart';
import 'package:wovie/widgets/msg_box.dart';
import 'package:wovie/widgets/movie_list_horizontal.dart';

class ActorScreen extends StatefulWidget {
  final Actor? actor;
  final TMDB? tmdb;
  ActorScreen({this.actor, this.tmdb});

  @override
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  @override
  Widget build(BuildContext context) {
    Actor actor = widget.actor!;
    TMDB tmdb = widget.tmdb!;

    Future<Actor> getActor() async {
      try {
        return await tmdb.getActor(actor.actorId!);
      } catch (e) {
        ErrorMsg(context, e);
        return Actor();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Actor>(
            future: getActor(),
            builder: (context, AsyncSnapshot<Actor> snapshot) {
              if (snapshot.hasData && snapshot.data!.actorId != null) {
                return actorPage(context, snapshot.data!, tmdb);
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child:
                        SpinKitFadingFour(color: kMaterialBlueColor, size: 60),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget actorPage(context, Actor actor, TMDB tmdb) {
  return Container(
    child: Column(
      children: [
        Stack(
          children: [
            Center(
              child: OptimizedCacheImage(
                fadeOutDuration: Duration(milliseconds: 300),
                imageUrl: actor.actorPhoto!,
                placeholder: (context, url) => cachedActorPlaceholder(context),
                errorWidget: (context, url, error) =>
                    cachedActorPlaceholder(context),
                imageBuilder: (context, imageProvider) =>
                    cachedActorRealImage(context, imageProvider),
              ),
            ),
            gradientUnderImage(context),
            nameOnRealImage(context, actor),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        detailsSection(
          title: 'Birth Info',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: birthDetails(context,
                dateOfBirth: actor.actorBirthday!,
                placeOfBirth: actor.actorBirthplace!),
          ),
          verticalPadding: 15,
        ),
        detailsSection(
          title: 'Biography',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ReadMoreText(
              '${actor.actorBiography}',
              trimLines: 10,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              lessStyle: TextStyle(
                fontSize: 18,
                color: kMaterialBlueColor,
                fontWeight: FontWeight.bold,
              ),
              moreStyle: TextStyle(
                fontSize: 18,
                color: kMaterialBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          verticalPadding: 15,
        ),
        detailsSection(
          title: 'Known For',
          child: FutureBuilder<List<Movie>>(
            future: tmdb.getActorMovies(actor.actorId!),
            builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return movieHorizontalListView(context, snapshot.data!, tmdb);
              } else {
                return SpinKitThreeBounce(color: kMaterialBlueColor, size: 40);
              }
            },
          ),
          verticalPadding: 15,
        ),
      ],
    ),
  );
}

Widget detailsSection({String? title, dynamic child, double? verticalPadding}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            '| ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xfffb6a17),
            ),
          ),
          Text(
            title!,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      child!,
      SizedBox(
        height: verticalPadding!,
      )
    ],
  );
}

Widget birthDetails(context,
    {String dateOfBirth = '', String placeOfBirth = ''}) {
  double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: width / 3.2,
            child: Text(
              'Birth Day:',
              style: kGrayInfoTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            dateOfBirth,
            style: kGrayInfoTextStyle,
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
              style: kGrayInfoTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              placeOfBirth,
              style: kGrayInfoTextStyle,
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
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 3.1,
            blurRadius: 7.5,
            offset: Offset(0, 10), // changes position of shadow
          )
        ]),
  );
}

Widget nameOnRealImage(context, Actor actor) {
  double height = MediaQuery.of(context).size.height;
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
                fontSize: height / 25,
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
