import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';

class LinkerButton extends StatelessWidget {
  final icon;
  final t;
  final Function event;

  //Constructor
  LinkerButton(this.icon, this.t, this.event);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: FloatingActionButton(
        backgroundColor: Color.fromARGB(200, 220, 20, 60),
        foregroundColor: Colors.white,
        child: icon,
        onPressed: event,
        heroTag: t,
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About MicroBlog"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/env.png')),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'microblogger',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Made by Manas Hejmadi (Krustel)',
              // style: TextStyle(color: Colors.white30),
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              'v0.0.10+1 Alpha',
              // style: TextStyle(color: Colors.white30),
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              width: 270.0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  color: Color.fromARGB(200, 220, 20, 60),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "microblogger is a Completely Indian Initiative to create a microblogging platform that incorporates elements from various different social media platforms. It is created by Manas Hejmadi, a solo developer from Bengaluru, Karnataka (India).",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text('Contact the Developer',
                style: TextStyle(color: Colors.white30)
                // style: TextStyle(color: Colors.white30),
                ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 240.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LinkerButton(
                      FaIcon(
                        FontAwesomeIcons.instagram,
                        size: 20.0,
                      ),
                      "1", () {
                    print("Instagram");
                  }),
                  LinkerButton(
                      FaIcon(
                        FontAwesomeIcons.mailBulk,
                        size: 20.0,
                      ),
                      "2", () {
                    print("Facebook");
                  }),
                  LinkerButton(
                      FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 20.0,
                      ),
                      "3", () {
                    print("linkedin");
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
