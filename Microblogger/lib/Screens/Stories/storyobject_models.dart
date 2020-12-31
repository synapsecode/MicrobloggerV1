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

enum ItemType { FileImage, Text, DateTime, PostItem }

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

  Map get getJSONRepresentation {
    return {
      'type': "TextItem",
      'id': this.id,
      'value': this.value,
      'textColor': this.textColor.value,
      'backgroundColor': this.backgroundColor.value,
      'scale': this.scale,
      'rotation': this.rotation,
      'offset': [this.position.dx, this.position.dy]
    };
  }

  TextItem(
      {this.id,
      this.textColor = Colors.white,
      this.backgroundColor = Colors.transparent,
      this.value = "Text"});
}

class ImageItem extends EditableItem {
  File value;
  final int id;
  //Overrided
  double scale = 1.0;
  Offset position = Offset(0.1, 0.1);
  double opacity = 1.0;

  ItemType type = ItemType.FileImage;

  Map get getJSONRepresentation {
    return {
      'type': "ImageItem",
      'id': this.id,
      'value': this.value.path,
      'scale': this.scale,
      'rotation': this.rotation,
      'opacity': this.opacity,
      'offset': [this.position.dx, this.position.dy]
    };
  }

  ImageItem({
    this.value,
    this.id,
  });
}

class DateTimeItem extends EditableItem {
  final int id;
  final int hours;
  final int minutes;
  final String month;
  final int date;
  final String day;
  ItemType type = ItemType.DateTime;
  Color color;

  Map get getJSONRepresentation {
    return {
      'type': "DateTimeItem",
      'id': this.id,
      'value':
          "${this.month}-${this.day}-${this.date}-${this.hours}-${this.minutes}",
      'scale': this.scale,
      'rotation': this.rotation,
      'offset': [this.position.dx, this.position.dy],
      'color': this.color.value,
    };
  }

  DateTimeItem({
    this.id,
    this.hours,
    this.minutes,
    this.month,
    this.date,
    this.day,
    this.color,
  });
}

class PostStoryitem extends EditableItem {
  final int id;
  final Widget post;
  ItemType type = ItemType.PostItem;

  PostStoryitem({this.post, this.id});
}
