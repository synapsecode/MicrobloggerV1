import 'dart:io';
import 'package:MicroBlogger/Components/Global/tester.dart';
import 'package:MicroBlogger/Screens/Stories/components.dart';
import 'package:MicroBlogger/Screens/Stories/storyobject_models.dart';
import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:flutter/material.dart';

Widget getEditableStoryItem(BuildContext context, dynamic e) {
  Widget widget;
  switch (e.type) {
    case ItemType.Text:
      //?Add Font
      widget = Text(
        e.value,
        softWrap: true,
        style: TextStyle(
          color: e.textColor ?? Colors.white,
          backgroundColor: e.backgroundColor ?? Colors.transparent,
        ),
      );
      break;
    case ItemType.FileImage:
      widget = Opacity(
        opacity: e.opacity ?? 1.0,
        child: Image.file(
          e.value,
        ),
      );
      break;
    case ItemType.DateTime:
      widget = Container(
        child: Column(
          children: [
            Text(
              e.hours.toString().padLeft(2, "0"),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
                color: e.color,
              ),
            ),
            Container(
              child: Text(
                e.minutes.toString().padLeft(2, "0"),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 40,
                  color: e.color,
                ),
              ),
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
            ),
            Container(
              child: Text(
                "${e.day}, ${e.month} ${e.date}",
                style: TextStyle(
                  fontSize: 12,
                  color: e.color,
                ),
              ),
              transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            ),
          ],
        ),
      );
      break;
    case ItemType.PostItem:
      // print(e.post);
      widget =
          Container(child: e.post, width: MediaQuery.of(context).size.width);
      break;
    case ItemType.VideoItem:
      widget = Container(
        // width: 300,
        // height: 700,
        child: FileVideo(
          file: e.value,
          isMuted: e.muted,
        ),
      );
      break;
  }
  return widget;
}

Widget getRenderableStoryItem(BuildContext context, dynamic data) {
  Widget widget;
  switch (data['type']) {
    case 'TextItem':
      widget = Text(
        data['value'],
        // key: e.key,
        softWrap: true,
        style: TextStyle(
          color: Color(data['textColor']) ?? Colors.white,
          backgroundColor: Color(data['backgroundColor']) ?? Colors.transparent,
        ),
      );
      break;
    case 'ImageItem':
      //! Change this later to use Image.network
      widget = Opacity(
        opacity: data['opacity'],
        child: Image.file(
          File(data['value']),
        ),
      );
      break;
    case 'DateTimeItem':
      widget = Container(
        child: Column(
          children: [
            Text(
              data['value'].split('-')[3].toString().padLeft(2, "0"),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
                color: Color(data['color']),
              ),
            ),
            Container(
              child: Text(
                data['value'].split('-')[4].toString().padLeft(2, "0"),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w100,
                  color: Color(data['color']),
                ),
              ),
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
            ),
            Container(
              child: Text(
                "${data['value'].split('-')[1]}, ${data['value'].split('-')[0]} ${data['value'].split('-')[2]}",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(data['color']),
                ),
              ),
              transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            ),
          ],
        ),
      );
      break;
    case 'PostItem':
      widget = Container(
          child: feedBuilder(data['post']['type'], data['post']),
          width: MediaQuery.of(context).size.width);
      break;
    case 'VideoItem':
      //!Change to NetworkVideo
      widget = Container(
        // width: 300,
        // height: 700,
        child: FileVideo(
          file: File(data['value']),
          isMuted: data['muted'],
        ),
      );
      break;
  }
  return widget;
}
