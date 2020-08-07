import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/PostTemplates/comments.dart';

class TimelineViewer extends StatefulWidget {
  final postObject;
  TimelineViewer({Key key, this.postObject}) : super(key: key);

  @override
  _TimelineViewerState createState() => _TimelineViewerState();
}

class _TimelineViewerState extends State<TimelineViewer> {
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
        title: Text("Timeline"),
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
            Container(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "${widget.postObject['timeline_name']}",
                style: TextStyle(fontSize: 44.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.postObject['events'].length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: ListTile(
                            title: Card(
                                color: Colors.white10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.white24),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.postObject['events'][index]['event_name']}",
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        enabled: false,
                                        minLines: 5,
                                        maxLines: 30,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              "${widget.postObject['events'][index]['description']}",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        color: Colors.black12,
                                        child: Text(
                                          "${widget.postObject['events'][index]['timestamp']}",
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20.0,
                          color: Colors.grey,
                        ),
                        Container(
                          height: 20.0,
                          width: 20.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
            ActionBar(
              post: widget.postObject,
            ),
            SizedBox(
              height: 20.0,
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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
