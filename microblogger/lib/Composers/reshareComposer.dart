import 'package:microblogger/Backend/server.dart';
import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:microblogger/palette.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Components/Templates/postTemplates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReshareComposer extends StatefulWidget {
  final postObject;
  final Map preExistingState;
  final bool isEditing;
  ReshareComposer({this.preExistingState, this.isEditing, this.postObject});

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
      // backgroundColor: Colors.black87,
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
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  state['isFact'] = !state['isFact'];
                });
              },
              child: (state['isFact']) ? Text("Fact") : Text("Opinion"),
              style: ElevatedButton.styleFrom(
                primary: (state['isFact']) ? Colors.green : Colors.red,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    msg: "Resharing Post",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  String category = (state['isFact']) ? "Fact" : "Opinion";
                  await resharePost(widget.postObject['id'],
                      widget.postObject['type'], "ResharedWithComment",
                      content: state['content'], category: category);
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
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
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
              // margin: EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: CurrentPalette['border'],
                )),
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: HashTagEnabledUserTaggableTextField(
                        controller: contentController,
                        onChange: updateContent,
                        maxlines: 25,
                        hint: "What are your views regarding this?",
                      ),
                    )),
              ),
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
