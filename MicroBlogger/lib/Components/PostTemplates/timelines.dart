import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
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
                            'https://i1.wp.com/regionweek.com/wp-content/uploads/2020/03/World-Map-2.jpg?fit=1920%2C1200&ssl=1'),
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
                                    "WION News",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text("@wionews")
                                ],
                              )
                            ],
                          )),
                      new Positioned(
                        left: 0.0,
                        bottom: 60.0,
                        child: new Text("Timeline",
                            style: new TextStyle(
                              fontSize: 40.0,
                            )),
                      ),
                      new Positioned(
                        left: 0.0,
                        bottom: 30.0,
                        child: Container(
                          child: new Text("The Covid-19 Pandemic in India",
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}

class ResharedTimeline extends StatelessWidget {
  const ResharedTimeline({Key key}) : super(key: key);

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
        Timeline()
      ],
    );
  }
}

class SponsoredTimeline extends StatelessWidget {
  const SponsoredTimeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "This is a Sponsored Timeline",
              style: TextStyle(color: Colors.white30),
            ),
          ],
        ),
        Timeline()
      ],
    );
  }
}
