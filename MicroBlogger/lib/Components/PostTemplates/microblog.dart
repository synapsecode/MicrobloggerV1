import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/PostViewers/MicroBlogViewer.dart';
import 'package:flutter/material.dart';

class MicroBlogPost extends StatefulWidget {
  final postObject;
  final isInViewMode;
  MicroBlogPost({Key key, this.postObject, this.isInViewMode = false})
      : super(key: key);

  @override
  _MicroBlogPostState createState() => _MicroBlogPostState();
}

class _MicroBlogPostState extends State<MicroBlogPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: InkWell(
          onTap: () => (widget.isInViewMode == false)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MicroBlogViewer(
                            postObject: widget.postObject,
                          )))
              : () {},
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
                              "${widget.postObject['author']['icon']}"),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.postObject['author']['name']}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => print("clicked user"),
                                    child: Text(
                                      "@${widget.postObject['author']['username']}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.postObject['age']}",
                                    style: TextStyle(color: Colors.white30),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.postObject['category']}",
                                    style: TextStyle(color: Colors.green),
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
                              Text("${widget.postObject['content']}"),
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
        ));
  }
}
