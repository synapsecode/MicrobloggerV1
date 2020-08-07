import 'package:MicroBlogger/Components/Templates/postTemplates.dart';
import 'profile.dart';
import '../Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';
import '../Backend/server.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future microBloggerUsers = getAllUsers();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text("Explore"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: DataSearch(microBloggerUsers));
              })
        ],
      ),
      body: Explorer(controller: _controller),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class ExporeBlogs extends StatelessWidget {
  final data;
  ExporeBlogs(this.data);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return BlogPost(
                      snapshot.data[index],
                    );
                  }),
            );
          } else {
            return CirclularLoader();
          }
        });
  }
}

class ExploreTimelines extends StatelessWidget {
  final data;
  ExploreTimelines(this.data);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Timeline(
                        snapshot.data[index],
                      );
                    }));
          } else {
            return CirclularLoader();
          }
        });
  }
}

class ExploreMicroblogs extends StatelessWidget {
  final data;
  ExploreMicroblogs(this.data);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return MicroBlogPost(
                        postObject: snapshot.data[index],
                      );
                    }));
          } else {
            return CirclularLoader();
          }
        });
  }
}

class ExploreOthers extends StatelessWidget {
  final data;
  ExploreOthers(this.data);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index]['type'] == 'shareable')
                        return ShareablePost(
                          postObject: snapshot.data[index],
                        );
                      else
                        return PollPost(postObject: snapshot.data[index]);
                    }));
          } else {
            return CirclularLoader();
          }
        });
  }
}

class Explorer extends StatefulWidget {
  final TabController _controller;
  const Explorer({
    Key key,
    @required TabController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  Future eMB = exploreMicroblogs();
  Future eB = exploreBlogs();
  Future eT = exploreTimelines();
  Future eSP = exploreShareablesandPolls();

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: TabBarView(
            controller: widget._controller,
            children: <Widget>[
              ExploreMicroblogs(eMB),
              ExporeBlogs(eB),
              ExploreTimelines(eT),
              ExploreOthers(eSP),
            ],
          ),
        )
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  Future profiles;
  DataSearch(this.profiles);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List suggestionList = [];
          if (query.isEmpty) {
            suggestionList = snapshot.data;
          } else {
            snapshot.data.forEach((e) {
              if (e['username'].toString().startsWith(query))
                suggestionList.add(e);
            });
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 20.0, top: 20.0),
                  child: Text(
                    "User Profiles",
                    style: TextStyle(fontSize: 35.0),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      suggestionList[index]['username'])));
                        },
                        leading: CircleAvatar(
                          foregroundColor: Color(0xFF28a366),
                          backgroundColor: Colors.black12,
                          backgroundImage:
                              NetworkImage(suggestionList[index]['icon']),
                        ),
                        title: Text(suggestionList[index]['username'])),
                  ),
                  itemCount: suggestionList.length,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
