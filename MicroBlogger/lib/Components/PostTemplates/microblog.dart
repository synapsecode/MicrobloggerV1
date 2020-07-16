import 'package:flutter/material.dart';

class MicroBlogPost extends StatefulWidget {
  MicroBlogPost({Key key}) : super(key: key);

  @override
  _MicroBlogPostState createState() => _MicroBlogPostState();
}

class _MicroBlogPostState extends State<MicroBlogPost> {
  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/MicroBlogViewer'),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(color: Colors.white30, width: 1.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----------------------------------------HEADER-------------------------------------------------
                    Row(
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
                                  Text(
                                    "Fact",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () => print("More clicked"),
                                    child: Icon(Icons.arrow_drop_down),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //----------------------------------------HEADER-------------------------------------------------
                    SizedBox(
                      height: 10.0,
                    ),
                    //----------------------------------------CONTENT-------------------------------------------------
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white10, width: 0.5)),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                            ])),
                    //---------------------------------------CONTENT-------------------------------------------------
                    //---------------------------------------SubFooter-------------------------------------------------

                    //---------------------------------------SubFooter-------------------------------------------------
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border(
                          left: BorderSide(width: 1.0, color: Colors.white12),
                          right: BorderSide(width: 1.0, color: Colors.white12),
                          bottom:
                              BorderSide(width: 1.0, color: Colors.white12))),
                  height: 35.0,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(bottom: 2.0),
                            icon: Icon((_liked)
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: (_liked) ? Colors.pink : null,
                            onPressed: () => setState(() {
                              _liked = !_liked;
                            }),
                          ),
                          Text(
                            "30.65K",
                            style: TextStyle(color: Colors.white60),
                          )
                        ],
                      ),
                      //comment
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(bottom: 2.0),
                            icon:
                                Icon((_reshared) ? Icons.repeat : Icons.repeat),
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
                                            style: TextStyle(
                                                color: Colors.white))),
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
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.black,
                                // duration: Duration(seconds: 1),
                              ));
                            }),
                          ),
                          Text(
                            "200.3K",
                            style: TextStyle(color: Colors.white60),
                          )
                        ],
                      ),
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
                            icon: Icon((_bookmarked)
                                ? Icons.bookmark
                                : Icons.bookmark_border),
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
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       padding: EdgeInsets.only(bottom: 2.0),
                      //       icon: Icon(Icons.share),
                      //       onPressed: () => print("Share Modal"),
                      //     )
                      //   ],
                      // ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
