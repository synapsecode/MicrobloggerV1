import 'package:MicroBlogger/origin.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPalette extends StatelessWidget {
  final Function(Color) stateChanger;

  const ColorPalette({Key key, this.stateChanger}) : super(key: key);

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
    Key key,
    this.color,
    this.onPress,
  }) : super(key: key);

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
      {Key key, this.onColorSelected, this.dialogHeading, this.startColor})
      : super(key: key);

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
      {Key key, this.title, this.height, this.children, this.onDone});

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
