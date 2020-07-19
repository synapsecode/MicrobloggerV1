import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

class PollPost extends StatefulWidget {
  final postObject;
  PollPost({Key key, this.postObject}) : super(key: key);

  @override
  _PollPostState createState() => _PollPostState();
}

class _PollPostState extends State<PollPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
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
                  postObject: widget.postObject,
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
                          Text("${widget.postObject['content']}"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Column(
                            children: [...widget.postObject['options']]
                                .map((x) => Row(children: <Widget>[
                                      Expanded(
                                          child: RaisedButton(
                                        color: Colors.black,
                                        onPressed: () => print(
                                            "Clicked on option (${x['name']}) in Poll"),
                                        child: Text(x['name']),
                                      ))
                                    ]))
                                .toList(),
                          ),
                        ])),
                //---------------------------------------CONTENT-------------------------------------------------
                //---------------------------------------SubFooter-------------------------------------------------

                //---------------------------------------SubFooter-------------------------------------------------
              ],
            ),
          ),
          ActionBar(
            post: widget.postObject,
          )
        ],
      ),
    );
  }
}
