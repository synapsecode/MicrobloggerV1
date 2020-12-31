import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';

class MicroBlogComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  const MicroBlogComposer({this.preExistingState, this.isEditing});

  @override
  _MicroBlogComposerState createState() => _MicroBlogComposerState();
}

class _MicroBlogComposerState extends State<MicroBlogComposer> {
  Map state;
  @override
  void initState() {
    super.initState();
    state = widget.preExistingState;
  }

  void updateComment(x) {
    setState(() {
      state['content'] = x;
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
              onPressed: () =>
                  setState(() => state['isFact'] = !state['isFact']),
              child: (state['isFact']) ? Text("Fact") : Text("Opinion"),
              color: (state['isFact']) ? Colors.green : Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                //upload
                String category = (state['isFact']) ? "Fact" : "Opinion";
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    msg: "Creating MicroBlog",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  await createMicroblog(state['content'], category);
                } else {
                  print("Updating MicroBlog");
                  Fluttertoast.showToast(
                    msg: "Updating MicroBlog",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  if (state.containsKey('pid')) {
                    print("POST_ID: ${state['pid']}");
                    print("CONTENT: ${state['content']}");
                    print(
                        "CATEGORY: ${(state['isFact']) ? 'Fact' : 'Opinion'}");
                    await editMicroblog(state['pid'], state['content'],
                        (state['isFact']) ? 'Fact' : 'Opinion');
                  }
                }
                //TODO: Navigate to Post
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text((widget.isEditing) ? "Update" : "Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(state, contentUpdater: updateComment),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  final Map state;
  const ComposerComponent(this.state, {this.contentUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  TextEditingController contentController;
  @override
  void initState() {
    super.initState();
    //checkConnection(context);
    contentController = new TextEditingController();
    contentController.text = widget.state['content'];
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
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
            color: CurrentPalette['border'],
          )),
          child: Card(
            elevation: 0,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: HashTagEnabledUserTaggableTextField(
                  controller: contentController,
                  onChange: widget.contentUpdater,
                  maxlines: 20,
                )),
          ),
        ),
      ]),
    );
  }
}
