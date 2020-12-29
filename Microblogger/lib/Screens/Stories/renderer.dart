import 'dart:io';

import 'package:MicroBlogger/Screens/Stories/storyobject_models.dart';
import 'package:flutter/material.dart';

class StoryRenderer extends StatefulWidget {
  final Map serializedTree;
  final Map data;
  StoryRenderer({Key key, this.serializedTree, this.data}) : super(key: key);

  @override
  _StoryRendererState createState() => _StoryRendererState();
}

class _StoryRendererState extends State<StoryRenderer> {
  Widget storyItemBuilder(dynamic e) {
    final screen = MediaQuery.of(context).size;
    Widget widget;
    switch (e['type']) {
      case 'TextItem':
        widget = Text(
          e['value'],
          // key: e.key,
          softWrap: true,
          style: TextStyle(
            color: Color(e['textColor']) ?? Colors.white,
            backgroundColor: Color(e['backgroundColor']) ?? Colors.transparent,
          ),
        );
        break;
      case 'ImageItem':
        //! Change this later to use Image.network
        widget = Opacity(
          opacity: e['opacity'],
          child: Image.file(
            File(e['value']),
            // key: e.key,
          ),
        );
        break;
    }

    return Positioned(
      top: e['offset'][1] * screen.height,
      left: e['offset'][0] * screen.width,
      child: Transform.scale(
        scale: e['scale'],
        child: Transform.rotate(
          angle: e['rotation'],
          child: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.sTre['Background']['bgCol']);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.data['BackgroundColor']),
        title: Text("Story Renderer"),
      ),
      body: Stack(
        children: [
          Container(
            // constraints: BoxConstraints.expand(),
            color: Color(widget.data['BackgroundColor']),
          ),
          ...widget.data['Elements'].map(storyItemBuilder).toList()
        ],
      ),
    );
  }
}
