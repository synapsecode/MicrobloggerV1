import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

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
              'MicroBlogger',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Made by Manas Hejmadi',
              // style: TextStyle(color: Colors.white30),
            ),
            Text(
              'v0.1.0',
              // style: TextStyle(color: Colors.white30),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
