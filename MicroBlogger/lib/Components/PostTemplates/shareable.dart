import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

class Shareable extends StatefulWidget {
  final postObject;
  Shareable({Key key, this.postObject}) : super(key: key);

  @override
  _ShareableState createState() => _ShareableState();
}

class _ShareableState extends State<Shareable> {
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
                          border:
                              Border.all(color: Colors.white10, width: 0.5)),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.postObject['content']}"),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton.icon(
                                    color: Colors.black,
                                    onPressed: () {
                                      print(
                                          "Visiting ${widget.postObject['link']}");
                                    },
                                    icon: Icon(Icons.link),
                                    label: Text(
                                        "Visit ${widget.postObject['name']}"))
                              ],
                            )
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
        ));
  }
}
