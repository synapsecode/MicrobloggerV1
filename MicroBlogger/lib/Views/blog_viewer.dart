import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';

import '../Components/Templates/ViewerTemplate.dart';
import '../Components/Templates/basetemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BlogViewer extends StatefulWidget {
  final postObject;
  BlogViewer({Key key, this.postObject}) : super(key: key);

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
        child: FutureBuilder(
            future: blogData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white10,
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: TopBar(
                        postObject: widget.postObject,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                          color: Colors.white10,
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
                                  child: Text(
                                    "${snapshot.data['content']}",
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 18.0),
                                  )),
                            ],
                          )),
                    ),
                    ActionBar(
                      post: snapshot.data,
                    ),
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
