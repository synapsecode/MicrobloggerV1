import 'package:flutter/material.dart';

/*
Impl
-> Text Color
-> Text Font
=-> New Edit Dialog
      -> Preview
      -> Color Palette


-> Images

-> Screenshot
*/

enum ItemType { Image, Text }

class EditableItem {
  Offset position = Offset(0.1, 0.1);
  double scale = 1.0;
  double rotation = 0.0;
}

class TextItem extends EditableItem {
  Color textColor;
  Color backgroundColor;
  String value;
  final int uid;
  TextItem(
    this.uid, {
    this.textColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.value = "Text",
  });
}
