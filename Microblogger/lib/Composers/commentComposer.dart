import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';
import '../palette.dart';

class CommentComposer extends StatefulWidget {
  final post;
  final Map preExistingState;
  final bool isEditing;
  const CommentComposer({this.isEditing, this.preExistingState, this.post});

  @override
  _CommentComposerState createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  Map state;

  @override
  void initState() {
    super.initState();
    state = widget.preExistingState;
  }

  void updateComment(x) {
    setState(() {
      state['comment'] = x;
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
            child: ElevatedButton(
              onPressed: () =>
                  setState(() => state['isFact'] = !state['isFact']),
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
                String category = (state['isFact']) ? "Fact" : "Opinion";
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    msg: "Adding Comment",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  await addCommentToPost(widget.post['id'], widget.post['type'],
                      state['comment'], category);
                } else {
                  print("Updating Comment");
                  Fluttertoast.showToast(
                    msg: "Updating Comment",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  if (state.containsKey('cid')) {
                    print("POST_ID: ${state['cid']}");
                    print("COMMENT: ${state['comment']}");
                    print(
                        "CATEGORY: ${(state['isFact']) ? 'Fact' : 'Opinion'}");
                    await editComment(state['cid'], state['comment'],
                        (state['isFact']) ? 'Fact' : 'Opinion');
                  }
                }
                //upload
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text((widget.isEditing) ? "Update Comment" : "Publish"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: ComposerComponent(
        state,
        commentUpdater: updateComment,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final commentUpdater;
  final Map state;
  const ComposerComponent(this.state, {this.commentUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  TextEditingController commentController;
  @override
  void initState() {
    super.initState();
    checkConnection(context);
    commentController = new TextEditingController();
    commentController.text = widget.state['comment'];
    commentController.value = TextEditingValue(
      text: widget.state['comment'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['comment'].length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
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
                  controller: commentController,
                  onChange: widget.commentUpdater,
                  maxlines: 25,
                  hint: "What's your reply?",
                ),
              ),
            )),
        // Expanded(
        //   child: Card(
        //       color: Colors.black12,
        //       child: Padding(
        //         padding: EdgeInsets.all(12.0),
        //         child: TextField(
        //           controller: commentController,
        //           onChanged: (x) {
        //             widget.commentUpdater("$x");
        //           },
        //           maxLines: 45,
        //           style: TextStyle(fontSize: 19.0),
        //           decoration:
        //               InputDecoration.collapsed(hintText: "Start Commenting"),
        //         ),
        //       )),
        // ),
      ]),
    );
  }
}
