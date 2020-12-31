import 'dart:ui';

import 'package:MicroBlogger/Backend/datastore.dart';
import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Components/Templates/postTemplates.dart';
import 'package:MicroBlogger/palette.dart';
import 'package:flutter/material.dart';

import '../origin.dart';

class HashtagPostViewer extends StatefulWidget {
  final String hashtag;
  const HashtagPostViewer({this.hashtag});

  @override
  _HashtagPostViewerState createState() => _HashtagPostViewerState();
}

class _HashtagPostViewerState extends State<HashtagPostViewer>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Future postData;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    postData = getHashtagPosts(widget.hashtag);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: postData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GeneralSliverPageView(
              appBarTitle: "#${widget.hashtag}",
              sliverChild: SliverChild(
                hashtag: widget.hashtag,
              ),
              children: [
                Container(
                  // color: CurrentPalette['secondaryBackgroundColor'],
                  child: Column(children: <Widget>[
                    Container(
                      child: PostViewer(
                        controller: _controller,
                        data: snapshot.data,
                      ),
                    ),
                  ]),
                )
              ],
            );
          } else {
            return CirclularLoader();
          }
        },
      ),
    );
  }
}

class SliverChild extends StatelessWidget {
  final String hashtag;
  const SliverChild({this.hashtag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              //image: AssetImage('assets/dhj.png'),
              image: NetworkImage(currentUser['user']['background'] ??
                  "https://www.xda-developers.com/files/2020/04/MIUI-12-Mars-1.jpg"),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Text(
            "Hashtag",
            style: TextStyle(fontSize: 70, color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white),
              color: Colors.black45,
            ),
            child: Text(
              hashtag,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class PostViewer extends StatefulWidget {
  final Map data;
  const PostViewer({
    @required TabController controller,
    this.data,
  }) : _controller = controller;

  final TabController _controller;

  @override
  _PostViewerState createState() => _PostViewerState(_controller);
}

class _PostViewerState extends State<PostViewer> {
  final TabController _controller;
  _PostViewerState(this._controller);

  Widget createTab(List data, Widget X) {
    if (data.length > 0) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: X,
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 150),
          Text(
            "No Posts",
            style: TextStyle(color: CurrentPalette['border']),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List othersFeed = widget.data['pollsandshareables'] ?? [];
    List microblogFeed = widget.data['microblogsandcomments'] ?? [];
    List blogandTimelineFeed = widget.data['blogstimelinesandcarousels'] ?? [];
    List reshareFeed = widget.data['reshared'] ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: new TabBar(
            controller: widget._controller,
            tabs: [
              new Tab(icon: new Icon(Icons.clear_all)),
              new Tab(icon: new Icon(Icons.repeat)),
              new Tab(icon: new Icon(Icons.content_copy)),
              new Tab(icon: new Icon(Icons.poll)),
            ],
          ),
        ),
        SizedBox(
          height: 590.0,
          child: Container(
            // color: CurrentPalette['secondaryBackgroundColor'],
            // transform: Matrix4.translationValues(
            //           0, -20, 0),
            child: TabBarView(
              controller: widget._controller,
              children: <Widget>[
                createTab(
                  microblogFeed,
                  ListView.builder(
                    itemCount: microblogFeed.length,
                    itemBuilder: (context, index) {
                      return new MicroBlogPost(
                        postObject: microblogFeed[index],
                      );
                    },
                  ),
                ),
                createTab(
                  reshareFeed,
                  ListView.builder(
                    itemCount: reshareFeed.length,
                    itemBuilder: (context, index) {
                      return new ReshareWithComment(
                        postObject: reshareFeed[index],
                      );
                    },
                  ),
                ),
                createTab(
                  blogandTimelineFeed,
                  ListView.builder(
                    itemCount: blogandTimelineFeed.length,
                    itemBuilder: (context, index) {
                      if (blogandTimelineFeed[index]['type'] == 'blog')
                        return BlogPost(blogandTimelineFeed[index]);
                      else if (blogandTimelineFeed[index]['type'] == 'timeline')
                        return Timeline(blogandTimelineFeed[index]);
                      else if (blogandTimelineFeed[index]['type'] == 'carousel')
                        return CarouselPost(
                            postObject: blogandTimelineFeed[index]);
                    },
                  ),
                ),
                createTab(
                  othersFeed,
                  ListView.builder(
                    itemCount: othersFeed.length,
                    itemBuilder: (context, index) {
                      if (othersFeed[index]['type'] == 'shareable')
                        return new ShareablePost(
                          postObject: othersFeed[index],
                        );
                      else
                        return new PollPost(
                          postObject: othersFeed[index],
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
