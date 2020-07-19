import 'package:MicroBlogger/PostViewers/blogViewer.dart';
import 'package:flutter/material.dart';

class BlogPost extends StatelessWidget {
  final postObject;
  BlogPost({this.postObject});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogViewer(
                      postObject: postObject,
                    ))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                  constraints: new BoxConstraints.expand(
                    height: 250.0,
                  ),
                  padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: NetworkImage("${postObject['background']}"),
                        fit: BoxFit.cover),
                  ),
                  child: new Stack(
                    children: <Widget>[
                      new Positioned(
                          left: 0.0,
                          top: 20.0,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 24.0,
                                backgroundImage: NetworkImage(
                                    "${postObject['author']['icon']}"),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${postObject['author']['name']}",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text("@${postObject['author']['username']}")
                                ],
                              )
                            ],
                          )),
                      new Positioned(
                        left: 0.0,
                        bottom: 20.0,
                        child: Container(
                          width: 300.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Writeup",
                                  style: new TextStyle(
                                    fontSize: 40.0,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("${postObject['blog_name']}",
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
