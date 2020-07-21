import 'package:MicroBlogger/Composers/commentComposer.dart';
import 'package:MicroBlogger/Composers/reshareComposer.dart';
import 'package:MicroBlogger/Screens/profilepage.dart';
import 'package:flutter/material.dart';
import '../../Data/datafetcher.dart';
import 'dart:convert';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(author);
    // print(prettyprint);
    final currentUser = getCurrentUser();
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
            Navigator.of(context).pushNamed('/HomePage');
            break;
          case 1:
            Navigator.of(context).pushNamed('/Explore');
            break;
          case 2:
            Navigator.of(context).pushNamed('/Notifications');
            break;
          case 3:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          author: currentUser,
                        )));
            break;
        }
      },
    );
  }
}

class MainAppDrawer extends StatelessWidget {
  final author;
  const MainAppDrawer({Key key, this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black54,
        child: new ListView(
          children: <Widget>[
            new SizedBox(
              height: 270.0,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("${author['icon']}")),
                accountName: Text("${author['name']}",
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                accountEmail: Text("${author['email']}"),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("${author['background']}")
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
              onTap: () => Navigator.of(context).pushNamed('/Settings'),
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
              onTap: () => Navigator.of(context).pushNamed('/Trending'),
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
              print('Clicked Wiki Entry');
            }),
            // ActionButton('ChatRoom', Icons.device_hub, () {
            //   print('Clicked ChatRoom');
            // }),
            // ActionButton('Ask Question', Icons.question_answer, () {
            //   print('Clicked QA');
            // }),
            // ActionButton('All Drafts', Icons.drafts, () {
            //   print('Clicked Drafts');
            // }),
          ],
        );
      }),
    );
  }
}

// [['Image', 'Link', 'Function'], ['Image', 'Link', 'Function'], ['Image', 'Link', 'Function']]

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
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );
  }
}

class ActionBar extends StatefulWidget {
  final post;
  ActionBar({Key key, this.post}) : super(key: key);

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  var currentUser = getCurrentUser();
  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;
  String commentText = "";

  int likeCounter = 0;
  int commentCounter = 0;
  int reshareCounter = 0;

  autoEnableActions() {
    //auto enable bookmark if user has bookmarked it.
    for (var id in currentUser['bookmarkedPosts']) {
      if (id == widget.post['id']) {
        _bookmarked = true;
        break;
      }
    }

    //auto enable liked if user has liked it.
    for (var id in currentUser['likedPosts']) {
      if (id == widget.post['id']) {
        _liked = true;
        break;
      }
    }

    //auto enable reshare light if user has reshared it (MIGHT NEED IMMEDIATE CHANGE)
    var rwc = [], sr = [];
    currentUser['myReshareWithComments'].forEach((e) {
      rwc.add(e['child']['id']);
    });
    currentUser['mySimpleReshares'].forEach((e) {
      sr.add(e['child']['id']);
    });
    for (var id in [...rwc, ...sr]) {
      if (id == widget.post['id']) {
        _reshared = true;
        break;
      }
    }
  }

  toggleLike() {
    if (_liked) {
      //TODO: Unlike to server
    } else {
      //TODO: like to server
    }
    setState(() {
      _liked = !_liked;
      likeCounter = (!_liked) ? --likeCounter : ++likeCounter;
    });
    print("${(_liked) ? "L" : "Unl"}iked Post ID: ${widget.post['id']}");
  }

  toggleReshare() {
    if (_reshared) {
      //TODO: Initiate UnReshareSequence from server
      print(
          "Initiating UnReshare Seequence for both SimpleReshares and ReshareWithComments for this post by currentUser (${currentUser['username']})");
      setState(() {
        _reshared = !_reshared;
        reshareCounter = (!_reshared) ? --reshareCounter : ++reshareCounter;
      });
      return;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          RaisedButton(
              onPressed: () {
                //TODO: Initate a SimpleReshare sequence from server
                print(
                    "Initiated Simple Reshare for this post by currentUser (${currentUser['username']})");
                setState(() {
                  _reshared = !_reshared;
                  reshareCounter =
                      (!_reshared) ? --reshareCounter : ++reshareCounter;
                });
              },
              color: Colors.white10,
              child: Text("Reshare", style: TextStyle(color: Colors.white))),
          SizedBox(
            width: 5.0,
          ),
          RaisedButton(
            onPressed: () {
              print(
                  "Initiated Simple Reshare for this post by currentUser (${currentUser['username']})");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReshareComposer(
                            postObject: widget.post,
                          )));
              setState(() {
                _reshared = !_reshared;
                reshareCounter =
                    (!_reshared) ? --reshareCounter : ++reshareCounter;
              });
            },
            color: Colors.white10,
            child: Text("Reshare with Comment",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    ));
  }

  addComment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentComposer(
                  post: widget.post,
                )));
    print("Commented on Post ID: ${widget.post['id']}");
  }

  toggleBookmark() {
    if (_bookmarked) {
      //TODO: Initate unBookmark sequence
    }
    setState(() {
      _bookmarked = !_bookmarked;
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        (_bookmarked) ? "Added To Bookmarks" : "Removed from Bookmarks",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 1),
    ));
    print(
        " ${(!_bookmarked) ? "Un" : ""}Bookmarked Post ID: ${widget.post['id']}");
  }

  @override
  void initState() {
    likeCounter = widget.post['likes'];
    commentCounter = (widget.post.containsKey('comments'))
        ? widget.post['comments'].length
        : 0;
    reshareCounter = widget.post['reshares'];

    autoEnableActions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5.0),
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border(
                left: BorderSide(width: 1.0, color: Colors.white12),
                right: BorderSide(width: 1.0, color: Colors.white12),
                bottom: BorderSide(width: 1.0, color: Colors.white12))),
        height: 35.0,
        child: Row(
          children: [
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon:
                        Icon((_liked) ? Icons.favorite : Icons.favorite_border),
                    color: (_liked) ? Colors.pink : null,
                    onPressed: () {
                      toggleLike();
                    }),
                Text(
                  "${likeCounter.toString()}",
                  style: TextStyle(color: Colors.white60),
                )
              ],
            ),
            //comment
            if (widget.post['type'] != "poll" &&
                widget.post['type'] != "ResharedWithComment") ...[
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.only(bottom: 2.0),
                      icon: Icon((_reshared) ? Icons.repeat : Icons.repeat),
                      color: (_reshared) ? Colors.green : null,
                      onPressed: () {
                        toggleReshare();
                      }),
                  Text(
                    "${reshareCounter.toString()}",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
            ],
            if (widget.post['type'] != "poll" &&
                widget.post['type'] != "shareable") ...[
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      addComment();
                    },
                  ),
                  Text(
                    "${commentCounter.toString()}",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
            ],
            if (widget.post['type'] != "poll") ...[
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(
                        (_bookmarked) ? Icons.bookmark : Icons.bookmark_border),
                    color: (_bookmarked) ? Colors.green : null,
                    onPressed: () {
                      toggleBookmark();
                    },
                  )
                ],
              ),
            ],
          ],
        ));
  }
}

class TopBar extends StatelessWidget {
  final postObject;
  const TopBar({Key key, this.postObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            print(postObject['author']['username']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          username: postObject['author']['username'],
                        )));
          },
          child: CircleAvatar(
            radius: 24.0,
            backgroundImage: NetworkImage("${postObject['author']['icon']}"),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${postObject['author']['name']}",
                style: TextStyle(fontSize: 20.0),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  username: postObject['author']['username'],
                                ))),
                    child: Text(
                      "@${postObject['author']['username']}",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${postObject['age']}",
                    style: TextStyle(color: Colors.white30),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (postObject['type'] == 'microblog' ||
                      postObject['type'] == 'ResharedWithComment' ||
                      postObject['type'] == 'comment') ...[
                    Text(
                      "${postObject['category']}",
                      style: TextStyle(
                          color: (postObject['category'] == 'Fact')
                              ? Colors.green
                              : Colors.pink),
                    ),
                  ],
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () => print("More clicked"),
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
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
