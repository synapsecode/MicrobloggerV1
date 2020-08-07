import 'package:MicroBlogger/Backend/server.dart';

import '../Components/Templates/postTemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReshareComposer extends StatefulWidget {
  final postObject;
  ReshareComposer({Key key, this.postObject}) : super(key: key);

  @override
  _ReshareComposerState createState() => _ReshareComposerState();
}

class _ReshareComposerState extends State<ReshareComposer> {
  String postType;
  Widget post = Container();
  bool isFact = false;
  String content = "";
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
      case "shareable":
        post = ShareablePost(postObject: widget.postObject);
        break;
      case "timeline":
        post = Timeline(widget.postObject);
        break;
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
    void updateContent(x) {
      setState(() {
        content = x;
      });
    }

    return Scaffold(
      backgroundColor: Colors.black87,
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
              onPressed: () {
                setState(() {
                  isFact = !isFact;
                });
              },
              child: (isFact) ? Text("Fact") : Text("Opinion"),
              color: (isFact) ? Colors.green : Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                String category = (isFact) ? "Fact" : "Opinion";
                // print(widget.postObject['id']);
                // print(widget.postObject['type']);
                // print("ResharedWithComment");
                // print(content);
                // print(category);
                await resharePost(widget.postObject['id'],
                    widget.postObject['type'], "ResharedWithComment",
                    content: content, category: category);
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: post,
            ),
            Container(
              margin: EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
              child: Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: TextField(
                      onChanged: (x) {
                        updateContent(x);
                      },
                      maxLines: 25,
                      style: TextStyle(fontSize: 19.0),
                      decoration: InputDecoration.collapsed(
                          hintText: "What are your views regarding this?"),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
