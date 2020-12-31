import 'dart:async';
import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Templates/followsuggestions.dart';
import 'package:MicroBlogger/Components/Templates/nativeVideoPlayer.dart';
import 'package:MicroBlogger/Components/Templates/youtubePlayer.dart';
import 'package:MicroBlogger/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/datastore.dart';
import '../Components/Global/globalcomponents.dart';
import 'dart:developer';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import '../Components/Templates/postTemplates.dart';
import 'package:MicroBlogger/palette.dart';

import '../origin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode;

  @override
  void initState() {
    isDarkMode = (CurrentPalette == darkThemePalette);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkConnection(context);
    return Scaffold(
      // backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: !isDarkMode
            ? const Color(0xFFFFFFFF)
            : Theme.of(context).backgroundColor,
        brightness: !isDarkMode ? Brightness.light : Brightness.dark,
        iconTheme:
            IconThemeData(color: !isDarkMode ? Colors.black38 : Colors.white),
        actionsIconTheme:
            IconThemeData(color: !isDarkMode ? Colors.black38 : Colors.white),

        // backgroundColor: Theme.of(context).backgroundColor,
        // backgroundColor: Colors.black,
        title: Text(
          "Feed",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black45,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Logging Out",
                backgroundColor: Color.fromARGB(200, 220, 20, 60),
              );
              logoutSavedUser();
              Navigator.of(context).pushReplacementNamed('/Login');
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/HomePage');
            },
          ),
          IconButton(
            icon: Icon(
                isDarkMode ? Icons.nights_stay : Icons.nights_stay_outlined),
            onPressed: () {
              CurrentPalette =
                  isDarkMode ? lightThemePalette : darkThemePalette;
              CurrentTheme =
                  isDarkMode ? CustomLightThemeData : CustomDarkThemeData;
              saveTheme(isDarkMode ? "LIGHT" : "DARK");

              Origin.of(context).rebuild();
              // Origin.of(context).rebuild();
              print(
                  "$CurrentPalette, $CurrentTheme, ${Origin.of(context).isCurrentPaletteDarkTheme}");

              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          )
          // BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
          //   builder: (context, state) {
          //     return Padding(
          //       padding: EdgeInsets.only(top: 0),
          //       child: Switch(
          //           value: state.themeState.isLightMode,
          //           onChanged: (value) {
          //             BlocProvider.of<ThemeChangeBloc>(context)
          //                 .add(OnThemeChangedEvent(value));
          //             Phoenix.rebirth(context);
          //           }),
          //     );
          //   },
          // )
          // IconButton(
          //   icon: Icon(Icons.send),
          //   onPressed: () => Fluttertoast.showToast(
          //     msg: "Feature Coming Soon!",
          //     backgroundColor: Color.fromARGB(200, 220, 20, 60),
          //   ),
          // ),
        ],
      ),
      body: Feed(
        currentUser: (currentUser['username']),
      ),
      drawer: MainAppDrawer(),
      floatingActionButton: FloatingCircleButton(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

Widget feedBuilder(String postType, postData) {
  // print("FB : ${postType} ${postData}");
  Widget output;
  switch (postType) {
    case "storyfeed":
      output = StoriesHolder(postObject: postData);
      break;
    case "microblog":
      output = MicroBlogPost(postObject: postData);
      break;
    case "blog":
      output = BlogPost(postData);
      break;
    case "carousel":
      output = CarouselPost(postObject: postData);
      break;
    case "shareable":
      output = ShareablePost(postObject: postData);
      break;
    case "timeline":
      output = Timeline(postData);
      break;
    case "poll":
      output = PollPost(postObject: postData);
      break;
    case "ResharedWithComment":
      output = ReshareWithComment(
        postObject: postData,
      );
      break;
    case "SimpleReshare":
      output = SimpleReshare(
        postObject: postData,
      );
      break;
    case "FollowSuggestions":
      output = UserFollowSuggestions();
      break;
    case "YoutubeElement":
      output = YoutubeElement(postData);
      break;
    case "Video":
      output = VideoCarouselPost(
        postObject: postData,
      );
      break;
    default:
      break;
  }
  return output;
}

class Feed extends StatefulWidget {
  final currentUser;
  Feed({this.currentUser});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future feedData;
  @override
  void initState() {
    super.initState();
    feedData = getFeed();
  }

  bool first = true;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder fbdr = FutureBuilder(
    //   future: feedData,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       List feedList = snapshot.data;
    //       feedList = [...feedList];
    //       return Column(
    //         children: [
    //           StoriesHolder(),
    //           Text("ff"),
    //           SizedBox(
    //             height: 100.0,
    //           ),
    //           ListView.builder(
    //             shrinkWrap: true,
    //             itemCount: feedList.length,
    //             itemBuilder: (context, index) {
    //               return feedBuilder(feedList[index]['type'], [index]);
    //             },
    //           ),
    //         ],
    //       );
    //     } else {
    //       return CirclularLoader();
    //     }
    //   },
    // );

    CachedFutureBuilder cbdr = CachedFutureBuilder(
      future: feedData,
      cacheStore: GlobalFeedCache,
      onCacheUsed: (cache) {
        print("Using Cache");
        return ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: GlobalFeedCache.length,
          itemBuilder: (context, index) {
            return feedBuilder(
              GlobalFeedCache[index]['type'],
              GlobalFeedCache[index],
            );
          },
        );
      },
      onUpdate: (AsyncSnapshot snapshot) {
        GlobalFeedCache = [...snapshot.data];
        return ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return feedBuilder(
              snapshot.data[index]['type'],
              snapshot.data[index],
            );
          },
        );
      },
    );

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: cbdr,
      ),
    );
  }
}
