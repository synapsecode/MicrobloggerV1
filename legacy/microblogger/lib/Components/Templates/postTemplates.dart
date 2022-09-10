import 'dart:ui';

import 'package:microblogger/Backend/server.dart';
import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:microblogger/Components/Templates/nativeVideoPlayer.dart';
import 'package:microblogger/Screens/profile.dart';
import 'package:microblogger/Views/blog_viewer.dart';
import 'package:microblogger/Views/shareableWebViewer.dart';
import 'package:microblogger/Views/timeline_viewer.dart';
import 'package:microblogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'basetemplate.dart';

class StoriesHolder extends StatelessWidget {
  final Map postObject;
  const StoriesHolder({
    this.postObject,
  });

  Widget storyItemElement({String uname, String thumbnailUrl}) {
    return InkWell(
      onTap: () {
        print("Open Story");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: CurrentPalette['errorColor'],
              child: CircleAvatar(
                  radius: 34,
                  // backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(thumbnailUrl ??
                      'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80')),
            ),
            SizedBox(height: 2.0),
            SizedBox(
              width: 80,
              child: Text(
                uname ?? "username",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Rebild");
    return Container(
      color: CurrentPalette['postcolor'],
      // margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      height: 110.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CurrentPalette['postcolor'],
        // border: Border.all(
        //   color: CurrentPalette['border'],
        // ),
      ),
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: postObject['stories'],
        itemBuilder: (context, index) {
          Map story = postObject['stories'][index];
          return storyItemElement(uname: story['username']);
        },
      ),
    );
  }
}

class MicroBlogPost extends StatelessWidget {
  final postObject;
  final isInViewMode;
  final bool isHosted;
  const MicroBlogPost(
      {this.postObject, this.isHosted = false, this.isInViewMode = false});

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(
        postObject: postObject,
        isHosted: isHosted,
        isInViewMode: isInViewMode,
        widgetComponent:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HashTagEnabledUserTaggableTextDisplay(postObject['content']),
        ]));
  }
}

class CarouselPost extends StatefulWidget {
  final postObject;
  final isInViewMode;
  final bool isHosted;
  const CarouselPost(
      {this.postObject, this.isHosted = false, this.isInViewMode = false});

  @override
  _CarouselPostState createState() => _CarouselPostState();
}

class _CarouselPostState extends State<CarouselPost> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(
        postObject: widget.postObject,
        isHosted: widget.isHosted,
        isInViewMode: widget.isInViewMode,
        widgetComponent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HashTagEnabledUserTaggableTextDisplay(widget.postObject['content']),
            SizedBox(
              height: 15,
            ),
            ImageCarousel(
              imagesSrcList: widget.postObject['images'],
            )
          ],
        ));
  }
}

class LevelOneComment extends StatelessWidget {
  final commentObject;
  const LevelOneComment({this.commentObject});

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(
        postObject: commentObject,
        widgetComponent:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HashTagEnabledUserTaggableTextDisplay(commentObject['content']),
        ]));
  }
}

class PollPost extends StatefulWidget {
  final postObject;
  const PollPost({this.postObject});

  @override
  _PollPostState createState() => _PollPostState();
}

class _PollPostState extends State<PollPost> {
  int votedFor;
  @override
  void initState() {
    super.initState();
    votedFor = widget.postObject['votedFor'];
  }

  @override
  Widget build(BuildContext context) {
    int c = -1;
    return BasicTemplate(
        postObject: widget.postObject,
        widgetComponent:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HashTagEnabledUserTaggableTextDisplay(widget.postObject['content']),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: [...widget.postObject['options']].map((x) {
              c += 1;
              return Row(children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: (votedFor == c) ? Colors.green : Colors.black,
                  ),
                  onPressed: () {
                    print("Clicked on option (${x['name']}) in Poll");
                    if (votedFor == -1) {
                      submitVote(widget.postObject['id'],
                          widget.postObject['options'].indexOf(x).toString());
                      setState(() {
                        votedFor = widget.postObject['options'].indexOf(x);
                        x['count']++;
                      });
                      widget.postObject['votedFor'] = votedFor;
                    } else
                      Fluttertoast.showToast(
                          msg: "Already Voted",
                          backgroundColor: Color.fromARGB(200, 220, 20, 60));
                  },
                  child: (votedFor != -1)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${x['name']}"),
                            Text(
                              " (${x['count']})",
                              style: TextStyle(color: Colors.white30),
                            )
                          ],
                        )
                      : Text("${x['name']}"),
                ))
              ]);
            }).toList(),
          ),
        ]));
  }
}

class ShareablePost extends StatelessWidget {
  final postObject;
  final bool isHosted;
  const ShareablePost({this.postObject, this.isHosted = false});

  @override
  Widget build(BuildContext context) {
    return BasicTemplate(
        isHosted: isHosted,
        postObject: postObject,
        widgetComponent:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HashTagEnabledUserTaggableTextDisplay(postObject['content']),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(200, 220, 20, 60),
                  ),
                  onPressed: () {
                    print("Visiting ${postObject['link']}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareableWebView(
                                  link: postObject['link'],
                                )));
                  },
                  icon: Icon(Icons.link),
                  label: Text("Visit ${postObject['name']}"))
            ],
          )
        ]));
  }
}

class SimpleReshare extends StatelessWidget {
  final postObject;
  SimpleReshare({this.postObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Reshared By ",
                style: TextStyle(color: CurrentPalette['transparent_text']),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                postObject['author']['username'],
                              )));
                },
                child: Text(
                  "@${postObject['author']['username']}",
                  style: TextStyle(color: Colors.pink),
                ),
              )
            ],
          ),
          if (postObject['child']['type'] == "microblog") ...[
            MicroBlogPost(
              postObject: postObject['child'],
            )
          ] else if (postObject['child']['type'] == "shareable") ...[
            ShareablePost(
              postObject: postObject['child'],
            )
          ] else if (postObject['child']['type'] == "blog") ...[
            BlogPost(
              postObject['child'],
            )
          ] else if (postObject['child']['type'] == "timeline") ...[
            Timeline(
              postObject['child'],
            )
          ] else if (postObject['child']['type'] == "carousel") ...[
            CarouselPost(
              postObject: postObject['child'],
            )
          ],
        ],
      ),
    );
  }
}

class BlogPost extends StatelessWidget {
  final postObject;
  final isHosted;
  BlogPost(this.postObject, {this.isHosted = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlogViewer(postObject: postObject))),
      child: Padding(
          padding: (isHosted)
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                border: Border.all(
              width: 1.0,
              color: Colors.white38,
            )),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                    constraints: new BoxConstraints.expand(
                      height: 250.0,
                    ),
                    padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: NetworkImage("${postObject['background']}"),
                          fit: BoxFit.cover),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        new Positioned(
                            left: 0.0,
                            top: 20.0,
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage: NetworkImage(
                                      "${postObject['author']['icon']}"),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${postObject['author']['name']}",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    Text(
                                      "@${postObject['author']['username']}",
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                )
                              ],
                            )),
                        new Positioned(
                          left: 0.0,
                          bottom: 20.0,
                          child: Container(
                            width: 300.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Writeup",
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white)),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text("${postObject['blog_name']}",
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
          )),
    );
  }
}

class Timeline extends StatelessWidget {
  final isHosted;
  final postObject;
  Timeline(this.postObject, {this.isHosted = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TimelineViewer(postObject: postObject))),
        child: Padding(
          padding: (isHosted)
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                border: Border.all(
              width: 1.0,
              color: Colors.white38,
            )),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                    constraints: new BoxConstraints.expand(
                      height: 250.0,
                    ),
                    padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: NetworkImage("${postObject['background']}"),
                          fit: BoxFit.cover),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        new Positioned(
                            left: 0.0,
                            top: 20.0,
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage: NetworkImage(
                                      "${postObject['author']['icon']}"),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${postObject['author']['name']}",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    Text(
                                      "@${postObject['author']['username']}",
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                )
                              ],
                            )),
                        new Positioned(
                          left: 0.0,
                          bottom: 20.0,
                          child: Container(
                            width: 300.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Timeline",
                                    style: new TextStyle(
                                        fontSize: 40.0, color: Colors.white)),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text("${postObject['timeline_name']}",
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
          ),
        ));
  }
}

class ReshareWithComment extends StatelessWidget {
  final postObject;
  final isInViewMode;
  ReshareWithComment({this.postObject, this.isInViewMode = false});

  @override
  Widget build(BuildContext context) {
    Widget hostChild = Container();

    if (postObject['child']['type'] == "blog") {
      hostChild = BlogPost(
        postObject['child'],
        isHosted: true,
      );
    } else if (postObject['child']['type'] == "timeline") {
      hostChild = Timeline(
        postObject['child'],
        isHosted: true,
      );
    } else if (postObject['child']['type'] == "microblog") {
      hostChild = MicroBlogPost(
        postObject: postObject['child'],
        isHosted: true,
      );
    } else if (postObject['child']['type'] == "shareable") {
      hostChild = ShareablePost(
        postObject: postObject['child'],
        isHosted: true,
      );
    } else if (postObject['child']['type'] == "carousel") {
      hostChild = CarouselPost(
        postObject: postObject['child'],
      );
    }
    return BasicTemplate(
        postObject: postObject,
        isInViewMode: isInViewMode,
        widgetComponent: hostChild);
  }
}

class VideoCarouselPost extends StatefulWidget {
  final postObject;
  // final isInViewMode;
  // final bool isHosted;
  const VideoCarouselPost({
    this.postObject,
    // this.isHosted = false,
    // this.isInViewMode = false
  });

  @override
  _VideoCarouselPostState createState() => _VideoCarouselPostState();
}

class _VideoCarouselPostState extends State<VideoCarouselPost> {
  @override
  Widget build(BuildContext context) {
    return BasicTemplate(
        postObject: widget.postObject,
        isHosted: false,
        isInViewMode: false,
        widgetComponent:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HashTagEnabledUserTaggableTextDisplay(widget.postObject['content']),
          SizedBox(
            height: 5.0,
          ),
          Container(child: NativeVideoPlayer(widget.postObject['videoURLs'][0])

              // PageView(
              //   controller: _controller,
              //   children: [
              //     widget.postObject['videoURLs'].forEach((e) {
              //       return NativeVideoPlayer(e);
              //     })
              //   ],
              // ),
              )
        ]));
  }
}
