import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/microblog.dart';
import 'package:MicroBlogger/Components/PostTemplates/polls.dart';
import 'package:MicroBlogger/Components/PostTemplates/shareable.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import '../Data/datafetcher.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName('/'))),
        title: Text("Explore"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Explorer(controller: _controller),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class ExporeBlogs extends StatelessWidget {
  const ExporeBlogs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = DataFetcher();
    List feed = [...data.blogPosts];
    feed.shuffle();
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              return BlogPost(
                postObject: feed[index],
              );
            }),
      ),
    );
  }
}

class ExploreTimelines extends StatelessWidget {
  const ExploreTimelines({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = DataFetcher();
    List feed = [...data.timelinePosts];
    feed.shuffle();
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              return Timeline(feed[index]);
            }),
      ),
    );
  }
}

class ExploreMicroblogs extends StatelessWidget {
  const ExploreMicroblogs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = DataFetcher();
    List feed = [...data.microblogPosts];
    feed.shuffle();
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              return MicroBlogPost(
                postObject: feed[index],
              );
            }),
      ),
    );
  }
}

class ExploreOthers extends StatelessWidget {
  const ExploreOthers({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = DataFetcher();
    List feed = [...data.shareablePosts, ...data.pollPosts];
    feed.shuffle();
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              if (feed[index]['type'] == 'shareable')
                return Shareable(
                  postObject: feed[index],
                );
              else
                return PollPost(postObject: feed[index]);
            }),
      ),
    );
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
              ExploreMicroblogs(),
              ExporeBlogs(),
              ExploreTimelines(),
              ExploreOthers(),
            ],
          ),
        )
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final profiles = [
    "graciefervor",
    "atomicbold",
    "muscleswalnut",
    "markingsdharma",
    "kyivexalted",
    "blackrydal",
    "slumprincess",
    "shoddarwin",
    "upsidebart",
    "secretarysneer",
    "overlookedcheel",
    "trimnesscoe",
    "afareuropium",
    "slightingbolster",
    "uhtcearedisease",
    "lispconfined",
    "spookilybroke",
    "pizzaenergetic",
    "posterjuvenile",
    "vibrantnaden",
    "moleculepottery",
    "ripeprincess",
    "oorttrolly",
    "friendlewdster",
    "staggwhispering",
    "triangularsplendid",
    "heritageappetizer",
    "soddenmonsoon",
    "radicallinked",
    "entwinecinder",
    "mutesatop",
    "wakefulflanked",
    "drotsmenvarchar",
    "pushpinunshaken",
    "stoecooper",
    "tackyelection",
    "ellipseitalic",
    "mercedanother",
    "shootpetal",
    "wheelreprocess",
    "swingingsuperstore",
    "giveawaycollected",
    "frequentrebalance",
    "filibusterreservoir",
    "spreepredictive",
    "bumssaline",
    "missteach",
    "blackynap",
    "spectrumbazooka",
    "sudburypossession",
    "belvawneystrain",
    "campdisplay",
    "maintenancelives",
    "rhombusvile",
    "enactmentomega",
    "neutereustatic",
    "wrongeduncover",
    "cilantrologged",
    "amosriddance",
    "wildfowlaward",
    "worthlessstight",
    "flirtmickey",
    "witnessarkaig",
    "gushglutinous",
    "peatblazor",
    "tyingganache",
    "edoramule",
    "playsetdisarm",
    "hillsboroughpopinjay",
    "requestavoid",
    "canisdawn",
    "gatherforest",
    "facsimilecertainly",
    "scotsmeninformation",
    "curehowick",
    "brunswickdots",
    "jesterreason",
    "cloudnail",
    "accuratesnowless",
    "waldenbaphead",
    "extrasrumor",
    "forebitthoddypeak",
    "doughnutcontrite",
    "litradian",
    "cognitionstrut",
    "pajamasgreat",
    "huffmonnow",
    "cutlercrepe",
    "shamelessworcester",
    "soreitch",
    "deepnessgrateful",
    "limitmyth",
    "slappingeminent",
    "trallzirconium"
  ];

  final recent = [
    "frequentrebalance",
    "filibusterreservoir",
    "missteach",
    "blackynap",
    "spectrumbazooka",
    "sudburypossession",
  ];

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
    final suggestionList = query.isEmpty
        ? recent
        : profiles.where((p) => p.startsWith(query)).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, top: 20.0),
            child: Text(
              (query.isEmpty) ? "Recent Searches" : "User Profiles",
              style: TextStyle(fontSize: 35.0),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Profile');
                  },
                  leading: CircleAvatar(
                    foregroundColor: Color(0xFF28a366),
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"),
                  ),
                  // trailing: (query.isEmpty)
                  //     ? IconButton(
                  //         icon: Icon(Icons.clear),
                  //         onPressed: () {
                  //           suggestionList.removeAt(index);
                  //           showResults(context);
                  //         })
                  //     : null,
                  title: Text(suggestionList[index])),
            ),
            itemCount: suggestionList.length,
          ),
        ],
      ),
    );
  }
}
