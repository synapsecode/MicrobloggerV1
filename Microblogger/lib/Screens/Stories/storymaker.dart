import 'dart:ui';

import 'package:MicroBlogger/Backend/datastore.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/origin.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:video_player/video_player.dart';

var scr = new GlobalKey();

int cSelectedItemIndex;

var currentDraggedIndex;

class StoryMaker extends StatefulWidget {
  const StoryMaker({Key key}) : super(key: key);

  @override
  _StoryMakerState createState() => _StoryMakerState();
}

class _StoryMakerState extends State<StoryMaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Story Editor"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              RenderRepaintBoundary boundary =
                  scr.currentContext.findRenderObject();
              var image = await boundary.toImage();
              var byteData =
                  await image.toByteData(format: ImageByteFormat.png);
              var pngBytes = byteData.buffer.asUint8List();

              print("Recieved the PNG Bytes of the Story");
              print(pngBytes);

              //!warn or Use screenshot plugin
            },
          )
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: CurrentPalette['errorColor'],
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 170,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                color: Colors.grey[900],
                child: OrientationBuilder(builder: (context, orientation) {
                  return GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: <Widget>[
                      ActionButton(
                        'Image',
                        Icons.image,
                        () {
                          Navigator.of(context).pushNamed('/StoryMaker');
                        },
                        color: Colors.white,
                      ),
                      ActionButton(
                        'Text',
                        Icons.text_fields,
                        () {
                          int nid = mockData.last?.id ?? 0;
                          mockData.add(
                            (EditableItem()
                              ..type = ItemType.Text
                              ..value = 'Text'
                              ..id = nid + 1),
                          );
                          setState(() {});
                        },
                        color: Colors.white,
                      ),
                      ActionButton(
                        'Video',
                        Icons.video_call,
                        () {
                          Navigator.of(context).pushNamed('/MicroBlogComposer');
                        },
                        color: Colors.white,
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ),

      body: StoryEditor(),
      // body: Column(
      //   children: [
      //     Flexible(child: ),
      //     Container(
      //       width: double.infinity,
      //       height: 80.0,
      //       color: Colors.deepPurple,
      //     ),
      //   ],
      // ),
    );
  }
}

class StoryEditor extends StatefulWidget {
  StoryEditor({Key key}) : super(key: key);

  @override
  _StoryEditorState createState() => _StoryEditorState();
}

class _StoryEditorState extends State<StoryEditor> {
  EditableItem _activeItem;

  Offset _initPos;

  Offset _currentPos;

  double _currentScale;

  double _currentRotation;

  bool _inAction = false;

  Color backgroundColor = Colors.black;

  Color pickerColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: RepaintBoundary(
        key: scr,
        child: GestureDetector(
          onScaleStart: (details) {
            if (_activeItem == null) return;

            _initPos = details.focalPoint;
            _currentPos = _activeItem.position;
            _currentScale = _activeItem.scale;
            _currentRotation = _activeItem.rotation;
          },
          onScaleUpdate: (details) {
            if (_activeItem == null) return;
            final delta = details.focalPoint - _initPos;
            final left = (delta.dx / screen.width) + _currentPos.dx;
            final top = (delta.dy / screen.height) + _currentPos.dy;

            setState(() {
              _activeItem.position = Offset(left, top);
              _activeItem.rotation = details.rotation + _currentRotation;
              _activeItem.scale = details.scale * _currentScale;
            });
          },
          child: Stack(
            children: [
              // Positioned(
              //   bottom: 20.0,
              //   left: 40,
              //   child: Container(
              //     color: Colors.red,
              //     height: 40,
              //     width: 300,
              //   ),
              // ),

              InkWell(
                child: Container(color: backgroundColor),
                onLongPress: () {
                  print("Changing Background Color Dialog");

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: (color) =>
                              setState(() => pickerColor = color),
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Got it',
                            style: TextStyle(
                                color:
                                    Origin.of(context).isCurrentPaletteDarkTheme
                                        ? Colors.white
                                        : Colors.black),
                          ),
                          onPressed: () {
                            setState(() => backgroundColor = pickerColor);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );

                  // showBottomSheet(
                  //   context: context,
                  //   builder: (context) => Container(
                  //     height: 170,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                  //     color: Colors.grey[900],
                  //   ),
                  // );
                  // backgroundColor = backgroundColor == Colors.black
                  //     ? Colors.green
                  //     : Colors.black;
                  // setState(() {});
                },
              ),
              if (currentDraggedIndex != null)
                Positioned(
                  left: 10.0,
                  top: 10.0,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ...mockData.map(_buildItemWidget).toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(EditableItem e) {
    final screen = MediaQuery.of(context).size;

    var widget;
    switch (e.type) {
      case ItemType.Text:
        widget = Text(
          e.value,
          style: TextStyle(color: Colors.white),
        );
        break;
      case ItemType.Image:
        widget = Image.network(e.value);
    }

    return Positioned(
      top: e.position.dy * screen.height,
      left: e.position.dx * screen.width,
      child: Transform.scale(
        scale: e.scale,
        child: Transform.rotate(
          angle: e.rotation,
          child: Listener(
            onPointerDown: (details) {
              print("Dragging");
              if (_inAction) return;
              _inAction = true;
              currentDraggedIndex = e.id;
              _activeItem = e;

              _initPos = details.position;
              _currentPos = e.position;
              _currentScale = e.scale;
              _currentRotation = e.rotation;
            },
            onPointerUp: (PointerUpEvent details) {
              print("Drag End");

              print(details.position.dx / e.scale);
              // print()

              currentDraggedIndex = null;
              _inAction = false;
              setState(() {});
            },
            child: InkWell(
              onTap: () {
                String nval = e.value;
                cSelectedItemIndex = e.id;
                print("Clicked on Item, ${e.type}, id: ${e.id}");
                if (e.type == ItemType.Text) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        String cVal = e.value;
                        return StatefulBuilder(
                          builder: (context, setBuilderState) {
                            TextEditingController ctrl =
                                new TextEditingController(text: cVal);

                            ctrl.selection = TextSelection.fromPosition(
                                TextPosition(offset: ctrl.text.length));

                            return AlertDialog(
                              // title: Text(
                              //   'Edit Text',
                              // ),
                              content: Container(
                                height: 340.0,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("Text Preview"),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: CurrentPalette['border']),
                                          color: Colors.white10,
                                        ),
                                        child: Text(
                                          cVal,
                                        ),
                                      ),
                                      TextField(
                                        controller: ctrl,
                                        onChanged: (x) {
                                          setBuilderState(() {
                                            cVal = x;
                                            nval = x;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 10.0),
                                      Text("Text Preview"),
                                      SizedBox(height: 10.0),
                                      Container(
                                        height: 40,
                                        width: 250.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    CurrentPalette['border'])),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (int i = 0; i < 10; i++)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0),
                                                  child: CircleAvatar(
                                                    radius: 15.0,
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60.0),
                                        color: Colors.black,
                                        onPressed: () {},
                                        child: Text("Custom Colors"),
                                      ),
                                      RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60.0),
                                        color: CurrentPalette['errorColor'],
                                        onPressed: () {
                                          mockData.remove(e);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Text("Delete Element"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color:
                                            CurrentPalette['transparent_text']),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    if (nval == "") nval = "Text";
                                    print("New Value: $nval");

                                    mockData[mockData.indexOf(e)].value = nval;
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                        color:
                                            CurrentPalette['transparent_text']),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      });
                }
              },
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}

enum ItemType { Image, Text }

class EditableItem {
  Offset position = Offset(0.1, 0.1);
  double scale = 1.0;
  double rotation = 0.0;
  ItemType type;
  int id;
  String value;
}

final mockData = [
  EditableItem()
    ..type = ItemType.Image
    ..value =
        'https://cdn.pixabay.com/photo/2016/02/19/11/46/night-1209938_960_720.jpg'
    ..id = 0,
];
