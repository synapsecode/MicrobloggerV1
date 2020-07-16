import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/PostTemplates/comments.dart';

class BlogViewer extends StatefulWidget {
  BlogViewer({Key key}) : super(key: key);

  @override
  _BlogViewerState createState() => _BlogViewerState();
}

class _BlogViewerState extends State<BlogViewer> {
  getText() {
    return "boys in those Southern parts grow apace and in a little while he was madly in love with a pretty girl who lived on the Grande Marina.  She had eyes like forest pools and held herself like a daughter of the Caesars.  They were affianced, but they could not marry till Salvatore had done his military service, and when he left the island which he had never left in his life before, to become a sailor in the navy of King Victor Emmanuel, he wept like a child.  It was hard for one who had never been less free than the birds to be at the beck and call of others, it was harder still to live in a battleship with strangers instead of in a little white cottage among the vines; and when he was ashore, to walk in noisy, friendless cities with streets so crowded that he was frightened to cross them, when he had been used to silent paths and the mountains and the sea.  I suppose it had never struck him that Ischia, which he looked at every evening (it was like a fairy island in the sunset) to see what the weather would be like next day, or Vesuvius, pearly in the dawn, had anything to do with him at all; but when he ceased to have them before his eyes he realized in some dim fashion that they were as much part of him as his hands and his feet.  He was dreadfully homesick.  But it was hardest of all to be parted from the girl he loved with all his passionate young heart.  He wrote to her (in his childlike handwriting) long, ill-spelt letters in which he told her how constantly he thought of her and how much he longed to be back.  He was sent here and there, to Spezzia, to Venice, to Ban and finally to China.  Here he fell ill of some mysterious ailment that kept him in hospital for months.  He bore it with the mute and uncomprehending patience of a dog.  When he learnt that it was a form of rheumatism that made him unfit for further service his heart exulted, for he could go home; and he did not bother, in fact he scarcely listened, when the doctors told him that he would never again be quite well. What did he care when he was going back to the little island he loved so well and the girl who was waiting I for him? When he got into the rowing-boat that met the steamer from Naples and was rowed ashore he saw his father and mother standing on the jetty and his two brothers, big boys now, and he waved to them.  His eyes searched t among the crowd that waited there, for the girl. ";
  }

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
        title: Text("Blog"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   child: BlogPost(),
            //   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            // ),
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
            Card(
                color: Colors.white10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "The Story of Salvatore",
                        style: TextStyle(fontSize: 44.0),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          getText(),
                          style:
                              TextStyle(color: Colors.white54, fontSize: 18.0),
                        )),
                  ],
                )),

            SizedBox(
              height: 10.0,
            ),
            ActionBar(),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Comments (4)',
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
                  itemCount: 4,
                  itemBuilder: (c, i) {
                    return new LevelOneComment();
                  }),
            ),
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
