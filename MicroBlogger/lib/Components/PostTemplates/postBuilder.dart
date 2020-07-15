import 'package:flutter/material.dart';

class PostBuilder extends StatefulWidget {
  final String postType;
  PostBuilder({Key key, this.postType}) : super(key: key);

  @override
  _PostBuilderState createState() => _PostBuilderState();
}

class _PostBuilderState extends State<PostBuilder> {
  List<String> postType1 = [
    "MicroBlog",
    "MicroBlog<Reshare>",
    "MicroBlog<ReshareWithComment>",
    ""
  ];
  List<String> postType2 = [];
  @override
  Widget build(BuildContext context) {
    if (postType1.contains(widget.postType)) {
      return Text("");
    }
  }
}
