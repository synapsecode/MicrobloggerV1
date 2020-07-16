import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/PostTemplates/comments.dart';

class TimelineViewer extends StatefulWidget {
  TimelineViewer({Key key}) : super(key: key);

  @override
  _TimelineViewerState createState() => _TimelineViewerState();
}

class _TimelineViewerState extends State<TimelineViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              print("Back");
            }),
        title: Text("Timeline"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white10,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manas Hejmadi",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => print("clicked user"),
                              child: Text(
                                "@synapse.ai",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "12h",
                              style: TextStyle(color: Colors.white30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "The Covid Crisis in India and Abroad",
                style: TextStyle(fontSize: 44.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: ListTile(
                            title: Card(
                                color: Colors.white10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.white24),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "First Signs",
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        enabled: false,
                                        maxLines: 5,
                                        decoration: InputDecoration.collapsed(
                                            hintText:
                                                "The SARS-Coronavirus-19 virus caused a pandedmic that has been named CoVID-19. This virus was first isolated in the Wuhan District of China"),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        color: Colors.black12,
                                        child: Text("16th January 2019"),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20.0,
                          color: Colors.grey,
                        ),
                        Container(
                          height: 20.0,
                          width: 20.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
            ActionBar(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Comments (2)',
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (c, i) {
                    return new LevelOneComment();
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class ActionBar extends StatefulWidget {
  ActionBar({Key key}) : super(key: key);

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border.all(width: 1.0, color: Colors.white30)),
        height: 35.0,
        child: Row(children: [
          Row(
            children: [
              IconButton(
                  padding: EdgeInsets.only(bottom: 2.0),
                  icon: Icon((_liked) ? Icons.favorite : Icons.favorite_border),
                  color: (_liked) ? Colors.pink : null,
                  onPressed: () => setState(() {
                        _liked = !_liked;
                      })),
              Text("3409"),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon((_reshared) ? Icons.repeat : Icons.repeat),
                    color: (_reshared) ? Colors.green : null,
                    onPressed: () => setState(() {
                      _reshared = !_reshared;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        // content: Text(
                        //   "Saved To Bookmarks",
                        //   style: TextStyle(color: Colors.white),
                        // ),
                        content: Row(
                          children: [
                            RaisedButton(
                                onPressed: () {
                                  //reshare logic
                                },
                                color: Colors.white10,
                                child: Text("Reshare",
                                    style: TextStyle(color: Colors.white))),
                            SizedBox(
                              width: 5.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    '/MB_ReshareComposer',
                                    arguments: {"MB"});
                              },
                              color: Colors.white10,
                              child: Text("Reshare with Comment",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.black,
                        // duration: Duration(seconds: 1),
                      ));
                    }),
                  ),
                ],
              ),
              Text("3409"),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () => print("Open Comments"),
                  ),
                  Text(
                    "200",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(
                        (_bookmarked) ? Icons.bookmark : Icons.bookmark_border),
                    color: (_bookmarked) ? Colors.green : null,
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Saved To Bookmarks",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 1),
                      ));
                      setState(() {
                        _bookmarked = !_bookmarked;
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ]));
  }
}
