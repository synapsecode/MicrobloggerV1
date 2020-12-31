import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';
import '../palette.dart';

class ShareableComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  const ShareableComposer({
    this.preExistingState,
    this.isEditing,
  });

  @override
  _ShareableComposerState createState() => _ShareableComposerState();
}

class _ShareableComposerState extends State<ShareableComposer> {
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

  void updateLink(x) {
    setState(() {
      state['link'] = x;
    });
  }

  void updateName(x) {
    setState(() {
      state['name'] = x;
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
                //upload
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    msg: "Creating Shareable",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  await createShareable(
                      state['content'], state['name'], state['link']);
                } else {
                  print("Updating Shareable");
                  Fluttertoast.showToast(
                    msg: "Updating Shareable",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  if (state.containsKey('pid')) {
                    print("POST_ID: ${state['pid']}");
                    print("NAME: ${state['name']}");
                    print("LINK: ${state['link']}");
                    print("CONTENT: ${state['content']}");
                    await editShareable(state['pid'], state['content'],
                        state['link'], state['name']);
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
      body: ComposerComponent(
        state,
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
  final Map state;
  const ComposerComponent(this.state,
      {this.contentUpdater, this.linkUpdater, this.nameUpdater});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  TextEditingController contentController;
  TextEditingController nameController;
  TextEditingController linkController;
  @override
  void initState() {
    super.initState();
    checkConnection(context);
    contentController = new TextEditingController();
    contentController.text = widget.state['content'];
    contentController.value = TextEditingValue(
      text: widget.state['content'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['content'].length),
      ),
    );

    linkController = new TextEditingController();
    linkController.text = widget.state['link'];
    linkController.value = TextEditingValue(
      text: widget.state['link'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['link'].length),
      ),
    );

    nameController = new TextEditingController();
    nameController.text = widget.state['name'];
    nameController.value = TextEditingValue(
      text: widget.state['name'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['name'].length),
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
            controller: nameController,
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
            controller: linkController,
            onChanged: (x) {
              widget.linkUpdater(x);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Shareable Link',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
            color: CurrentPalette['border'],
          )),
          child: Card(
            // color: Colors.black12,
            elevation: 0,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: HashTagEnabledUserTaggableTextField(
                  controller: contentController,
                  onChange: widget.contentUpdater,
                  maxlines: 21,
                )),
          ),
        ),
      ]),
    );
  }
}
