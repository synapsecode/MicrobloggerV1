import 'dart:io';

import 'package:MicroBlogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import '../Backend/server.dart';

class BlogComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  BlogComposer({this.isEditing, Key key, this.preExistingState})
      : super(key: key);

  @override
  _BlogComposerState createState() => _BlogComposerState();
}

class _BlogComposerState extends State<BlogComposer> {
  String content;
  String blogName;
  String cover;
  Map state;

  @override
  void initState() {
    print("BLOGCOMPOSER: ${widget.preExistingState}");
    state = widget.preExistingState;
    super.initState();
  }

  void updateComment(x) {
    setState(() {
      content = x;
      state['content'] = x;
    });
  }

  void blogNameUpdater(x) {
    setState(() {
      blogName = x;
      state['blogName'] = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    content = state['content'];
    blogName = state['blogName'];
    cover = state['cover'];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: RaisedButton(
                onPressed: () async {
                  print(blogName);
                  print(content);
                  print(cover);
                  if (widget.isEditing) {
                    print("Updated the blog!");
                  } else {
                    await createBlog(content, blogName, cover: cover);
                  }
                  Navigator.pushNamed(context, '/HomePage');
                  //upload
                },
                child: (widget.isEditing) ? Text("Update") : Text("Publish"),
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () async {
                  print("OLD: $state");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageCapture(
                                imageFor: 'BLOGCOVER',
                                preExistingState: state,
                              )));
                  print("NEW: $state");
                },
                child: Text((widget.isEditing)
                    ? "Edit Cover Image"
                    : "Add Cover Image"),
                color: Color.fromARGB(200, 220, 20, 60),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black12,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ComposerComponent(
                state,
                contentUpdater: updateComment,
                blogNameUpdater: blogNameUpdater,
              ),
            ]),
          ),
        ));
  }
}

class ComposerComponent extends StatefulWidget {
  final state;
  final contentUpdater;
  final blogNameUpdater;
  const ComposerComponent(this.state,
      {this.contentUpdater, this.blogNameUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    var nameController = new TextEditingController();
    var contentController = new TextEditingController();
    contentController.text = widget.state['content'];
    nameController.value = TextEditingValue(
      text: widget.state['blogName'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['blogName'].length),
      ),
    );
    contentController.value = TextEditingValue(
      text: widget.state['content'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['content'].length),
      ),
    );
    return Column(children: [
      Container(
        padding: EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (x) {
            widget.blogNameUpdater("$x");
          },
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Blog Name',
          ),
        ),
      ),
      Card(
          color: Colors.black12,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: contentController,
              style: TextStyle(fontSize: 19.0),
              onChanged: (x) {
                widget.contentUpdater("$x");
              },
              maxLines: 45,
              decoration:
                  InputDecoration.collapsed(hintText: "Start Blogging!"),
            ),
          )),
    ]);
  }
}
