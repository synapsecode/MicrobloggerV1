import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/palette.dart';

import '../Components/Templates/ViewerTemplate.dart';
import '../Components/Templates/basetemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../origin.dart';

class BlogViewer extends StatefulWidget {
  final postObject;
  BlogViewer({this.postObject});

  @override
  _BlogViewerState createState() => _BlogViewerState();
}

class _BlogViewerState extends State<BlogViewer> {
  Future blogData;
  @override
  void initState() {
    super.initState();
    blogData = getBlogData(widget.postObject);
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
              print("Back");
            }),
        title: Text("Blog"),
        // backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: blogData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white10,
                      padding: EdgeInsets.all(10.0),
                      child: TopBar(
                        postObject: widget.postObject,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        // color: Colors.white10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "${snapshot.data['blog_name']}",
                                style: TextStyle(fontSize: 44.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: HashTagEnabledUserTaggableTextDisplay(
                                snapshot.data['content'],
                                style: TextStyle(
                                  color: Origin.of(context)
                                          .isCurrentPaletteDarkTheme
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: 20.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ActionBar(
                      noborder: true,
                      backgroundColor: Colors.transparent,
                      post: snapshot.data,
                    ),
                    SizedBox(height: 10.0),
                    CommentSection(
                      postObject: snapshot.data,
                    )
                  ],
                );
              } else {
                return CirclularLoader();
              }
            }),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
