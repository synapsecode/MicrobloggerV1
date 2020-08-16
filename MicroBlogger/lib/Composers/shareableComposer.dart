import 'package:flutter/material.dart';
import '../Backend/server.dart';

class ShareableComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  const ShareableComposer({this.preExistingState, this.isEditing, Key key})
      : super(key: key);

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
                print(state['name']);
                print(state['link']);
                print(state['content']);
                //upload
                if (!widget.isEditing) {
                  await createShareable(
                      state['content'], state['link'], state['name']);
                } else {
                  print("Editing Shareable");
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
  @override
  Widget build(BuildContext context) {
    var contentController = new TextEditingController();
    contentController.text = widget.state['content'];
    contentController.value = TextEditingValue(
      text: widget.state['content'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['content'].length),
      ),
    );
    var linkController = new TextEditingController();
    linkController.text = widget.state['link'];
    linkController.value = TextEditingValue(
      text: widget.state['link'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['link'].length),
      ),
    );
    var nameController = new TextEditingController();
    nameController.text = widget.state['name'];
    nameController.value = TextEditingValue(
      text: widget.state['name'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['name'].length),
      ),
    );
    return Column(children: [
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
      Expanded(
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: contentController,
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
