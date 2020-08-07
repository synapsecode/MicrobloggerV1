import 'package:flutter/material.dart';
import '../Backend/server.dart';

class CommentComposer extends StatefulWidget {
  final post;
  const CommentComposer({Key key, this.post}) : super(key: key);

  @override
  _CommentComposerState createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  String commentContent = "";
  bool isFact = false;

  void updateComment(x) {
    setState(() {
      commentContent = x;
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
              onPressed: () async {
                print(widget.post);
                print(isFact);
                print(commentContent);
                String category = (isFact) ? "Fact" : "Opinion";
                await addCommentToPost(widget.post['id'], widget.post['type'],
                    commentContent, category);
                //upload
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(
        commentUpdater: updateComment,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final commentUpdater;
  const ComposerComponent({this.commentUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (x) {
                  widget.commentUpdater("$x");
                },
                maxLines: 45,
                style: TextStyle(fontSize: 19.0),
                decoration:
                    InputDecoration.collapsed(hintText: "Start Commenting"),
              ),
            )),
      ),
    ]);
  }
}
