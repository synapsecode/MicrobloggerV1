import 'package:MicroBlogger/Components/PostTemplates/shareable.dart';
import 'package:MicroBlogger/Composers/blogComposer.dart';
import 'package:MicroBlogger/Composers/microblogComposer.dart';
import 'package:MicroBlogger/Composers/pollComposer.dart';
import 'package:MicroBlogger/Composers/reshareComposer.dart';
import 'package:MicroBlogger/Composers/shareableComposer.dart';
import 'package:MicroBlogger/Composers/timelineComposer.dart';
import 'package:MicroBlogger/PostViewers/blogViewer.dart';
import 'package:MicroBlogger/PostViewers/timelineViewer.dart';
import 'package:MicroBlogger/Screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/login.dart';
import 'Screens/register.dart';
import 'Screens/homepage.dart';
import 'PostViewers/MicroBlogViewer.dart';

import 'Screens/about.dart';
import 'Screens/bookmarks.dart';
import 'Screens/directmessages.dart';
import 'Screens/explorepage.dart';
import 'Screens/newsfeedpage.dart';
import 'Screens/notificationpage.dart';
import 'Screens/profilepage.dart';
import 'Screens/settings.dart';
import 'Screens/trendingpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroBlogger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/Login': (BuildContext context) => new LoginPage(),
        '/Register': (BuildContext context) => new RegisterPage(),
        '/HomePage': (BuildContext context) => new HomePage(),
        '/About': (BuildContext context) => new AboutPage(),
        '/Bookmarks': (BuildContext context) => new BookmarksPage(),
        '/DM': (BuildContext context) => new DirectMessagePage(),
        '/Explore': (BuildContext context) => new ExplorePage(),
        '/NewsFeed': (BuildContext context) => new NewsFeedPage(),
        '/Notifications': (BuildContext context) => new NotificationsPage(),
        '/Profile': (BuildContext context) => new ProfilePage(),
        '/Settings': (BuildContext context) => new SettingsPage(),
        '/Trending': (BuildContext context) => new TrendingPage(),
        '/Chat': (BuildContext context) => new ChatScreen(),

        //Composers
        '/MicroBlogComposer': (BuildContext context) => new MicroBlogComposer(),
        '/ShareableComposer': (BuildContext context) => new ShareableComposer(),
        '/BlogComposer': (BuildContext context) => new BlogComposer(),
        '/PollComposer': (BuildContext context) => new PollComposer(),
        '/TimelineComposer': (BuildContext context) => new TimelineComposer(),

        '/MB_ReshareComposer': (BuildContext context) =>
            new MicroBlogReshareComposer(),

        //Viewers
        '/MicroBlogViewer': (BuildContext context) => new MicroBlogViewer(),
        '/ReshareViewer': (BuildContext context) => new MicroBlogViewer(),
        '/BlogViewer': (BuildContext context) => new BlogViewer(),
        '/TimelineViewer': (BuildContext context) => new TimelineViewer(),
      },
    );
  }
}
