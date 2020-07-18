import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/microblog.dart';
import 'package:MicroBlogger/Components/PostTemplates/shareable.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:MicroBlogger/PostViewers/MicroBlogViewer.dart';
import 'package:MicroBlogger/PostViewers/ReshareViewer.dart';
import 'package:MicroBlogger/PostViewers/blogViewer.dart';
import 'package:MicroBlogger/PostViewers/timelineViewer.dart';
import 'package:flutter/material.dart';

class ReshareWithComment extends StatefulWidget {
  final postObject;
  ReshareWithComment({Key key, this.postObject}) : super(key: key);

  @override
  _ReshareWithCommentState createState() => _ReshareWithCommentState();
}

class _ReshareWithCommentState extends State<ReshareWithComment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ResharedWithCommentViewer(
                postObject: widget.postObject,
              );
            }));
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
                              "${widget.postObject['author']['icon']}"),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.postObject['author']['name']}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => print("clicked user"),
                                    child: Text(
                                      "@${widget.postObject['author']['username']}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.postObject['age']}",
                                    style: TextStyle(color: Colors.white30),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.postObject['category']}",
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
                    Text("${widget.postObject['content']}"),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (widget.postObject['child']['type'] == "microblog") ...[
                      InkWell(
                        child: HostMicroBlog(
                          widget.postObject['child'],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MicroBlogViewer(
                                        postObject: widget.postObject['child'],
                                      )));
                        },
                      ),
                    ] else if (widget.postObject['child']['type'] ==
                        "shareable") ...[
                      HostShareable(widget.postObject['child']),
                    ] else if (widget.postObject['child']['type'] ==
                        "blog") ...[
                      InkWell(
                        child: HostBlog(widget.postObject['child']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlogViewer(
                                        postObject: widget.postObject['child'],
                                      )));
                        },
                      ),
                    ] else if (widget.postObject['child']['type'] ==
                        "timeline") ...[
                      InkWell(
                        child: HostTimeline(widget.postObject['child']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimelineViewer(
                                        postObject: widget.postObject['child'],
                                      )));
                        },
                      ),
                    ],
                    //---------------------------------------CONTENT-------------------------------------------------
                    //---------------------------------------SubFooter-------------------------------------------------

                    //---------------------------------------SubFooter-------------------------------------------------
                  ],
                ),
              ),
              ActionBar(
                post: widget.postObject,
              )
            ],
          ),
        ));
  }
}

class HostMicroBlog extends StatelessWidget {
  final data;
  HostMicroBlog(this.data);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.white30, width: 1.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------HEADER-------------------------------------------------
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage("${data['author']['icon']}"),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['author']['name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => print("clicked user"),
                              child: Text(
                                "@${data['author']['username']}",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${data['age']}",
                              style: TextStyle(color: Colors.white30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${data['category']}",
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
                      border: Border.all(color: Colors.white10, width: 0.5)),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data['content']}"),
                      ])),
              //---------------------------------------CONTENT-------------------------------------------------
              //---------------------------------------SubFooter-------------------------------------------------

              //---------------------------------------SubFooter-------------------------------------------------
            ],
          ),
        ),
      ],
    );
  }
}

class HostShareable extends StatelessWidget {
  final data;
  const HostShareable(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    backgroundImage: NetworkImage("${data['author']['icon']}"),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['author']['name']}",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => print("clicked user"),
                              child: Text(
                                "@${data['author']['username']}",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${data['age']}",
                              style: TextStyle(color: Colors.white30),
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
                      border: Border.all(color: Colors.white10, width: 0.5)),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data['content']}"),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton.icon(
                                color: Colors.black,
                                onPressed: () {
                                  print("Redirected to ${data['link']}");
                                },
                                icon: Icon(Icons.link),
                                label: Text("Visit ${data['name']}"))
                          ],
                        )
                      ])),
              //---------------------------------------CONTENT-------------------------------------------------
              //---------------------------------------SubFooter-------------------------------------------------

              //---------------------------------------SubFooter-------------------------------------------------
            ],
          ),
        ),
      ],
    ));
  }
}

class HostBlog extends StatelessWidget {
  final data;
  HostBlog(this.data);

  @override
  Widget build(BuildContext context) {
    return BlogPost(
      postObject: data,
    );
  }
}

class HostTimeline extends StatelessWidget {
  final data;
  HostTimeline(this.data);

  @override
  Widget build(BuildContext context) {
    return Timeline(data);
  }
}

class SimpleReshare extends StatefulWidget {
  final postObject;
  SimpleReshare({Key key, this.postObject}) : super(key: key);

  @override
  _SimpleReshareState createState() => _SimpleReshareState();
}

class _SimpleReshareState extends State<SimpleReshare> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Reshared By ",
              style: TextStyle(color: Colors.white30),
            ),
            InkWell(
              onTap: () {
                //MAKE LOGIC TO GET USERDATA FROM DJN
                //Navigator.of(context).pushNamed('/Profile');
              },
              child: Text(
                "@${widget.postObject['author']['username']}",
                style: TextStyle(color: Colors.pink),
              ),
            )
          ],
        ),
        if (widget.postObject['child']['type'] == "microblog") ...[
          MicroBlogPost(
            postObject: widget.postObject['child'],
          )
        ] else if (widget.postObject['child']['type'] == "shareable") ...[
          Shareable(
            postObject: widget.postObject['child'],
          )
        ] else if (widget.postObject['child']['type'] == "blog") ...[
          BlogPost(
            postObject: widget.postObject['child'],
          )
        ] else if (widget.postObject['child']['type'] == "timeline") ...[
          Timeline(
            widget.postObject['child'],
          )
        ],
      ],
    );
  }
}
