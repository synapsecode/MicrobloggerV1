import 'dart:io';

import 'package:microblogger/Screens/Stories/components.dart';
import 'package:microblogger/Screens/Stories/story_items.dart';
import 'package:microblogger/Screens/Stories/storymaker.dart';
import 'package:microblogger/Screens/Stories/storyobject_models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../palette.dart';

void showAddImageDialog({
  BuildContext context,
  Function(File) imageSetter,
  Function setState,
  File img,
}) {
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    img = image;
    imageSetter(image);
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    img = image;
    imageSetter(image);
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _imgFromCamera();
                  if (img != null) {
                    int nid = 0;
                    if (storyItems.length > 0) {
                      nid = storyItems.last.id;
                    }
                    storyItems.add(
                      ImageItem(
                        id: nid + 1,
                        value: img,
                      ),
                    );
                  }
                  setState(() {
                    img = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text(
                  'Photo Library',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _imgFromGallery();
                  if (img != null) {
                    int nid = (storyItems.length > 0) ? storyItems.last.id : 0;
                    storyItems.add(
                      ImageItem(
                        id: nid + 1,
                        value: img,
                      ),
                    );
                  }
                  setState(() {
                    img = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showTextEditDialog({
  BuildContext context,
  dynamic e,
  Function setState,
  String nval,
}) {
  showDialog(
      context: context,
      builder: (context) {
        String cVal = e.value;
        Color tColor = e.textColor ?? Colors.white;
        Color bColor = e.backgroundColor ?? Colors.transparent;
        return StatefulBuilder(
          builder: (context, setBuilderState) {
            TextEditingController ctrl = new TextEditingController(text: cVal);

            ctrl.selection = TextSelection.fromPosition(
                TextPosition(offset: ctrl.text.length));

            return CustomAlertDialogScaffold(
              height: 510,
              title: "Edit Text",
              children: [
                Text("Text Preview"),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CurrentPalette['border'],
                    ),
                    color: Colors.white10,
                  ),
                  child: Text(
                    cVal,
                    style: TextStyle(
                      color: tColor,
                      backgroundColor: bColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CurrentPalette['border'],
                      ),
                    ),
                  ),
                  maxLines: 3,
                  controller: ctrl,
                  onChanged: (x) {
                    setBuilderState(() {
                      cVal = x;
                      nval = x;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    primary: Colors.yellow,
                  ),
                  onPressed: () {
                    storyItems.remove(e);
                    storyItems.add(e);
                  },
                  child: Text("Bring to Front"),
                ),
                SizedBox(height: 5),
                Text("Text Colors"),
                SizedBox(height: 10.0),
                ColorPalette(
                  stateChanger: (color) =>
                      setBuilderState(() => tColor = color),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(
                        startColor: tColor,
                        onColorSelected: (color) =>
                            setBuilderState(() => tColor = color),
                        dialogHeading: "Custom Text Color",
                      ),
                    );
                  },
                  child: Text("Custom Text Color"),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30.0,
                    ),
                    Text("Background Color"),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setBuilderState(() => bColor = Colors.transparent);
                      },
                    )
                  ],
                ),
                // SizedBox(height: 5.0),
                ColorPalette(
                  stateChanger: (color) =>
                      setBuilderState(() => bColor = color),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(
                        startColor: bColor,
                        onColorSelected: (color) =>
                            setBuilderState(() => bColor = color),
                        dialogHeading: "Custom Background Color",
                      ),
                    );
                  },
                  child: Text("Custom Background Color"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    primary: CurrentPalette['errorColor'],
                  ),
                  onPressed: () {
                    storyItems.remove(e);

                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Delete Element"),
                ),
              ],
              onDone: () {
                if (nval == "") nval = "Text";
                var x = storyItems[storyItems.indexOf(e)];
                x.value = nval;
                x.backgroundColor = bColor;
                x.textColor = tColor;
                setState(() {});
              },
            );
          },
        );
      });
}

void showImageEditDialog({BuildContext context, Function setState, dynamic e}) {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setBuilderState) {
        double op = e.opacity;

        return CustomAlertDialogScaffold(
          title: "Edit Image",
          height: 200,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 65.0),
                primary: Colors.yellow,
              ),
              onPressed: () {
                storyItems.remove(e);
                storyItems.add(e);
                setState(() {});
              },
              child: Text("Bring to Front"),
            ),
            SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                primary: CurrentPalette['errorColor'],
              ),
              onPressed: () {
                storyItems.remove(e);

                setState(() {});
                Navigator.pop(context);
              },
              child: Text("Delete Element"),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text("Opacity"),
            Slider(
              min: 0,
              max: 1,
              value: op,
              onChanged: (x) {
                setState(() => e.opacity = x);
                setBuilderState(() => op = x);
              },
            )
          ],
          onDone: () {},
        );
      },
    ),
  );
}

void showDateTimeEditDialog(
    {BuildContext context, Function setState, dynamic e}) {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setBuilderState) {
        Color tColor;
        return CustomAlertDialogScaffold(
          title: "Edit DateTime",
          height: 370,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  color: CurrentPalette['border'],
                ),
              ),
              child: getEditableStoryItem(context, e),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 65.0),
                primary: Colors.yellow,
              ),
              onPressed: () {
                storyItems.remove(e);
                storyItems.add(e);
                setState(() {});
              },
              child: Text("Bring to Front"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                primary: CurrentPalette['errorColor'],
              ),
              onPressed: () {
                storyItems.remove(e);

                setState(() {});
                Navigator.pop(context);
              },
              child: Text("Delete Element"),
            ),
            SizedBox(height: 10),
            Text("Text Colors"),
            SizedBox(height: 10.0),
            ColorPalette(
              stateChanger: (color) {
                setBuilderState(() => tColor = color);
                setState(() => e.color = tColor);
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 28.0),
                primary: Colors.black,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ColorPickerDialog(
                    startColor: tColor,
                    onColorSelected: (color) {
                      setBuilderState(() => tColor = color);
                      setState(() => e.color = tColor);
                    },
                    dialogHeading: "Custom Background Color",
                  ),
                );
              },
              child: Text("Custom Background Color"),
            ),
          ],
          onDone: () {},
        );
      },
    ),
  );
}

void showPostEditDialog({BuildContext context, Function setState, dynamic e}) {
  showDialog(
    context: context,
    builder: (context) => CustomAlertDialogScaffold(
      title: "Edit Post",
      height: 100,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 65.0),
            primary: Colors.yellow,
          ),
          onPressed: () {
            storyItems.remove(e);
            storyItems.add(e);
            setState(() {});
          },
          child: Text("Bring to Front"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            primary: CurrentPalette['errorColor'],
          ),
          onPressed: () {
            storyItems.remove(e);

            setState(() {});
            Navigator.pop(context);
          },
          child: Text("Delete Element"),
        ),
      ],
      onDone: () {},
    ),
  );
}

void showVideoEditDialog({BuildContext context, Function setState, dynamic e}) {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setBuilderState) {
        return CustomAlertDialogScaffold(
          title: "Edit Video",
          height: 160,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 65.0),
                primary: Colors.yellow,
              ),
              onPressed: () {
                storyItems.remove(e);
                storyItems.add(e);
                setState(() {});
              },
              child: Text("Bring to Front"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 70.0),
                primary: Colors.yellow,
              ),
              onPressed: () {
                setState(() {
                  e.muted = !e.muted;
                });
                setBuilderState(() {});
              },
              child: Text("${e.muted ? 'Unmute' : 'Mute'} Video"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                primary: CurrentPalette['errorColor'],
              ),
              onPressed: () {
                storyItems.remove(e);

                setState(() {});
                Navigator.pop(context);
              },
              child: Text("Delete Element"),
            ),
          ],
          onDone: () {},
        );
      },
    ),
  );
}

void showAddVideoDialog({
  BuildContext context,
  Function(File) videoSetter,
  Function setState,
  File vid,
}) {
  final picker = ImagePicker();

  // This funcion will helps you to pick a Video File
  _pickGalleryVideo() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
    vid = File(pickedFile.path);
    videoSetter(File(pickedFile.path));
  }

  _pickVideoFromCamera() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);
    vid = File(pickedFile.path);
    videoSetter(File(pickedFile.path));
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _pickVideoFromCamera();
                  if (vid != null) {
                    int nid = (storyItems.length > 0) ? storyItems.last.id : 0;
                    storyItems.add(
                      VideoItem(
                        id: nid + 1,
                        value: vid,
                      ),
                    );
                  }
                  setState(() {
                    vid = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _pickGalleryVideo();
                  if (vid != null) {
                    int nid = (storyItems.length > 0) ? storyItems.last.id : 0;
                    storyItems.add(
                      VideoItem(
                        id: nid + 1,
                        value: vid,
                      ),
                    );
                  }
                  setState(() {
                    vid = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
