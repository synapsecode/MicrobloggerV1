import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/reshare.dart';
import 'package:MicroBlogger/Composers/profileEditComposer.dart';
import 'package:MicroBlogger/Data/datafetcher.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';
import '../Components/PostTemplates/blogs.dart';
import '../Components/PostTemplates/timelines.dart';
import '../Components/PostTemplates/polls.dart';
import '../Components/PostTemplates/shareable.dart';
import '../Data/fetcher.dart';
import 'homepage.dart';

class UserProfile extends StatefulWidget {
  final username;
  var author;
  UserProfile({this.username, this.author});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  var _user;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    _user = getSpecificUser(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigator(),
        body: FutureBuilder(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                return ProfileBody(
                  user: snapshot.data,
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                );
              }
            }));
  }
}

class ProfileBody extends StatefulWidget {
  final user;
  ProfileBody({Key key, this.user}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.user['username'] != "0xxFFFFFF")
        ? CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()),
                      ModalRoute.withName('/'))),
              title: Text("Profile"),
              pinned: true,
              expandedHeight: 350.0,
              flexibleSpace: new FlexibleSpaceBar(
                  background: SliverChild(
                author: widget.user,
              )),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              ProfileAppBody(
                author: widget.user,
              )
            ]))
          ])
        : ErrorPage(
            child: AlertDialog(
              title: Text("User Not Found"),
              content: Text(
                  "This User Profile does not exist on the MicroBlog Platform. You are probably looking for someone else!"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Back"))
              ],
            ),
          );
  }
}

class SliverChild extends StatelessWidget {
  final author;
  SliverChild({this.author});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              //image: AssetImage('assets/dhj.png'),
              image: NetworkImage("${author['background']}"),
              fit: BoxFit.cover)),
      child: new ProfileTopBar(
        author: author,
      ),
    );
  }
}

class ProfileAppBody extends StatefulWidget {
  final author;
  ProfileAppBody({this.author});
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
    return Column(children: <Widget>[
      StatisticsBar(author: widget.author),
      //SizedBox(height: 20.0),
      BioCard(author: widget.author),
      MyPostView(
        controller: _controller,
        author: widget.author,
      ),
    ]);
  }
}

class ProfileTopBar extends StatelessWidget {
  final author;
  ProfileTopBar({this.author});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ProfileIcon(
          author: author,
        ),
        SizedBox(height: 10.0),
        Text("${author['name']}", style: TextStyle(fontSize: 30.0)),
        Center(
          child:
              Text("@${author['username']}", style: TextStyle(fontSize: 20.0)),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FollowToggler(
              author: author,
            ),
            InkWell(
              onTap: () => print("More clicked"),
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ],
    );
  }
}

class FollowToggler extends StatelessWidget {
  final author;
  FollowToggler({this.author});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 110.0,
        child: RaisedButton(
          onPressed: () {
            print("follow toggle for: ${author['username']}");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.people_outline),
              SizedBox(width: 10.0),
              Text("Follow")
            ],
          ),
          color: Colors.black87,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ));
  }
}

class ProfileIcon extends StatelessWidget {
  final author;
  ProfileIcon({this.author});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: CircleAvatar(
          radius: 54.0, backgroundImage: NetworkImage("${author['icon']}")),
      radius: 60.0,
      backgroundColor: Colors.white10,
    );
  }
}

class BioCard extends StatelessWidget {
  final author;
  BioCard({this.author});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white10,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Bio", style: TextStyle(fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text("Member since ${author['accountage']}",
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
                children: <Widget>[Expanded(child: Text("${author['bio']}"))],
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.white30,
                    size: 20.0,
                  ),
                  SizedBox(width: 5.0),
                  Text("${author['location']}",
                      style: TextStyle(color: Colors.white30))
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class StatisticsBar extends StatelessWidget {
  final author;
  StatisticsBar({this.author});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("${author['reputation']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Reputation")
              ],
            ),
            Column(
              children: <Widget>[
                Text("${author['following']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Following")
              ],
            ),
            Column(
              children: <Widget>[
                Text("${author['followers']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Followers")
              ],
            ),
          ],
        ));
  }
}

class MyPostView extends StatefulWidget {
  final author;
  const MyPostView({
    Key key,
    this.author,
    @required TabController controller,
  })  : _controller = controller,
        super(key: key);

  final TabController _controller;

  @override
  _MyPostViewState createState() => _MyPostViewState(_controller);
}

class _MyPostViewState extends State<MyPostView> {
  final TabController _controller;
  _MyPostViewState(this._controller);

  @override
  Widget build(BuildContext context) {
    List othersFeed = [
      ...widget.author['myShareables'],
      ...widget.author['myPolls']
    ];
    List microblogFeed = [...widget.author['myMicroBlogs']];
    List blogandTimelineFeed = [
      ...widget.author['myTimelines'],
      ...widget.author['myBlogs']
    ];
    List reshareFeed = [
      ...widget.author['myReshareWithComments'],
      ...widget.author['mySimpleReshares']
    ];
    othersFeed.shuffle();
    microblogFeed.shuffle();
    blogandTimelineFeed.shuffle();
    reshareFeed.shuffle();

    return Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            new Container(
              decoration:
                  new BoxDecoration(color: Theme.of(context).primaryColor),
              child: new TabBar(
                controller: widget._controller,
                tabs: [
                  new Tab(icon: new Icon(Icons.content_copy)),
                  new Tab(icon: new Icon(Icons.group)),
                  new Tab(icon: new Icon(Icons.poll)),
                  new Tab(icon: new Icon(Icons.check_box)),
                ],
              ),
            ),
            new SizedBox(
              height: 400.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: new TabBarView(
                  controller: widget._controller,
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: microblogFeed.length,
                        itemBuilder: (context, index) {
                          return new MicroBlogPost(
                            postObject: microblogFeed[index],
                          );
                        }),
                    ListView.builder(
                        shrinkWrap: true,
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
                        }),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: blogandTimelineFeed.length,
                        itemBuilder: (context, index) {
                          if (blogandTimelineFeed[index]['type'] == 'blog')
                            return BlogPost(
                                postObject: blogandTimelineFeed[index]);
                          else
                            return Timeline(blogandTimelineFeed[index]);
                        }),
                    ListView.builder(
                        //shareables and polls
                        shrinkWrap: true,
                        itemCount: othersFeed.length,
                        itemBuilder: (context, index) {
                          if (othersFeed[index]['type'] == 'shareable')
                            return new Shareable(
                              postObject: othersFeed[index],
                            );
                          else
                            return new PollPost(
                              postObject: othersFeed[index],
                            );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
