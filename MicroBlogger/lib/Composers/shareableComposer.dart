import 'package:flutter/material.dart';
import '../Backend/server.dart';

class ShareableComposer extends StatefulWidget {
  const ShareableComposer({Key key}) : super(key: key);

  @override
  _ShareableComposerState createState() => _ShareableComposerState();
}

class _ShareableComposerState extends State<ShareableComposer> {
  String content = "";
  String link = "";
  String name = "";

  void updateComment(x) {
    setState(() {
      content = x;
    });
  }

  void updateLink(x) {
    setState(() {
      link = x;
    });
  }

  void updateName(x) {
    setState(() {
      name = x;
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
              onPressed: () async {
                print(name);
                print(link);
                print(content);
                //upload
                await createShareable(content, name, link);
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(
        contentUpdater: updateComment,
        linkUpdater: updateLink,
        nameUpdater: updateName,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  final linkUpdater;
  final nameUpdater;
  const ComposerComponent(
      {this.contentUpdater, this.linkUpdater, this.nameUpdater});

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
            widget.nameUpdater(x);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Shareable Name',
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (x) {
            widget.linkUpdater(x);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Shareable Link',
          ),
        ),
      ),
      Expanded(
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                style: TextStyle(fontSize: 19.0),
                onChanged: (x) {
                  widget.contentUpdater("$x");
                },
                maxLines: 15,
                decoration: InputDecoration.collapsed(hintText: "Description"),
              ),
            )),
      ),
    ]);
  }
}
