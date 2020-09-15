import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Components/Templates/postTemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReshareComposer extends StatefulWidget {
  final postObject;
  final Map preExistingState;
  final bool isEditing;
  ReshareComposer(
      {this.preExistingState, this.isEditing, Key key, this.postObject})
      : super(key: key);

  @override
  _ReshareComposerState createState() => _ReshareComposerState();
}

class _ReshareComposerState extends State<ReshareComposer> {
  String postType;
  Widget post = Container();
  Map state;
  TextEditingController contentController;
  @override
  void initState() {
    super.initState();
    checkConnection(context);
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
      case "carousel":
        post = CarouselPost(postObject: widget.postObject);
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
    state = widget.preExistingState;
    contentController = new TextEditingController();
    contentController.text = state['content'];
    contentController.value = TextEditingValue(
      text: state['content'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: state['content'].length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void updateContent(x) {
      setState(() {
        state['content'] = x;
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
                  state['isFact'] = !state['isFact'];
                });
              },
              child: (state['isFact']) ? Text("Fact") : Text("Opinion"),
              color: (state['isFact']) ? Colors.green : Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                if (!widget.isEditing) {
                  String category = (state['isFact']) ? "Fact" : "Opinion";
                  await resharePost(widget.postObject['id'],
                      widget.postObject['type'], "ResharedWithComment",
                      content: state['content'], category: category);
                  Fluttertoast.showToast(
                    msg: "Reshared Post",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Updadting Post",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  print("Updating RWC");
                  if (state.containsKey('pid')) {
                    print("POST_ID: ${state['pid']}");
                    print("CONTENT: ${state['content']}");
                    print(
                        "CATEGORY: ${(state['isFact']) ? 'Fact' : 'Opinion'}");
                    editResharedWithComment(state['pid'], state['content'],
                        (state['isFact']) ? 'Fact' : 'Opinion');
                  }
                }
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text((widget.isEditing) ? "Update" : "Publish"),
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
                  color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: HashTagEnabledUserTaggableTextField(
                      controller: contentController,
                      onChange: updateContent,
                      maxlines: 25,
                      hint: "What are your views regarding this?",
                    ),
                  )),

              //  Card(
              //     color: Colors.white10,
              //     child: Padding(
              //       padding: EdgeInsets.all(12.0),
              //       child: TextField(
              //         controller: contentController,
              //         onChanged: (x) {
              //           updateContent(x);
              //         },
              //         maxLines: 25,
              //         style: TextStyle(fontSize: 19.0),
              //         decoration: InputDecoration.collapsed(
              //             hintText: "What are your views regarding this?"),
              //       ),
              //     )),
            ),
          ],
        ),
      ),
    );
  }
}
