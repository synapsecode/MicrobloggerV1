import 'dart:io';

import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Map state;

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    print("BLOGCOMPOSER: ${widget.preExistingState}");
    state = widget.preExistingState;
  }

  void updateContent(x) {
    setState(() {
      state['content'] = x;
    });
  }

  void blogNameUpdater(x) {
    setState(() {
      state['blogName'] = x;
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: RaisedButton(
                onPressed: () async {
                  print("Updating Blog");
                  Fluttertoast.showToast(
                    msg: "Updating Blog",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  if (widget.isEditing) {
                    if (state.containsKey('pid')) {
                      print("POST_ID: ${state['pid']}");
                      print("CONTENT: ${state['content']}");
                      print("BLOG_NAME: ${state['blogName']}");
                      print("COVER: ${state['cover']}");
                      await editBlog(state['pid'], state['content'],
                          state['blogName'], state['cover']);
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "Creating Blog",
                      backgroundColor: Color.fromARGB(200, 220, 20, 60),
                    );
                    await createBlog(state['content'], state['blogName'],
                        cover: state['cover']);
                  }
                  Navigator.pushNamed(context, '/HomePage');
                },
                child: (widget.isEditing) ?? (widget.isEditing)
                    ? Text("Update")
                    : Text("Publish"),
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () async {
                  print(state);
                  (widget.isEditing)
                      ? state.putIfAbsent('isEditing', () => true)
                      : state.putIfAbsent('isEditing', () => false);
                  print(state);
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
                contentUpdater: updateContent,
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
  TextEditingController nameController;
  TextEditingController contentController;
  @override
  void initState() {
    super.initState();
    nameController = new TextEditingController();
    contentController = new TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
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
            padding: EdgeInsets.all(8.0),
            child: HashTagEnabledUserTaggableTextField(
              controller: contentController,
              onChange: widget.contentUpdater,
              maxlines: 25,
            ),
          )),
    ]));
  }
}
