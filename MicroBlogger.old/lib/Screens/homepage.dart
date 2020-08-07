import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';
import '../Components/PostTemplates/shareable.dart';
import '../Components/PostTemplates/polls.dart';
import '../Components/PostTemplates/reshare.dart';
import '../Components/PostTemplates/blogs.dart';
import '../Components/PostTemplates/timelines.dart';

import '../Components/Others/UIElements.dart';
import '../Data/fetcher.dart';

class HomePage extends StatefulWidget {
  final currentUser;
  HomePage({Key key, this.currentUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Feed"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bubble_chart),
            onPressed: () => print("SecondaryOptions"),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => print("Refresh"),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => Navigator.of(context).pushNamed('/DM'),
          ),
        ],
      ),
      body: Feed(
        currentUser: (widget.currentUser['username']),
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
    print("Current User ${widget.currentUser}");
    feedData = getFeed(widget.currentUser);
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
                      output = BlogPost(postObject: snapshot.data[index]);
                      break;
                    case "shareable":
                      output = Shareable(postObject: snapshot.data[index]);
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
                  // if (snapshot.data[index]['type'] == 'microblog')
                  //   return new MicroBlogPost(postObject: snapshot.data[index]);
                  // else if (snapshot.data[index]['type'] == 'blog')
                  //   return new BlogPost(postObject: snapshot.data[index]);
                  // else
                  //   return SizedBox(
                  //     height: 0.0,
                  //   );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              );
            }
          }),
    ));
  }
}
