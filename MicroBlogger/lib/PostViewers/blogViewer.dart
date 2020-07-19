import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/PostTemplates/comments.dart';

class BlogViewer extends StatefulWidget {
  final postObject;
  BlogViewer({Key key, this.postObject}) : super(key: key);

  @override
  _BlogViewerState createState() => _BlogViewerState();
}

class _BlogViewerState extends State<BlogViewer> {
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
            Container(
              color: Colors.white10,
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: TopBar(
                postObject: widget.postObject,
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
                        "${widget.postObject['blog_name']}",
                        style: TextStyle(fontSize: 44.0),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "${widget.postObject['content']}",
                          style:
                              TextStyle(color: Colors.white54, fontSize: 18.0),
                        )),
                  ],
                )),
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
                        commentObject: widget.postObject['comments'][i]);
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
