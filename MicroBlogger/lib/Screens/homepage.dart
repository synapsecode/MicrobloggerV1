import 'dart:async';
import 'package:MicroBlogger/Backend/server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/datastore.dart';
import '../Components/Global/globalcomponents.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../Components/Templates/postTemplates.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Feed"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Logging Out",
                backgroundColor: Color.fromARGB(200, 220, 20, 60),
              );
              logoutSavedUser();
              Navigator.of(context).pushReplacementNamed('/Login');
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => print("Refresh"),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => Fluttertoast.showToast(
              msg: "Feature Coming Soon!",
              backgroundColor: Color.fromARGB(200, 220, 20, 60),
            ),
          ),
        ],
      ),
      body: Feed(
        currentUser: (currentUser['username']),
      ),
      drawer: MainAppDrawer(),
      floatingActionButton: FloatingCircleButton(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class Feed extends StatefulWidget {
  final currentUser;
  Feed({Key key, this.currentUser}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future feedData;
  @override
  void initState() {
    super.initState();
    feedData = getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder(
          future: feedData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Widget output;
                  switch (snapshot.data[index]['type']) {
                    case "microblog":
                      output = MicroBlogPost(postObject: snapshot.data[index]);
                      break;
                    case "blog":
                      output = BlogPost(snapshot.data[index]);
                      break;
                    case "shareable":
                      output = ShareablePost(postObject: snapshot.data[index]);
                      break;
                    case "timeline":
                      output = Timeline(snapshot.data[index]);
                      break;
                    case "poll":
                      output = PollPost(postObject: snapshot.data[index]);
                      break;
                    case "ResharedWithComment":
                      output = ReshareWithComment(
                        postObject: snapshot.data[index],
                      );
                      break;
                    case "SimpleReshare":
                      output = SimpleReshare(
                        postObject: snapshot.data[index],
                      );
                      break;
                    default:
                      break;
                  }
                  return output;
                },
              );
            } else {
              return CirclularLoader();
            }
          }),
    ));
  }
}
