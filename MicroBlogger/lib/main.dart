import 'package:MicroBlogger/Composers/blogComposer.dart';
import 'package:MicroBlogger/Composers/microblogComposer.dart';
import 'package:MicroBlogger/Composers/pollComposer.dart';
import 'package:MicroBlogger/Composers/shareableComposer.dart';
import 'package:MicroBlogger/Composers/timelineComposer.dart';
import 'package:MicroBlogger/Screens/about.dart';
import 'package:MicroBlogger/Screens/bookmarks.dart';
import 'package:MicroBlogger/Screens/editprofile.dart';
import 'package:MicroBlogger/Screens/explorepage.dart';
import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:MicroBlogger/Screens/newsfeedpage.dart';
import 'package:MicroBlogger/Screens/notifications.dart';
import 'package:MicroBlogger/Screens/profile.dart';
import 'package:MicroBlogger/Screens/register.dart';
import 'package:MicroBlogger/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/login.dart';
import 'Backend/datastore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  //TODO: CHECK IF USER ALREADY LOGGED IN THROUGH SHARED PREFERENCES
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String user_id = "";
  Widget payload = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('assets/env.png')),
        SizedBox(
          height: 10.0,
        ),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          backgroundColor: Color.fromARGB(200, 220, 20, 60),
        )
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    String x = await loadSavedUsername();
    setState(() {
      if (x == "") {
        payload = LoginPage();
      }
      user_id = x;
    });
    print("\nMAINSCREEN: $user_id");
    setState(() {
      if (user_id.isNotEmpty) payload = HomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MicroBlogger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark),
        routes: <String, WidgetBuilder>{
          //General Screens
          '/About': (BuildContext context) => new AboutPage(),
          '/NewsFeed': (BuildContext context) => new NewsFeedPage(),
          '/Login': (BuildContext context) => new LoginPage(),
          '/Register': (BuildContext context) => new RegisterPage(),
          '/Settings': (BuildContext context) => new SettingsPage(),
          '/Explore': (BuildContext context) => new ExplorePage(),

          //User screens
          '/HomePage': (BuildContext context) => new HomePage(),
          '/ProfilePage': (BuildContext context) =>
              new ProfilePage(currentUser['user']['username']),
          '/Bookmarks': (BuildContext context) => new BookmarksPage(),
          '/EditProfile': (BuildContext context) => new EditProfilePage(),
          '/Notifications': (BuildContext context) => new NotificationsPage(),

          //Composers
          '/MicroBlogComposer': (BuildContext context) =>
              new MicroBlogComposer(),
          '/ShareableComposer': (BuildContext context) =>
              new ShareableComposer(),
          '/BlogComposer': (BuildContext context) => new BlogComposer(
                preExistingState: {'content': "", 'blogName': "", 'cover': ""},
              ),
          '/PollComposer': (BuildContext context) => new PollComposer(),
          '/TimelineComposer': (BuildContext context) => new TimelineComposer(
                preExistingState: {
                  'timelineTitle': "",
                  'events': [],
                  'cover': ""
                },
              ),
        },
        home: payload);
  }
}
