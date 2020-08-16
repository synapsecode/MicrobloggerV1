import 'dart:io';

import 'package:MicroBlogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';

class MediaComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  MediaComposer({Key key, this.isEditing, this.preExistingState})
      : super(key: key);

  @override
  _MediaComposerState createState() => _MediaComposerState();
}

class _MediaComposerState extends State<MediaComposer> {
  Map state;

  @override
  void initState() {
    print("MediaComposer: ${widget.preExistingState}");
    state = widget.preExistingState;
    super.initState();
    print(state);
  }

  void updateContent(x) {
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
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                Fluttertoast.showToast(
                  toastLength: Toast.LENGTH_LONG,
                  msg: "Creating Carousel",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
                print(state['content']);
                print(state['images']);
                if (!widget.isEditing) {
                  await createCarousel(state['content'], state['images']);
                } else {
                  print("Updating Carousel");
                }

                Navigator.pushNamed(context, '/HomePage');
                //upload
              },
              child: Text((widget.isEditing) ? "Update" : "Publish"),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ComposerComponent(
                state,
                contentUpdater: updateContent,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                    color: Colors.black26,
                    child: Text(
                      "Add Image",
                      style: TextStyle(color: Colors.white),
                    ),
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
                                  imageFor: 'CAROUSEL',
                                  preExistingState: state)));
                    },
                  ),
                ),
              ),
              if (state['images'].length > -1) ...[
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Media",
                        style: TextStyle(fontSize: 40.0, color: Colors.white24),
                      ),
                      ListView.builder(
                          itemCount: state['images'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0, color: Colors.white30)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: SizedBox(
                                          child: Image(
                                        image: NetworkImage(
                                            state['images'][index]),
                                      )),
                                    ),
                                    Positioned(
                                        top: 5.0,
                                        right: 5.0,
                                        child: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            print(index);
                                            setState(() {
                                              state['images'].removeAt(index);
                                            });
                                          },
                                        )),
                                  ],
                                ));
                          })
                    ],
                  ),
                ),
              ]
            ]),
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final state;
  final contentUpdater;
  const ComposerComponent(this.state, {this.contentUpdater});

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
    return Column(children: [
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
              maxLines: 15,
              decoration: InputDecoration.collapsed(
                  hintText: "Start Describing the Images!"),
            ),
          )),
    ]);
  }
}
