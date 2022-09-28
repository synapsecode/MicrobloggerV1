import 'package:microblogger/Backend/datastore.dart';
import 'package:microblogger/Backend/server.dart';
import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:microblogger/Screens/browser.dart';
import 'package:microblogger/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Components/Templates/postTemplates.dart';
import 'editprofile.dart';
import 'package:microblogger/palette.dart';

Map user = {};

class ProfilePage extends StatefulWidget {
  final username;
  ProfilePage(this.username);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Future profileData;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    checkConnection(context);
    profileData = getProfile(widget.username);
  }

  CustomScrollView generateProfileView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Profile"),
          pinned: true,
          expandedHeight: 350.0,
          flexibleSpace: FlexibleSpaceBar(background: SliverChild()),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ProfileAppBody(),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder fbdr = FutureBuilder(
      future: profileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          user = snapshot.data;
          return generateProfileView();
        } else {
          return CLoader();
        }
      },
    );

    CachedFutureBuilder cbdr = CachedFutureBuilder(
      future: profileData,
      cacheStore: globalProfileDataCache,
      onCacheUsed: (cache) {
        user = globalProfileDataCache;
        return generateProfileView();
      },
      onUpdate: (AsyncSnapshot snapshot) {
        user = snapshot.data;
        globalProfileDataCache = user;
        return generateProfileView();
      },
    );

    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigator(),
      body: (widget.username == currentUser['user']['username']) ? cbdr : fbdr,
    );
  }
}

class CLoader extends StatelessWidget {
  const CLoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator(
          //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          //   backgroundColor: Color.fromARGB(200, 220, 20, 60),
          // )
          CirclularLoader(),
        ],
      ),
    );
  }
}

class SliverChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              //image: AssetImage('assets/dhj.png'),
              image: NetworkImage("${user['user']['background']}"),
              fit: BoxFit.cover)),
      child: new ProfileTopBar(),
    );
  }
}

class ProfileAppBody extends StatefulWidget {
  @override
  _ProfileAppBodyState createState() => _ProfileAppBodyState();
}

class _ProfileAppBodyState extends State<ProfileAppBody>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: CurrentPalette['secondaryBackgroundColor'],
      child: Column(children: <Widget>[
        StatisticsBar(),
        //SizedBox(height: 20.0),
        BioCard(),
        Container(
          child: MyPostView(
            controller: _controller,
          ),
        ),
      ]),
    );
  }
}

class ProfileTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ProfileIcon(),
        SizedBox(height: 10.0),
        Text("${user['user']['name']}",
            style: TextStyle(fontSize: 30.0, color: Colors.white)),
        Center(
          child: Text("@${user['user']['username']}",
              style: TextStyle(fontSize: 20.0, color: Colors.blue)),
        ),
        SizedBox(height: 10.0),
        FollowUnfollowButton(),
      ],
    );
  }
}

class FollowUnfollowButton extends StatefulWidget {
  @override
  _FollowUnfollowButtonState createState() => _FollowUnfollowButtonState();
}

class _FollowUnfollowButtonState extends State<FollowUnfollowButton> {
  String op;
  @override
  void initState() {
    super.initState();
    op = (currentUser['user']['username'] == user['user']['username'])
        ? "Edit"
        : (user['isFollowing'])
            ? "Unfollow"
            : "Follow";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 140,
        child: ElevatedButton(
          onPressed: () async {
            if (currentUser['user']['username'] != user['user']['username']) {
              if (user['isFollowing']) {
                Fluttertoast.showToast(
                  msg: "Unfollowing",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
                await unfollowProfile(user['user']['username']);
              } else {
                Fluttertoast.showToast(
                  msg: "Following",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
                await followProfile(user['user']['username']);
              }
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            user['user']['username'],
                          )));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.people),
              SizedBox(width: 10.0),
              Text(op)
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.black54,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ));
  }
}

class ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: CircleAvatar(
          radius: 54.0,
          backgroundImage: NetworkImage("${user['user']['icon']}")),
      radius: 60.0,
      backgroundColor: Colors.white10,
    );
  }
}

class BioCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.all(20.0),
          // color: Colors.white10,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Bio", style: TextStyle(fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text("Member since ${user['user']['created_on']}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.0,
                      )),
                  SizedBox(width: 5.0),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text("${user['user']['bio']}"))
                ],
              ),
              SizedBox(height: 10.0),
              if (user['user']['location'] != "") ...[
                Opacity(
                  opacity: 0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20.0,
                      ),
                      SizedBox(width: 5.0),
                      Text("${user['user']['location']}")
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
              ],
              if (user['user']['website'] != "") ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GeneralBrowser(
                                  link: user['user']['website'],
                                )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.link,
                        color: Colors.blue,
                        size: 20.0,
                      ),
                      SizedBox(width: 5.0),
                      SizedBox(
                        width: 250,
                        child: Text(
                          "${user['user']['website']}",
                          style: TextStyle(color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }
}

class StatisticsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("${user['user']['reputation']}",
                    style: TextStyle(fontSize: 25.0, color: Colors.white)),
                Text("Reputation", style: TextStyle(color: Colors.white60))
              ],
            ),
            Column(
              children: <Widget>[
                Text("${user['user']['followers']}",
                    style: TextStyle(fontSize: 25.0, color: Colors.white)),
                Text("Followers", style: TextStyle(color: Colors.white60))
              ],
            ),
            Column(
              children: <Widget>[
                Text("${user['user']['following']}",
                    style: TextStyle(fontSize: 25.0, color: Colors.white)),
                Text("Following", style: TextStyle(color: Colors.white60))
              ],
            ),
          ],
        ));
  }
}

class MyPostView extends StatefulWidget {
  const MyPostView({
    @required TabController controller,
  }) : _controller = controller;

  final TabController _controller;

  @override
  _MyPostViewState createState() => _MyPostViewState(_controller);
}

class _MyPostViewState extends State<MyPostView> {
  final TabController _controller;
  _MyPostViewState(this._controller);

  Widget createTab(List data, Widget X) {
    if (data.length > 0) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: X,
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 150),
          Text(
            "No Posts",
            style: TextStyle(color: CurrentPalette['border']),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List othersFeed = user['posts']['mypollsandshareables'] ?? [];
    List microblogFeed = user['posts']['mymicroblogsandcomments'] ?? [];
    List blogandTimelineFeed =
        user['posts']['myblogstimelinesandcarousels'] ?? [];
    List reshareFeed = user['posts']['myreshares'] ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: new TabBar(
            controller: widget._controller,
            tabs: [
              new Tab(icon: new Icon(Icons.clear_all)),
              new Tab(icon: new Icon(Icons.repeat)),
              new Tab(icon: new Icon(Icons.content_copy)),
              new Tab(icon: new Icon(Icons.poll)),
            ],
          ),
        ),
        SizedBox(
          height: 530.0,
          child: Container(
            // color: CurrentPalette['secondaryBackgroundColor'],
            // transform: Matrix4.translationValues(
            //           0, -20, 0),
            child: TabBarView(
              controller: widget._controller,
              children: <Widget>[
                createTab(
                  microblogFeed,
                  ListView.builder(
                    itemCount: microblogFeed.length,
                    itemBuilder: (context, index) {
                      return new MicroBlogPost(
                        postObject: microblogFeed[index],
                      );
                    },
                  ),
                ),
                createTab(
                  reshareFeed,
                  ListView.builder(
                    itemCount: reshareFeed.length,
                    itemBuilder: (context, index) {
                      if (reshareFeed[index]['type'] == 'SimpleReshare')
                        return new SimpleReshare(
                          postObject: reshareFeed[index],
                        );
                      else
                        return new ReshareWithComment(
                          postObject: reshareFeed[index],
                        );
                    },
                  ),
                ),
                createTab(
                  blogandTimelineFeed,
                  ListView.builder(
                    itemCount: blogandTimelineFeed.length,
                    itemBuilder: (context, index) {
                      if (blogandTimelineFeed[index]['type'] == 'blog')
                        return BlogPost(blogandTimelineFeed[index]);
                      else if (blogandTimelineFeed[index]['type'] == 'timeline')
                        return Timeline(blogandTimelineFeed[index]);
                      else if (blogandTimelineFeed[index]['type'] == 'carousel')
                        return CarouselPost(
                            postObject: blogandTimelineFeed[index]);
                      return Container();
                    },
                  ),
                ),
                createTab(
                  othersFeed,
                  ListView.builder(
                    itemCount: othersFeed.length,
                    itemBuilder: (context, index) {
                      if (othersFeed[index]['type'] == 'shareable')
                        return new ShareablePost(
                          postObject: othersFeed[index],
                        );
                      else
                        return new PollPost(
                          postObject: othersFeed[index],
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
