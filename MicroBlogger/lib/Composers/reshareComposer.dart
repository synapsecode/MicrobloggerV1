import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:flutter/material.dart';

class MicroBlogReshareComposer extends StatefulWidget {
  final reshareType;
  const MicroBlogReshareComposer({Key key, this.reshareType}) : super(key: key);

  @override
  _MicroBlogReshareComposerState createState() =>
      _MicroBlogReshareComposerState();
}

class _MicroBlogReshareComposerState extends State<MicroBlogReshareComposer> {
  bool isFact = false;
  String content = "";

  void updateComment(x) {
    setState(() {
      content = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
            child: RaisedButton(
              onPressed: () => setState(() => isFact = !isFact),
              child: (isFact) ? Text("Fact") : Text("Opinion"),
              color: (isFact) ? Colors.green : Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {
                print("TEXT: $content");
                //upload
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(
        contentUpdater: updateComment,
        rt: widget.reshareType,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final rt;
  final contentUpdater;
  const ComposerComponent({this.contentUpdater, this.rt});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black12,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (widget.rt == "MB") HostMicroBlog() else HostMicroBlog(),
          Flexible(
            fit: FlexFit.loose,
            child: Card(
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (x) {
                      widget.contentUpdater("$x");
                    },
                    maxLines: 32,
                    decoration: InputDecoration.collapsed(
                        hintText: "What's happening?"),
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}

class HostMicroBlog extends StatelessWidget {
  const HostMicroBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Redirecting to MicroBlog");
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.black26,
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
                                  "Carryminati",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => print("clicked user"),
                                      child: Text(
                                        "@ajeynagar",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "22h",
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Opinion",
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                    SizedBox(
                                      width: 5,
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
                              border: Border.all(
                                  color: Colors.white10, width: 0.5)),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Hey Guys! How are you all? I have decided to take a short break from Yout How are you all? I have decided to take a short break from Yout How are you all? I have decided to take a short break from Youtube to focus more on my creative development. See you guys soon! Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more on my creative development. See you guys soon! Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more on my creative development. See you guys soon! Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more"),
                              ])),
                      //---------------------------------------CONTENT-------------------------------------------------
                      //---------------------------------------SubFooter-------------------------------------------------

                      //---------------------------------------SubFooter-------------------------------------------------
                    ],
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}
