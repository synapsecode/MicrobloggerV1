import 'package:flutter/material.dart';

class DirectMessagePage extends StatelessWidget {
  const DirectMessagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Direct Messages"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            tooltip: "New Post",
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () =>
                showSearch(context: context, delegate: DataSearch())),
        body: DMList());
  }
}

class DMList extends StatelessWidget {
  const DMList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          new ListTile(
              leading: new CircleAvatar(
                foregroundColor: Color(0xFF28a366),
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("Manas Hejmadi",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  new Text(
                    "22:02",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white24),
                  )
                ],
              ),
              subtitle: Container(
                //last message
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "Can you check the new features?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.white54),
                ),
              ),
              onTap: () => Navigator.of(context).popAndPushNamed('/Chat'))
        ],
      ),
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
    final suggestionList = profiles.where((p) => p.startsWith(query)).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, top: 20.0),
            child: Text(
              (query.isEmpty) ? "Search" : "Users",
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
                    Navigator.of(context).pushNamed('/Chat');
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
