import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

class Shareable extends StatefulWidget {
  Shareable({Key key}) : super(key: key);

  @override
  _ShareableState createState() => _ShareableState();
}

class _ShareableState extends State<Shareable> {
  bool _liked = false;
  bool _bookmarked = false;
  bool _reshared = false;
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(
                            'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Manas Hejmadi",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => print("clicked user"),
                                  child: Text(
                                    "@synapse.ai",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "12h",
                                  style: TextStyle(color: Colors.white30),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () => print("More clicked"),
                                  child: Icon(Icons.arrow_drop_down),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                            Text(
                                "Hey Guys! Check out my new application called Krustel Classroom! Its releasing exclusively on Android. Check it out using the link provided below!"),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton.icon(
                                    color: Colors.black,
                                    onPressed: () {},
                                    icon: Icon(Icons.link),
                                    label: Text("Visit Krustel Classroom"))
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
              postType: "Shareable",
            )
          ],
        ));
  }
}
