import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';
import '../Components/PostTemplates/shareable.dart';
import '../Components/PostTemplates/polls.dart';
import '../Components/PostTemplates/reshare.dart';
import '../Components/PostTemplates/blogs.dart';
import '../Components/PostTemplates/timelines.dart';

import '../Components/Others/UIElements.dart';

import '../Data/datafetcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final data = DataFetcher();
  final currentUser = getCurrentUser();
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
      body: Feed(data: data),
      drawer: MainAppDrawer(
        author: currentUser,
      ),
      floatingActionButton: FloatingCircleButton(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class Feed extends StatelessWidget {
  final data;
  Feed({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List feed = [
      ...data.microblogPosts,
      ...data.blogPosts,
      ...data.pollPosts,
      ...data.shareablePosts,
      ...data.timelinePosts,
      ...data.resharesWithComment,
      ...data.simpleReshares
    ];
    feed.shuffle();
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
                itemCount: feed.length,
                itemBuilder: (context, index) {
                  var post = feed[index];
                  var output;
                  switch (post['type']) {
                    case "microblog":
                      output = MicroBlogPost(postObject: post);
                      break;
                    case "blog":
                      output = BlogPost(postObject: post);
                      break;
                    case "shareable":
                      output = Shareable(postObject: post);
                      break;
                    case "timeline":
                      output = Timeline(post);
                      break;
                    case "poll":
                      output = PollPost(postObject: post);
                      break;
                    case "ResharedWithComment":
                      output = ReshareWithComment(
                        postObject: post,
                      );
                      break;
                    case "SimpleReshare":
                      output = SimpleReshare(
                        postObject: post,
                      );
                      break;
                    default:
                      break;
                  }
                  return output;
                })));
  }
}
