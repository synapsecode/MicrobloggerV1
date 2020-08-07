import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';
import '../Components/Templates/postTemplates.dart';
import 'homepage.dart';
import '../Screens/editprofile.dart';
import '../Backend/datastore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    loadUser();
  }

  loadUser() async {
    String x = await loadSavedUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigator(),
      body: (currentUser['user']['username'] != "0xxFFFFFF")
          ? CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                title: Text("Profile"),
                pinned: true,
                expandedHeight: 350.0,
                flexibleSpace: new FlexibleSpaceBar(background: SliverChild()),
              ),
              SliverList(delegate: SliverChildListDelegate([ProfileAppBody()]))
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
              image: NetworkImage("${currentUser['user']['background']}"),
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
    return Column(children: <Widget>[
      StatisticsBar(),
      //SizedBox(height: 20.0),
      BioCard(),
      MyPostView(
        controller: _controller,
      ),
    ]);
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
        Text("${currentUser['user']['name']}",
            style: TextStyle(fontSize: 30.0)),
        Center(
          child: Text("@${currentUser['user']['username']}",
              style: TextStyle(fontSize: 20.0)),
        ),
        SizedBox(height: 10.0),
        EditButton(),
      ],
    );
  }
}

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90.0,
        child: RaisedButton(
          onPressed: () {
            print(
                "editing details of author: ${currentUser['user']['username']}");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfilePage()));
          },
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
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: CircleAvatar(
          radius: 54.0,
          backgroundImage: NetworkImage("${currentUser['user']['icon']}")),
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
          color: Colors.white10,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Bio", style: TextStyle(fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text("Member since ${currentUser['user']['created_on']}",
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
                  Expanded(child: Text("${currentUser['user']['bio']}"))
                ],
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
                  Text("${currentUser['user']['location']}",
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
                Text("${currentUser['user']['reputation']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Reputation")
              ],
            ),
            Column(
              children: <Widget>[
                Text("${currentUser['user']['following']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Following")
              ],
            ),
            Column(
              children: <Widget>[
                Text("${currentUser['user']['followers']}",
                    style: TextStyle(fontSize: 25.0)),
                Text("Followers")
              ],
            ),
          ],
        ));
  }
}

class MyPostView extends StatefulWidget {
  const MyPostView({
    Key key,
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
    List othersFeed = currentUser['posts']['mypollsandshareables'] ?? [];
    List microblogFeed = currentUser['posts']['mymicroblogsandcomments'] ?? [];
    List blogandTimelineFeed =
        currentUser['posts']['myblogsandtimelines'] ?? [];
    List reshareFeed = currentUser['posts']['myreshares'] ?? [];

    othersFeed.shuffle();
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
                            return BlogPost(blogandTimelineFeed[index]);
                          else
                            return Timeline(blogandTimelineFeed[index]);
                        }),
                    ListView.builder(
                        //shareables and polls
                        shrinkWrap: true,
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
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
