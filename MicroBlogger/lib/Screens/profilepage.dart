import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/reshare.dart';
import 'package:MicroBlogger/Data/datafetcher.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';
import '../Components/PostTemplates/blogs.dart';
import '../Components/PostTemplates/timelines.dart';
import '../Components/PostTemplates/polls.dart';
import '../Components/PostTemplates/shareable.dart';
import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  final author;
  ProfilePage({this.author});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    //get

    super.initState();
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      body: CustomScrollView(slivers: <Widget>[
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
            author: widget.author,
          )),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          ProfileAppBody(
            author: widget.author,
          )
        ]))
      ]),
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
        EditButton(
          author: author,
        ),
      ],
    );
  }
}

class EditButton extends StatelessWidget {
  final author;
  EditButton({this.author});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90.0,
        child: RaisedButton(
          onPressed: () =>
              print("editing details of author: ${author['username']}"),
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              SizedBox(width: 10.0),
              Text("Edit")
            ],
          ),
          color: Colors.black54,
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
          color: Colors.black12,
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
        color: Colors.black38,
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
