import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

class PollPost extends StatefulWidget {
  PollPost({Key key}) : super(key: key);

  @override
  _PollPostState createState() => _PollPostState();
}

class _PollPostState extends State<PollPost> {
  bool _liked = false;
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
                        border: Border.all(color: Colors.white10, width: 0.5)),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Who is your favourite Dragon Ball Character?"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Column(
                              children: ["Goku", "Vegeta", "Piccolo", "Roshi"]
                                  .map((x) => Row(children: <Widget>[
                                        Expanded(
                                            child: RaisedButton(
                                          color: Colors.black,
                                          onPressed: () => print(
                                              "Clicked on option ($x) in Poll"),
                                          child: Text(x),
                                        ))
                                      ]))
                                  .toList())
                        ])),
                //---------------------------------------CONTENT-------------------------------------------------
                //---------------------------------------SubFooter-------------------------------------------------

                //---------------------------------------SubFooter-------------------------------------------------
              ],
            ),
          ),
          ActionBar(
            postType: "Poll",
          )
        ],
      ),
    );
  }
}
