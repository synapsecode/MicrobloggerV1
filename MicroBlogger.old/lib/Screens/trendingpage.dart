import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Trending"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
          // onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => HomePage()),
          //     ModalRoute.withName('/'))),
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/env.png')),
          Center(
            child: Text(
              "Feature Coming soon!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
