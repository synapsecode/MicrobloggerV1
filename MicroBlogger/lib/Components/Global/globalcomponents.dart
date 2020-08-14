import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Screens/editprofile.dart';
import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:MicroBlogger/Screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Backend/datastore.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
        // BottomNavigationBarItem(icon: Icon(Icons.trending_up), title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity), title: Text('')),
      ],
      selectedItemColor: Colors.white,
      backgroundColor: Colors.black87,
      unselectedItemColor: Colors.white,
      onTap: (int x) {
        switch (x) {
          case 0:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            break;
          case 1:
            Navigator.of(context).pushNamed('/Explore');
            break;
          case 2:
            Fluttertoast.showToast(
                msg: "Feature Coming Soon!",
                backgroundColor: Color.fromARGB(200, 220, 20, 60));
            Navigator.of(context).pushNamed('/Notifications');
            break;
          case 3:
            Navigator.pushNamed(context, '/ProfilePage');
            break;
        }
      },
    );
  }
}

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = currentUser['user'];
    return Drawer(
      child: Container(
        color: Colors.black54,
        child: new ListView(
          children: <Widget>[
            new SizedBox(
              height: 270.0,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: InkWell(
                  onTap: () {
                    // print(postObject['author']['username']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  user['username'],
                                )));
                  },
                  child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage("${user['icon']}")),
                ),
                accountName: Text("${user['name']}",
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                accountEmail: Text("${user['email']}"),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("${user['background']}")
                        //NetworkImage('https://www.wallpaperup.com/uploads/wallpapers/2015/01/29/604388/cff1fdb8cae21be0110304941e33130d-700.jpg')
                        )),
              ),
            ),
            new ListTile(
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () => Fluttertoast.showToast(
                  msg: "Feature Coming Soon!",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60)),
            ),
            new ListTile(
              title: Text(
                "Bookmarks",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onTap: () => Navigator.of(context).pushNamed('/Bookmarks'),
            ),
            new ListTile(
              title: Text(
                "Trending",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.trending_up,
                color: Colors.white,
              ),
              onTap: () => Fluttertoast.showToast(
                  msg: "Feature Coming Soon!",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60)),
            ),
            new ListTile(
              title: Text(
                "News",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.wifi,
                color: Colors.white,
              ),
              onTap: () => Navigator.of(context).pushNamed('/NewsFeed'),
            ),
            new ListTile(
              onTap: () => Navigator.of(context).pushNamed('/About'),
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
            ),
            new ListTile(
              onTap: () => showDialog(
                  builder: (context) {
                    return BugReporterDialog();
                  },
                  context: context),
              title: Text(
                "Report Bug",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.report,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String actionText;
  final icon;
  final Function event;

  //Constructor
  ActionButton(this.actionText, this.icon, this.event);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: Colors.white10,
          foregroundColor: Colors.white,
          child: Icon(icon),
          onPressed: event,
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        Text(actionText)
      ],
    );
  }
}

class AddOptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      color: Colors.black,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            ActionButton('MicroBlog', Icons.image, () {
              Navigator.of(context).pushNamed('/MicroBlogComposer');
            }),
            ActionButton('Shareable', Icons.link, () {
              Navigator.of(context).pushNamed('/ShareableComposer');
            }),
            ActionButton('Blog', Icons.create, () {
              Navigator.of(context).pushNamed('/BlogComposer');
            }),
            ActionButton('Poll', Icons.poll, () {
              Navigator.of(context).pushNamed('/PollComposer');
            }),
            ActionButton('Timeline', Icons.check_box, () {
              Navigator.of(context).pushNamed('/TimelineComposer');
            }),
            ActionButton('Media', Icons.devices, () {
              Fluttertoast.showToast(
                msg: "Feature Coming Soon!",
                backgroundColor: Color.fromARGB(200, 220, 20, 60),
              );
            }),
          ],
        );
      }),
    );
  }
}

class FloatingCircleButton extends StatefulWidget {
  @override
  _FloatingCircleButtonState createState() => new _FloatingCircleButtonState();
}

class _FloatingCircleButtonState extends State<FloatingCircleButton> {
  void openActionSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return AddOptionsWidget();
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: openActionSheet,
      child: new Icon(Icons.add),
      tooltip: "Create Content",
      backgroundColor: Color.fromARGB(200, 220, 20, 60),
      foregroundColor: Colors.white,
    );
  }
}

class CirclularLoader extends StatelessWidget {
  const CirclularLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Color.fromARGB(200, 220, 20, 60),
            )
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Widget child;
  const ErrorPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg"),
              fit: BoxFit.cover)),
      child: child,
    );
  }
}

class BugReporterDialog extends StatefulWidget {
  const BugReporterDialog({
    Key key,
  }) : super(key: key);

  @override
  _BugReporterDialogState createState() => _BugReporterDialogState();
}

class _BugReporterDialogState extends State<BugReporterDialog> {
  String description = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Color.fromARGB(230, 220, 20, 60),
          content: Column(
            children: [
              Text(
                  "MicroBlogger is in its early stages! There will be several bugs in the Platform. Please describe the bug or inconsistency that you found! If possible, please add your contact information so that we can discuss the issue elaborately! Thank you for your time!"),
              SizedBox(
                height: 15.0,
              ),
              Container(
                color: Colors.black38,
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  maxLength: 1000,
                  onChanged: (x) {
                    setState(() {
                      description = x;
                    });
                  },
                ),
              ),
            ],
          ),
          title: Row(children: [
            Icon(
              Icons.report,
              color: Colors.white,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("Report a Bug")
          ]),
          actions: [
            FlatButton(
              child: Text("Report"),
              onPressed: () async {
                await reportBug(
                    currentUser['user']['username'] ?? 'defaultuser',
                    description);
                Fluttertoast.showToast(
                  msg: "The bug was reported! Thank You",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
