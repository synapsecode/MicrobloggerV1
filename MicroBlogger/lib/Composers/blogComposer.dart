import 'package:flutter/material.dart';

class BlogComposer extends StatefulWidget {
  const BlogComposer({Key key}) : super(key: key);

  @override
  _BlogComposerState createState() => _BlogComposerState();
}

class _BlogComposerState extends State<BlogComposer> {
  String content = "";
  String blogName = "";

  void updateComment(x) {
    setState(() {
      content = x;
    });
  }

  void blogNameUpdater(x) {
    setState(() {
      blogName = x;
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
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  print(blogName);
                  print(content);
                  //upload
                },
                child: Text("Publish"),
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black12,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ComposerComponent(
                contentUpdater: updateComment,
                blogNameUpdater: blogNameUpdater,
              ),
            ]),
          ),
        ));
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  final blogNameUpdater;
  const ComposerComponent({this.contentUpdater, this.blogNameUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (x) {
            widget.blogNameUpdater("$x");
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Blog Name',
          ),
        ),
      ),
      Flexible(
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (x) {
                  widget.contentUpdater("$x");
                },
                maxLines: 45,
                decoration:
                    InputDecoration.collapsed(hintText: "Start Blogging!"),
              ),
            )),
      ),
    ]);
  }
}
