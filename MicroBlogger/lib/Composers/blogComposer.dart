import 'package:flutter/material.dart';

class BlogComposer extends StatefulWidget {
  const BlogComposer({Key key}) : super(key: key);

  @override
  _BlogComposerState createState() => _BlogComposerState();
}

class _BlogComposerState extends State<BlogComposer> {
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
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {
                print("TEXT: $content");
                //upload
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(contentUpdater: updateComment),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  const ComposerComponent({this.contentUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Enter Name'),
        ),
      ),
      Expanded(
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
