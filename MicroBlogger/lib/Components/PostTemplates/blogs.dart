import 'package:flutter/material.dart';

class BlogPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => print("Clicked on Blog Post"),
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
                        image: NetworkImage(
                            'https://9to5mac.com/wp-content/uploads/sites/6/2018/06/mojave-night.jpg?quality=82&strip=all'),
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
                                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Manas Hejmadi",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text("@synapse.ai")
                                ],
                              )
                            ],
                          )),
                      new Positioned(
                        left: 0.0,
                        bottom: 60.0,
                        child: new Text("Writeup",
                            style: new TextStyle(
                              fontSize: 40.0,
                            )),
                      ),
                      new Positioned(
                        left: 0.0,
                        bottom: 30.0,
                        child: new Text("Biggest Changes in MacOS",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                      ),
                    ],
                  ))),
        ));
  }
}

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.favorite, color: Colors.white70),
                onPressed: null),
            Text("50")
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.mode_comment, color: Colors.white70),
                onPressed: null),
            Text("7")
          ],
        ),
      ],
    );
  }
}

class ResharedBlog extends StatelessWidget {
  const ResharedBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Reshared by ",
              style: TextStyle(color: Colors.white30),
            ),
            InkWell(
              onTap: () => print("RESEND"),
              child: Text(
                "@synapse.ai",
                style: TextStyle(color: Colors.pink),
              ),
            )
          ],
        ),
        BlogPost()
      ],
    );
  }
}

class SponsoredBlog extends StatelessWidget {
  const SponsoredBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "This is a Sponsored Blog",
              style: TextStyle(color: Colors.white30),
            ),
          ],
        ),
        BlogPost()
      ],
    );
  }
}
