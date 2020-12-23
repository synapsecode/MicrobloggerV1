import 'package:MicroBlogger/Backend/server.dart';

import 'postTemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Global/globalcomponents.dart';

class BaseViewer extends StatefulWidget {
  final postObject;
  BaseViewer({Key key, this.postObject}) : super(key: key);

  @override
  _BaseViewerState createState() => _BaseViewerState();
}

class _BaseViewerState extends State<BaseViewer> {
  String postType;
  Widget post = Container();
  @override
  void initState() {
    super.initState();
    postType = widget.postObject['type'];
    switch (widget.postObject['type']) {
      case "microblog":
        post = MicroBlogPost(postObject: widget.postObject, isInViewMode: true);
        break;
      case "blog":
        post = BlogPost(widget.postObject);
        break;
      case "carousel":
        post = CarouselPost(
          postObject: widget.postObject,
          isInViewMode: true,
        );
        break;
      case "shareable":
        post = ShareablePost(postObject: widget.postObject);
        break;
      case "timeline":
        post = Timeline(widget.postObject);
        break;
      case "poll":
        post = PollPost(postObject: widget.postObject);
        break;
      case "ResharedWithComment":
        post = ReshareWithComment(
          postObject: widget.postObject,
          isInViewMode: true,
        );
        break;
      case "SimpleReshare":
        post = SimpleReshare(
          postObject: widget.postObject,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
            "${postType.substring(0, 1).toUpperCase() + postType.substring(1)}"),
        // backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: post,
            ),
            CommentSection(postObject: widget.postObject)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class CommentSection extends StatefulWidget {
  final postObject;
  const CommentSection({Key key, this.postObject}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  Future commentData;
  @override
  void initState() {
    super.initState();
    Map post = widget.postObject;
    commentData = getCommentsFromPost(post);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: commentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Comments (${snapshot.data.length})',
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
                      itemCount: snapshot.data.length,
                      itemBuilder: (c, i) {
                        return new LevelOneComment(
                            commentObject: snapshot.data[i]);
                      }),
                ),
              ],
            );
          } else {
            return CirclularLoader();
          }
        });
  }
}
