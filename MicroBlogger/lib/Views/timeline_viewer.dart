import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Templates/ViewerTemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Components/Global/globalcomponents.dart';
import '../Components/Templates/basetemplate.dart';

class TimelineViewer extends StatefulWidget {
  final postObject;
  TimelineViewer({Key key, this.postObject}) : super(key: key);

  @override
  _TimelineViewerState createState() => _TimelineViewerState();
}

class _TimelineViewerState extends State<TimelineViewer> {
  Future timelineData;
  @override
  void initState() {
    super.initState();
    timelineData = getTimelineData(widget.postObject);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.postObject['events']);
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
        child: FutureBuilder(
            future: timelineData,
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
                        postObject: snapshot.data,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "${snapshot.data['timeline_name']}",
                        style: TextStyle(fontSize: 44.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data['events'].length,
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
                                                  width: 1.0,
                                                  color: Colors.white24),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data['events'][index]['event_name']}",
                                                style:
                                                    TextStyle(fontSize: 24.0),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              HashTagEnabledUserTaggableTextDisplay(
                                                  snapshot.data['events'][index]
                                                      ['description'],
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 18.0)),
                                              // TextField(
                                              //   enabled: false,
                                              //   minLines: 5,
                                              //   maxLines: 30,
                                              //   decoration:
                                              //       InputDecoration.collapsed(
                                              //     hintText:
                                              //         "${snapshot.data['events'][index]['description']}",
                                              //   ),
                                              // ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(4.0),
                                                color: Colors.black12,
                                                child: Text(
                                                  "${snapshot.data['events'][index]['timestamp']}",
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
                                      border: Border.all(
                                          width: 1.0, color: Colors.green),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
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
