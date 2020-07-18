import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:flutter/material.dart';

class ReshareComposer extends StatefulWidget {
  final postObject;
  const ReshareComposer({Key key, this.postObject}) : super(key: key);

  @override
  _ReshareComposerState createState() => _ReshareComposerState();
}

class _ReshareComposerState extends State<ReshareComposer> {
  bool isFact = false;
  String content = "";

  void updateComment(x) {
    setState(() {
      content = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
            child: RaisedButton(
              onPressed: () => setState(() => isFact = !isFact),
              child: (isFact) ? Text("Fact") : Text("Opinion"),
              color: (isFact) ? Colors.green : Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {
                print("TEXT: $content");
                //upload
                print("Reshare with Comment initiated");
                print("PostObject: ${widget.postObject}");
                print("Reshared Content: $content");
                print("isFact: $isFact");
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(
        contentUpdater: updateComment,
        postObject: widget.postObject,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  final postObject;
  const ComposerComponent({this.contentUpdater, this.postObject});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black12,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (widget.postObject['type'] == "microblog") ...[
            HostMicroBlog(widget.postObject)
          ] else if (widget.postObject['type'] == "shareable") ...[
            HostShareable(widget.postObject)
          ] else if (widget.postObject['type'] == "blog") ...[
            HostBlog(widget.postObject)
          ] else if (widget.postObject['type'] == "timeline") ...[
            HostTimeline(widget.postObject)
          ],
          Flexible(
            fit: FlexFit.loose,
            child: Card(
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (x) {
                      widget.contentUpdater("$x");
                    },
                    maxLines: 32,
                    decoration: InputDecoration.collapsed(
                        hintText: "What are your views regarding this post?"),
                  ),
                )),
          ),
        ]),
      ),
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
