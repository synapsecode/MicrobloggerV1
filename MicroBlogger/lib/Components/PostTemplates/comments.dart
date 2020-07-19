import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

class LevelOneComment extends StatefulWidget {
  final commentObject;
  LevelOneComment({Key key, this.commentObject}) : super(key: key);

  @override
  _LevelOneCommentState createState() => _LevelOneCommentState();
}

class _LevelOneCommentState extends State<LevelOneComment> {
  bool _liked = false;
  int likeCounter = 0;

  @override
  void initState() {
    likeCounter = widget.commentObject['likes'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white10,
                border: Border.all(color: Colors.white30, width: 1.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //----------------------------------------HEADER-------------------------------------------------
                TopBar(
                  postObject: widget.commentObject,
                ),
                //----------------------------------------HEADER-------------------------------------------------
                SizedBox(
                  height: 10.0,
                ),
                //----------------------------------------CONTENT-------------------------------------------------
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10, width: 0.5)),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.commentObject['content']}"),
                        ])),
                //---------------------------------------CONTENT-------------------------------------------------
                //---------------------------------------SubFooter-------------------------------------------------

                //---------------------------------------SubFooter-------------------------------------------------
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white10,
                  border: Border(
                      left: BorderSide(width: 1.0, color: Colors.white12),
                      right: BorderSide(width: 1.0, color: Colors.white12),
                      bottom: BorderSide(width: 1.0, color: Colors.white12))),
              height: 35.0,
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.only(bottom: 2.0),
                          icon: Icon((_liked)
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: (_liked) ? Colors.pink : null,
                          onPressed: () {
                            setState(() {
                              _liked = !_liked;
                              likeCounter =
                                  (!_liked) ? --likeCounter : ++likeCounter;
                            });
                          }),

                      Text("$likeCounter"),
                      Text(
                        "   Replying to ",
                        style: TextStyle(color: Colors.white24),
                      ),
                      Text("Parent Post", style: TextStyle(color: Colors.blue))
                      // Text(
                      //   "@synapse.ai",
                      //   style: TextStyle(color: Colors.blue),
                      // ),
                    ],
                  ),
                  //comment
                ],
              )),
        ],
      ),
    );
  }
}
