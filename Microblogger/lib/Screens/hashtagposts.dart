import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Components/Templates/postTemplates.dart';
import 'package:flutter/material.dart';

class SpecificHashtaggedPosts extends StatelessWidget {
  final String hashtag;
  const SpecificHashtaggedPosts({Key key, this.hashtag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future bookmarkData = getBookmarks();
    return Scaffold(
        appBar: AppBar(
          title: Text("#$hashtag"),
          backgroundColor: Colors.black87,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                FutureBuilder(
                    future: bookmarkData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Widget output;
                            switch (snapshot.data[index]['type']) {
                              case "microblog":
                                output = MicroBlogPost(
                                    postObject: snapshot.data[index]);
                                break;
                              case "blog":
                                output = BlogPost(snapshot.data[index]);
                                break;
                              case "shareable":
                                output = ShareablePost(
                                    postObject: snapshot.data[index]);
                                break;
                              case "timeline":
                                output = Timeline(snapshot.data[index]);
                                break;
                              case "poll":
                                output =
                                    PollPost(postObject: snapshot.data[index]);
                                break;
                              case "carousel":
                                output = CarouselPost(
                                  postObject: snapshot.data[index],
                                );
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
                                output = Container(
                                  color: Colors.red,
                                );
                                break;
                            }
                            return output;
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CirclularLoader()],
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }
}
