import 'dart:io';

import 'package:MicroBlogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';

class CarouselComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  CarouselComposer({Key key, this.isEditing, this.preExistingState})
      : super(key: key);

  @override
  _CarouselComposerState createState() => _CarouselComposerState();
}

class _CarouselComposerState extends State<CarouselComposer> {
  Map state;

  @override
  void initState() {
    print("CarouselComposer: ${widget.preExistingState}");
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
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    msg: "Creating Carousel",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  await createCarousel(state['content'], state['images']);
                } else {
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    msg: "Updating Carousel",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  print("Updating Carousel");
                  if (state.containsKey('pid')) {
                    print("POST_ID: ${state['pid']}");
                    print("IMAGES: ${state['images']}");
                    print("CONTENT: ${state['content']}");
                    await editCarousel(
                        state['pid'], state['content'], state['images']);
                  }
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
                        "Images",
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
  TextEditingController contentController;
  @override
  void initState() {
    super.initState();
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
