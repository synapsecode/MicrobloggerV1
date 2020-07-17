import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/reshare.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';
import '../Components/PostTemplates/blogs.dart';
import '../Components/PostTemplates/timelines.dart';
import '../Components/PostTemplates/polls.dart';
import '../Components/PostTemplates/shareable.dart';
import 'homepage.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:
      //   ),
      // ),
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
          flexibleSpace: new FlexibleSpaceBar(background: SliverChild()),
        ),
        SliverList(delegate: SliverChildListDelegate([ProfileAppBody()]))
      ]),
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
              image: NetworkImage(
                  'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg'),
              //image: NetworkImage("https://picsum.photos/g/1000/1000/"),
              fit: BoxFit.cover)),
      child: new ProfileTopBar(),
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
        Text("Manas Hejmadi", style: TextStyle(fontSize: 30.0)),
        Center(
          child: Text("@synapse.code", style: TextStyle(fontSize: 20.0)),
        ),
        SizedBox(height: 10.0),
        EditButton(),
        // SizedBox(height: 10.0),
        // Center(child: new CoinIndicator())
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
          onPressed: () => print("Pressed Edit"),
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
          radius: 54.0, backgroundImage: AssetImage('assets/manas.jpg')),
      radius: 60.0,
      backgroundColor: Colors.white10,
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
      MyPostView(controller: _controller),
    ]);
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
          color: Colors.black12,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Bio", style: TextStyle(fontSize: 20.0)),
                  SizedBox(width: 10.0),
                  Text("Member Since April 2019",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.0,
                      )),
                  SizedBox(width: 5.0),
                  Text("(15 Days)",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10.0,
                      )),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                          "I'm a 15 Year old School Student from India who is very passionate about Metal and Rock Music. The Genre of Metal really touches my soul! Metal music is not just entertainment it is a way of life! My favourite band is Slipknot!"))
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
                  Text("Bangalore, India",
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
        color: Colors.black38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("25", style: TextStyle(fontSize: 25.0)),
                Text("Reputation")
              ],
            ),
            Column(
              children: <Widget>[
                Text("178", style: TextStyle(fontSize: 25.0)),
                Text("Following")
              ],
            ),
            Column(
              children: <Widget>[
                Text("687", style: TextStyle(fontSize: 25.0)),
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
    return Container(
        child: Column(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
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
          child: new TabBarView(
            controller: widget._controller,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return new MicroBlogPost();
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return new ReshareWithComment(
                      resharedType: "MicroBlog",
                      postObject: {'id': "dhr48fhdj"},
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    if (index % 2 == 0)
                      return new Timeline();
                    else
                      return new BlogPost();
                  }),
              ListView.builder(

                  //shareables and polls
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    if (index % 2 == 0)
                      return new Shareable();
                    else
                      return new PollPost();
                  }),
            ],
          ),
        ),
      ],
    ));
  }
}
