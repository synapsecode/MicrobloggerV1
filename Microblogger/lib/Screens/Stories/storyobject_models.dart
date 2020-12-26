import 'dart:io';

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

enum ItemType { FileImage, Text }

class EditableItem {
  Offset position = Offset(0.1, 0.1);
  double scale = 1.0;
  double rotation = 0.0;
}

class TextItem extends EditableItem {
  Color textColor;
  Color backgroundColor;
  String value;
  ItemType type = ItemType.Text;

  final int id;

  TextItem({
    this.id,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.value = "Text",
  });
}

class ImageItem extends EditableItem {
  File value;
  final int id;
  double scale = 0.3;
  ItemType type = ItemType.FileImage;

  ImageItem({
    this.value,
    this.id,
  });
}
