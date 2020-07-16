import 'package:flutter/material.dart';
import 'microblog.dart';

class ReshareWithComment extends StatefulWidget {
  ReshareWithComment({Key key}) : super(key: key);

  @override
  _ReshareWithCommentState createState() => _ReshareWithCommentState();
}

class _ReshareWithCommentState extends State<ReshareWithComment> {
  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/MicroBlogPost');
          },
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
                    Text(
                        "Thats a good move! Everybody needs a break from social media once in a while :)"),
                    SizedBox(
                      height: 10.0,
                    ),
                    HostMicroBlog(),
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
                            "30.2K",
                            style: TextStyle(color: Colors.white60),
                          )
                        ],
                      ),
                      //comment
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       padding: EdgeInsets.only(bottom: 2.0),
                      //       icon:
                      //           Icon((_reshared) ? Icons.repeat : Icons.repeat),
                      //       color: (_reshared) ? Colors.green : null,
                      //       onPressed: () => setState(() {
                      //         _reshared = !_reshared;
                      //       }),
                      //     ),
                      //     Text(
                      //       "20.4K",
                      //       style: TextStyle(color: Colors.white60),
                      //     )
                      //   ],
                      // ),
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(bottom: 2.0),
                            icon: Icon(Icons.chat_bubble_outline),
                            onPressed: () => print("Open Comments"),
                          ),
                          Text(
                            "2000",
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

class HostMicroBlog extends StatelessWidget {
  const HostMicroBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Redirecting to MicroBlog");
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
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
                                  "Carryminati",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => print("clicked user"),
                                      child: Text(
                                        "@ajeynagar",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "22h",
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Opinion",
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                    SizedBox(
                                      width: 5,
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
                              border: Border.all(
                                  color: Colors.white10, width: 0.5)),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more on my creative development. See you guys soon!"),
                              ])),
                      //---------------------------------------CONTENT-------------------------------------------------
                      //---------------------------------------SubFooter-------------------------------------------------

                      //---------------------------------------SubFooter-------------------------------------------------
                    ],
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class Reshare extends StatefulWidget {
  Reshare({Key key}) : super(key: key);

  @override
  _ReshareState createState() => _ReshareState();
}

class _ReshareState extends State<Reshare> {
  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Reshared by ",
              style: TextStyle(color: Colors.white30),
            ),
            InkWell(
              onTap: () => print("RESEND"),
              child: Text(
                "@synapse.ai",
                style: TextStyle(color: Colors.pink),
              ),
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
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
                                  "Tanmay Bhat",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => print("clicked user"),
                                      child: Text(
                                        "@tanmaybot",
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
                              border: Border.all(
                                  color: Colors.white10, width: 0.5)),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "is simply dummy text of the printing and typesetting industry.  remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
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
                            right:
                                BorderSide(width: 1.0, color: Colors.white12),
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
                              "3.2K",
                              style: TextStyle(color: Colors.white60),
                            )
                          ],
                        ),
                        // //comment
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(bottom: 2.0),
                              icon: Icon(
                                  (_reshared) ? Icons.repeat : Icons.repeat),
                              color: (_reshared) ? Colors.green : null,
                              onPressed: () => setState(() {
                                _reshared = !_reshared;
                              }),
                            ),
                            Text(
                              "200K",
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
                      ],
                    )),
              ],
            )),
      ],
    );
  }
}
