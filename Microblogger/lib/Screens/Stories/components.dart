import 'dart:io';

import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/origin.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ColorPalette extends StatelessWidget {
  final Function(Color) stateChanger;

  const ColorPalette({this.stateChanger});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 250.0,
      decoration:
          BoxDecoration(border: Border.all(color: CurrentPalette['border'])),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ColorDot(
              color: Colors.white,
              onPress: (color) => stateChanger(color),
            ),
            ColorDot(
              color: Colors.black,
              onPress: (color) => stateChanger(color),
            ),
            ColorDot(
              color: Colors.green,
              onPress: (color) => stateChanger(color),
            ),
            ColorDot(
              color: Colors.blue,
              onPress: (color) => stateChanger(color),
            ),
            ColorDot(
              color: Colors.red,
              onPress: (color) => stateChanger(color),
            ),
            ColorDot(
              color: Colors.yellow,
              onPress: (color) => stateChanger(color),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final Function(Color) onPress;
  const ColorDot({
    this.color,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(color),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: CircleAvatar(
          radius: 15.0,
          backgroundColor: color,
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color startColor;
  final String dialogHeading;
  ColorPickerDialog(
      {this.onColorSelected, this.dialogHeading, this.startColor});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickerColor = Colors.black;
  @override
  void initState() {
    pickerColor = widget.startColor ?? Colors.black;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogHeading),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (color) => setState(() => pickerColor = color),
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Origin.of(context).isCurrentPaletteDarkTheme
                    ? Colors.white
                    : Colors.black),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            'Done',
            style: TextStyle(
                color: Origin.of(context).isCurrentPaletteDarkTheme
                    ? Colors.white
                    : Colors.black),
          ),
          onPressed: () {
            widget.onColorSelected(pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class CustomAlertDialogScaffold extends StatelessWidget {
  final String title;
  final double height;
  final List<Widget> children;
  final Function onDone;
  const CustomAlertDialogScaffold(
      {this.title, this.height, this.children, this.onDone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(children: children),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: CurrentPalette['transparent_text'],
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            onDone();
            Navigator.pop(context);
          },
          child: Text(
            'Done',
            style: TextStyle(
              color: CurrentPalette['transparent_text'],
            ),
          ),
        ),
      ],
    );
  }
}

class FileVideo extends StatefulWidget {
  final File file;
  final bool isMuted;
  const FileVideo({this.file, this.isMuted = false});

  @override
  _FileVideoState createState() => _FileVideoState();
}

class _FileVideoState extends State<FileVideo> {
  final picker = ImagePicker();

  VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play()
      ..setVolume(widget.isMuted ? 0 : 1);
    super.initState();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setVolume(widget.isMuted ? 0 : 1);
    return Container(
      child: _controller.value.initialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller.value.size.height,
                width: _controller.value.size.width,
                child: VideoPlayer(_controller),
              ),
            )
          : Column(
              children: [
                CirclularLoader(
                  color: Colors.white30,
                  strokeWidth: 2,
                ),
                Container(
                  child: Text(
                    "Loading Video",
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 12,
                    ),
                  ),
                  transform: Matrix4.translationValues(0.0, -13.0, 0.0),
                ),
              ],
            ),
    );
  }
}

class NetworkVideo extends StatefulWidget {
  final String url;
  final bool isMuted;
  const NetworkVideo({this.url, this.isMuted = false});

  @override
  _NetworkVideoState createState() => _NetworkVideoState();
}

class _NetworkVideoState extends State<NetworkVideo> {
  final picker = ImagePicker();

  VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();

    super.initState();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setVolume(widget.isMuted ? 0 : 1);
    return Container(
      child: _controller.value.initialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller.value.size.height,
                width: _controller.value.size.width,
                child: VideoPlayer(_controller),
              ),
            )
          : Column(
              children: [
                CirclularLoader(
                  color: Colors.white30,
                  strokeWidth: 2,
                ),
                Container(
                  child: Text(
                    "Loading Video",
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 12,
                    ),
                  ),
                  transform: Matrix4.translationValues(0.0, -13.0, 0.0),
                ),
              ],
            ),
    );
  }
}
