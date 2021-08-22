import 'dart:io';
import 'package:microblogger/Screens/hashtaglistviewer.dart';
import 'package:microblogger/Screens/hashtagpostviewer.dart';
import 'package:microblogger/globals.dart';
import 'package:microblogger/palette.dart';
import 'package:microblogger/Backend/server.dart';
import 'package:microblogger/Screens/homepage.dart';
import 'package:microblogger/Screens/profile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../../Backend/datastore.dart';

class PlatformCodeRunner extends StatelessWidget {
  final Function web;
  final Function android;
  final Function iOS;
  final Function windows;
  final Function macOS;
  final Function linux;
  final Function fuchsia;
  const PlatformCodeRunner(
      {Key key,
      this.web,
      this.android,
      this.iOS,
      this.windows,
      this.macOS,
      this.linux,
      this.fuchsia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (web != null) return web();
    } else {
      if (Platform.isWindows && windows != null) return windows();
      if (Platform.isMacOS && macOS != null) return macOS();
      if (Platform.isAndroid && android != null) return android();
      if (Platform.isIOS && android != null) return iOS();
      if (Platform.isLinux && linux != null) return linux();
      if (Platform.isFuchsia && fuchsia != null) return fuchsia();
      return Container();
    }
    return Container();
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    this.imagesSrcList,
  });

  final List imagesSrcList;

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentImageIndex = 0;
  int cx = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    //Prevent Carousel Error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cx == 0) setState(() => cx = 1);
    });
    return Column(children: [
      Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.white30, width: 0.1)),
        child: CarouselSlider(
          aspectRatio: 1 / 1,
          initialPage: 0,
          //enlargeCenterPage: true,
          viewportFraction: 1.1,
          height: 300,
          reverse: false,
          enableInfiniteScroll: false,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              currentImageIndex = index;
            });
          },
          items: widget.imagesSrcList.map<Widget>((imgUrl) {
            return Container(
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border:
                      Border.all(color: CurrentPalette['border'], width: 1.0)),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(widget.imagesSrcList, (index, url) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    currentImageIndex == index ? Colors.red : Colors.white24),
          );
        }),
      )
    ]);
  }
}

class CachedFutureBuilder extends StatefulWidget {
  final Future future;
  final dynamic cacheStore;
  final Widget loader;
  final Function(dynamic) onCacheUsed;
  final Function(AsyncSnapshot) onUpdate;

  CachedFutureBuilder({
    this.future,
    this.cacheStore,
    this.loader,
    this.onCacheUsed,
    this.onUpdate,
  });

  @override
  _CachedFutureBuilderState createState() => _CachedFutureBuilderState();
}

class _CachedFutureBuilderState extends State<CachedFutureBuilder> {
  Widget loader;
  Future fut;
  @override
  void initState() {
    loader = widget.loader ?? CirclularLoader();
    fut = widget.future;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fut,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //Value Recieved
          if (snapshot.data != null)
            return widget.onUpdate(snapshot);
          else {
            if (widget.cacheStore.length > 0) {
              //Use CacheStore
              return widget.onCacheUsed(widget.cacheStore);
            } else {
              fut = widget.future;
              return loader;
            }
          }
        } else {
          //Pending
          if (widget.cacheStore.length > 0) {
            //Use CacheStore
            return widget.onCacheUsed(widget.cacheStore);
          } else {
            return loader;
          }
        } //Fallback
      },
    );
  }
}

class GeneralSliverPageView extends StatelessWidget {
  final String appBarTitle;
  final Widget sliverChild;
  final List<Widget> children;
  const GeneralSliverPageView(
      {this.appBarTitle, this.sliverChild, this.children});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("$appBarTitle"),
          pinned: true,
          expandedHeight: 350.0,
          flexibleSpace: FlexibleSpaceBar(background: sliverChild),
        ),
        SliverList(
          delegate: SliverChildListDelegate(children),
        )
      ],
    );
  }
}

class BottomNavigator extends StatelessWidget {
  const BottomNavigator();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
        // BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: ""),
      ],
      selectedItemColor: Color.fromARGB(255, 220, 20, 60),
      backgroundColor: Theme.of(context).backgroundColor,
      // unselectedItemColor: isCurrentPaletteDarkTheme ?  Colors.white : Colors.black,
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
  const MainAppDrawer();

  @override
  Widget build(BuildContext context) {
    final user = currentUser['user'];
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
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
              ),
              trailing: Icon(
                Icons.settings,
              ),
              onTap: () => Navigator.of(context).pushNamed('/Settings'),
            ),
            new ListTile(
              title: Text(
                "Bookmarks",
              ),
              trailing: Icon(
                Icons.bookmark,
              ),
              onTap: () => Navigator.of(context).pushNamed('/Bookmarks'),
            ),
            new ListTile(
              title: Text(
                "Trending",
              ),
              trailing: Icon(
                Icons.trending_up,
              ),
              onTap: () => Fluttertoast.showToast(
                  msg: "Feature Coming Soon!",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60)),
            ),
            new ListTile(
              title: Text(
                "News",
              ),
              trailing: Icon(
                Icons.wifi,
              ),
              onTap: () => Navigator.of(context).pushNamed('/NewsFeed'),
            ),
            new ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HashPostsViewer(),
                ),
              ),
              title: Text("Hashtags"),
              trailing: Icon(Icons.tag),
            ),
            new ListTile(
              onTap: () => Navigator.of(context).pushNamed('/About'),
              title: Text(
                "About",
              ),
              trailing: Icon(
                Icons.account_box,
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
              ),
              trailing: Icon(
                Icons.report,
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
  final Color color;
  final Function event;

  //Constructor
  ActionButton(this.actionText, this.icon, this.event, {this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 220, 20, 60),
          foregroundColor: Colors.white,
          child: Icon(icon),
          onPressed: event,
        ),
        Padding(padding: EdgeInsets.only(bottom: 10.0)),
        if (color != null)
          Text(actionText, style: TextStyle(color: color))
        else
          Text(actionText)
      ],
    );
  }
}

class AddOptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370.0,
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            ActionButton('Story', Icons.local_fire_department, () {
              Navigator.of(context).pushNamed('/StoryMaker');
            }),
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
            ActionButton('Image Carousel', Icons.image, () {
              Navigator.of(context).pushNamed('/MediaComposer');
            }),
            ActionButton('Video Carousel', Icons.video_library, () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => TesterPage()));
            }),
            ActionButton('Audio', Icons.music_note, () {
              Navigator.of(context).pushNamed('/MediaComposer');
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
  final Color color;
  final double strokeWidth;
  const CirclularLoader({this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(color ?? primaryColor),
              backgroundColor: Colors.transparent,
              strokeWidth: strokeWidth ?? 4,
            )
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Widget child;
  const ErrorPage({this.child});

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
  const BugReporterDialog();

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
                "microblogger is in its early stages! There will be several bugs in the Platform. Please describe the bug or inconsistency that you found! If possible, please add your contact information so that we can discuss the issue elaborately! Thank you for your time!",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                color: Colors.black38,
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
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
            Text("Report a Bug", style: TextStyle(color: Colors.white))
          ]),
          actions: [
            TextButton(
              child: Text("Report", style: TextStyle(color: Colors.white)),
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
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}

class OfflineAlert extends StatelessWidget {
  const OfflineAlert();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(230, 220, 20, 60),
      content: Text(
          "You are currently Offline! Please Check your network connection and try again!"),
      title: Row(children: [
        Icon(
          Icons.signal_cellular_connected_no_internet_4_bar,
          color: Colors.white,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text("Offline Alert!")
      ]),
      actions: [
        TextButton(
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

checkConnection(context) async {
  // bool x = await DataConnectionChecker().hasConnection;
  // if (!x) {
  //   print("NOT CONNECTED OR ERROR");
  //   Timer.run(() {
  //     showDialog(
  //         builder: (context) {
  //           return OfflineAlert();
  //         },
  //         context: context);
  //   });
  // }
}

void dataLogger(String type, String content) {
  print("\n\n[$type] ::: :: $content");
}

class UserTaggingWidget extends StatefulWidget {
  UserTaggingWidget();

  @override
  _UserTaggingWidgetState createState() => _UserTaggingWidgetState();
}

class _UserTaggingWidgetState extends State<UserTaggingWidget> {
  TextEditingController ctrl;
  List<String> users = ['Naveen', 'Ram', 'Satish', 'Some Other'], words = [];
  String str = '';
  List<String> coments = [];

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: 'Comment',
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (ctrl.text.isNotEmpty)
                        setState(() {
                          coments.add(ctrl.text);
                        });
                    }),
              ),
              style: TextStyle(
                color: Colors.black,
              ),
              onChanged: (val) {
                setState(() {
                  words = val.split(' ');
                  str = words.length > 0 &&
                          words[words.length - 1].startsWith('@')
                      ? words[words.length - 1]
                      : '';
                });
              }),

          //USERBOX
          str.length > 1
              ? ListView(
                  shrinkWrap: true,
                  children: users.map((s) {
                    if (('@' + s).contains(str))
                      return ListTile(
                          title: Text(
                            s,
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            String tmp = str.substring(1, str.length);
                            setState(() {
                              str = '';
                              ctrl.text += s
                                  .substring(
                                      s.indexOf(tmp) + tmp.length, s.length)
                                  .replaceAll(' ', '_');
                            });
                          });
                    else
                      return SizedBox();
                  }).toList())
              : SizedBox(),

          //PRINTING
          SizedBox(height: 25),
          coments.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: coments.length,
                  itemBuilder: (con, ind) {
                    return Text.rich(
                      TextSpan(
                          text: '',
                          children: coments[ind].split(' ').map((w) {
                            return w.startsWith('@') && w.length > 1
                                ? TextSpan(
                                    text: ' ' + w,
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () => showProfile(w),
                                  )
                                : TextSpan(
                                    text: ' ' + w,
                                    style: TextStyle(color: Colors.black));
                          }).toList()),
                    );
                  },
                )
              : SizedBox()
        ]));
  }

  showProfile(String s) {
    showDialog(
        context: context,
        builder: (con) => AlertDialog(
            title: Text('Profile of $s'),
            content: Text('Show the user profile !')));
  }
}

class HashTagEnabledUserTaggableTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxlines;
  final Function onChange;
  final List usernames;
  final List hashtags;
  final TextStyle style;
  final String hint;

  HashTagEnabledUserTaggableTextField({
    @required this.controller,
    @required this.maxlines,
    this.style,
    this.usernames,
    this.hashtags,
    this.onChange,
    this.hint,
  });

  @override
  _HashTagEnabledUserTaggableTextFieldState createState() =>
      _HashTagEnabledUserTaggableTextFieldState();
}

class _HashTagEnabledUserTaggableTextFieldState
    extends State<HashTagEnabledUserTaggableTextField> {
  List words = [];

  String selectedUser = '';
  List usernames = usernamesListCache;
  List hashtags = hashtagsListCache;

  @override
  void initState() {
    getUsersList().then((x) {
      usernames = x;
      usernamesListCache = x;
    });
    getHashtags().then((x) {
      hashtags = x;
      hashtagsListCache = x;
    });

    super.initState();
    if (widget.usernames != null) usernames = widget.usernames;
    if (widget.hashtags != null) hashtags = widget.hashtags;
  }

  List<Widget> generateHashtagSuggestions(List data) {
    return data.map((s) {
      if (('#' + s).contains(selectedUser)) {
        if (widget.onChange != null)
          return ListTile(
              // tileColor: Colors.white10,
              title: Text(
                '#$s',
              ),
              onTap: () {
                String tmp = selectedUser.substring(0, selectedUser.length);
                setState(() {
                  selectedUser = '';
                  widget.controller.text +=
                      s.substring(s.indexOf(tmp) + tmp.length, s.length) + " ";

                  //Fixing Cursor
                  widget.controller.value = TextEditingValue(
                      text: widget.controller.text,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      ));
                  widget.onChange(widget.controller.text); //update appended tag
                  // .replaceAll(' ', '_');
                });
              });
      } else
        return SizedBox();
    }).toList();
  }

  List<Widget> generateUsernameSuggestions(List data) {
    return data.map((s) {
      if (('@' + s).contains(selectedUser)) {
        if (widget.onChange != null)
          return ListTile(
              // tileColor: Colors.white10,
              title: Text(
                '@$s',
                // style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                String tmp = selectedUser.substring(0, selectedUser.length);
                setState(() {
                  selectedUser = '';
                  widget.controller.text +=
                      s.substring(s.indexOf(tmp) + tmp.length, s.length) + " ";

                  //Fixing Cursor
                  widget.controller.value = TextEditingValue(
                      text: widget.controller.text,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      ));
                  widget.onChange(widget.controller.text); //update appended tag
                  // .replaceAll(' ', '_');
                });
              });
      } else
        return SizedBox();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //-----------------------------SUGGESTIONS-------------------------------
      selectedUser.length > 1
          ? Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.0, color: CurrentPalette['border'])),
              child: SizedBox(
                height: 110.0,
                child: ListView(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    children: [
                      ...generateUsernameSuggestions(usernames),
                      ...generateHashtagSuggestions(hashtags),
                    ]),
              ),
            )
          : SizedBox(),
      //-----------------------------SUGGESTIONS-------------------------------
      SizedBox(
        height: 5.0,
      ),
      //-----------------------------INPUT-------------------------------
      TextField(
          controller: widget.controller,
          decoration: InputDecoration.collapsed(
            hintText: (widget.hint == null) ? 'Type Here!' : widget.hint,
          ),
          maxLines: widget.maxlines,
          style:
              (widget.style == null) ? TextStyle(fontSize: 19.0) : widget.style,
          onChanged: (val) {
            setState(() {
              val = val.replaceAll("\n", " ");
              words = val.split(' ');
              //Notifying
              if (words.length > 0) {
                if (words[words.length - 1].startsWith('@') ||
                    words[words.length - 1].startsWith('#')) {
                  selectedUser = words[words.length - 1];
                } else {
                  selectedUser = '';
                }
              }
              // selectedUser =
              //     words.length > 0 && words[words.length - 1].startsWith('@')
              //         ? words[words.length - 1]
              //         : '';
            });
            if (widget.onChange != null)
              widget.onChange(widget.controller.text);
          }),
    ]);
    //-----------------------------INPUT-------------------------------
  }
}

class HashTagEnabledUserTaggableTextDisplay extends StatelessWidget {
  final String text;
  final TextStyle style;
  const HashTagEnabledUserTaggableTextDisplay(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: (style == null) ? DefaultTextStyle.of(context).style : style,
          children: text.replaceAll("\n", "\n ").split(" ").map((w) {
            return w.startsWith('@') && w.length > 1
                ? TextSpan(
                    text: w + ' ',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print(w.substring(1));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      w.substring(1),
                                    )));
                      })
                : w.startsWith('#') && w.length > 1
                    ? TextSpan(
                        text: w + ' ',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Clicked on Topic: ${w.substring(1)}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HashtagPostViewer(
                                  hashtag: w.substring(1),
                                ),
                              ),
                            );
                          },
                      )
                    : TextSpan(
                        text: w + ' ',
                        style: (style == null)
                            ? DefaultTextStyle.of(context).style
                            : style);
          }).toList()),
    );
  }
}
