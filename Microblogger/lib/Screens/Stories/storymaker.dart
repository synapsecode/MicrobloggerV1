import 'dart:io';
import 'dart:ui';

import 'package:MicroBlogger/Backend/datastore.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Screens/Stories/components.dart';
import 'package:MicroBlogger/Screens/Stories/dialogs.dart';
import 'package:MicroBlogger/Screens/Stories/renderer.dart';
import 'package:MicroBlogger/Screens/Stories/story_items.dart';
import 'package:MicroBlogger/Screens/Stories/storyobject_models.dart';
import 'package:MicroBlogger/origin.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

var scr = new GlobalKey();

int cSelectedItemIndex;
Color bgCol = Colors.black;
var currentDraggedIndex;

List<dynamic> storyItems = [];

class StoryMaker extends StatefulWidget {
  const StoryMaker();

  @override
  _StoryMakerState createState() => _StoryMakerState();
}

class _StoryMakerState extends State<StoryMaker> {
  @override
  void initState() {
    // if (widget.post != null) {
    //   var postObj = PostStoryitem(id: 0, post: widget.post);
    //   storyItems.add(postObj);
    // }

    super.initState();
  }

  @override
  void dispose() {
    storyItems = [];
    bgCol = Colors.black;
    super.dispose();
  }

  File _image;

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
              Map tree = {
                'BackgroundColor': bgCol.value,
                'Elements':
                    storyItems.map((e) => e.getJSONRepresentation).toList()
              };
              print(tree);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StoryRenderer(
                    data: tree,
                  ),
                ),
              );
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
                height: 270,
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
                          showAddImageDialog(
                            context: context,
                            img: _image,
                            imageSetter: (img) => setState(() => _image = img),
                            setState: setState,
                          );
                          setState(() => _image = null);
                        },
                        color: Colors.white,
                      ),
                      ActionButton(
                        'Text',
                        Icons.text_fields,
                        () {
                          int nid =
                              (storyItems.length > 0) ? storyItems.last.id : 0;
                          storyItems.add(
                            TextItem(
                              id: nid + 1,
                              value: "Text",
                            ),
                          );
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                      ),
                      ActionButton(
                        'DateTime',
                        Icons.timer,
                        () {
                          int nid =
                              (storyItems.length > 0) ? storyItems.last.id : 0;
                          DateTime now = new DateTime.now();
                          storyItems.add(
                            DateTimeItem(
                              id: nid + 1,
                              minutes: now.minute,
                              hours: now.hour,
                              date: now.day,
                              day: getWeekDay(now.weekday),
                              month: getMonth(now.month),
                              color: Colors.white,
                            ),
                          );
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                      ),
                      ActionButton(
                        'Video',
                        Icons.video_call,
                        () {},
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
    );
  }
}

class StoryEditor extends StatefulWidget {
  StoryEditor();

  @override
  _StoryEditorState createState() => _StoryEditorState();
}

class _StoryEditorState extends State<StoryEditor> {
  dynamic _activeItem;

  Offset _initPos;

  Offset _currentPos;

  double _currentScale;

  double _currentRotation;

  bool _inAction = false;

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
              InkWell(
                child: Container(color: bgCol),
                onTap: () {
                  int nid = (storyItems.length > 0) ? storyItems.last.id : 0;
                  storyItems.add(
                    TextItem(
                      id: nid + 1,
                      value: "Text",
                    ),
                  );
                  setState(() {});
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => ColorPickerDialog(
                      startColor: bgCol,
                      onColorSelected: (color) => setState(() => bgCol = color),
                      dialogHeading: "Background Color",
                    ),
                  );
                },
              ),
              ...storyItems.map(_buildItemWidget).toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(dynamic e) {
    final screen = MediaQuery.of(context).size;

    Widget widget = getEditableStoryItem(context, e);

    Widget StoryItemControllerWidget(
        {Function editHandler, Widget child, Function longHandler}) {
      return Positioned(
        top: e.position.dy * screen.height,
        left: e.position.dx * screen.width,
        child: Transform.scale(
          scale: e.scale,
          child: Transform.rotate(
            angle: e.rotation,
            child: Listener(
              onPointerDown: (details) {
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
                currentDraggedIndex = null;
                _inAction = false;
                setState(() {});
              },
              child: InkWell(
                onLongPress: () => longHandler(),
                onTap: () => editHandler(),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return StoryItemControllerWidget(
        editHandler: () {
          cSelectedItemIndex = e.id;
          print("Clicked on Item, ${e.type}, id: ${e.id}");
          if (e.type == ItemType.Text) {
            showTextEditDialog(
              context: context,
              nval: e.value,
              e: e,
              setState: setState,
            );
          } else if (e.type == ItemType.FileImage) {
            showImageEditDialog(
              context: context,
              e: e,
              setState: setState,
            );
          } else if (e.type == ItemType.DateTime) {
            showDateTimeEditDialog(
              context: context,
              e: e,
              setState: setState,
            );
          }
        },
        child: widget,
        longHandler: () {
          if (e.type == ItemType.PostItem) {
            showPostEditDialog(
              context: context,
              e: e,
              setState: setState,
            );
          }
        });
  }
}

String getWeekDay(int d) {
  return (d == 1)
      ? "Mon"
      : (d == 2)
          ? "Tue"
          : (d == 3)
              ? "Wed"
              : (d == 4)
                  ? "Thu"
                  : (d == 5)
                      ? "Fri"
                      : (d == 6)
                          ? "Sat"
                          : (d == 7)
                              ? "Sun"
                              : "Day";
}

String getMonth(int m) {
  return (m == 1)
      ? "Jan"
      : (m == 2)
          ? "Feb"
          : (m == 3)
              ? "Mar"
              : (m == 4)
                  ? "Apr"
                  : (m == 5)
                      ? "May"
                      : (m == 6)
                          ? "Jun"
                          : (m == 7)
                              ? "July"
                              : (m == 8)
                                  ? "Aug"
                                  : (m == 9)
                                      ? "Sep"
                                      : (m == 10)
                                          ? "Oct"
                                          : (m == 11)
                                              ? "Nov"
                                              : "Dec";
}
