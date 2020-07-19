import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:flutter/material.dart';

import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/PostTemplates/comments.dart';

class ResharedWithCommentViewer extends StatefulWidget {
  final postObject;
  ResharedWithCommentViewer({Key key, this.postObject}) : super(key: key);

  @override
  _ResharedWithCommentViewerState createState() =>
      _ResharedWithCommentViewerState();
}

class _ResharedWithCommentViewerState extends State<ResharedWithCommentViewer> {
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
        title: Text("Reshared Post"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
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
                  TopBar(
                    postObject: widget.postObject,
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
                    HostMicroBlog(widget.postObject['child']),
                  ] else if (widget.postObject['child']['type'] ==
                      "shareable") ...[
                    HostShareable(widget.postObject['child']),
                  ] else if (widget.postObject['child']['type'] == "blog") ...[
                    HostBlog(widget.postObject['child']),
                  ] else if (widget.postObject['child']['type'] ==
                      "timeline") ...[
                    HostTimeline(widget.postObject['child']),
                  ],
                  //---------------------------------------CONTENT-------------------------------------------------
                  //---------------------------------------SubFooter-------------------------------------------------

                  //---------------------------------------SubFooter-------------------------------------------------
                ],
              ),
            ),
            // ActionBar(
            //   postType: "Microblog_ResharedWithComment",
            // ),
            ActionBar(
              post: widget.postObject,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Comments (${widget.postObject['comments'].length})',
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
                  itemCount: widget.postObject['comments'].length,
                  itemBuilder: (c, i) {
                    return new LevelOneComment(
                      commentObject: widget.postObject['comments'][i],
                    );
                  }),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigator(),
    );
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
              TopBar(
                postObject: data,
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
              TopBar(
                postObject: data,
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
