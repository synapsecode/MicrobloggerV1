import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/polls.dart';
import 'package:MicroBlogger/Components/PostTemplates/reshare.dart';
import 'package:MicroBlogger/Components/PostTemplates/shareable.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:MicroBlogger/Data/datafetcher.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = getCurrentUser();
    final data = DataFetcher();
    List feed = [
      ...data.microblogPosts,
      ...data.blogPosts,
      ...data.pollPosts,
      ...data.shareablePosts,
      ...data.timelinePosts,
      ...data.resharesWithComment,
      ...data.simpleReshares
    ];
    List bookmarked = [];
    for (var f in feed) {
      if (f.containsKey('id')) {
        if (currentUser['bookmarkedPosts'].contains(f['id'])) {
          bookmarked.add(f);
        }
      }
    }
    bookmarked.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Posts"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.black,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bookmarked.length,
          itemBuilder: (context, index) {
            print("${bookmarked[index]['id']}\n\n");
            if (bookmarked[index]['type'] == "microblog")
              return MicroBlogPost(
                postObject: bookmarked[index],
              );
            else if (bookmarked[index]['type'] == "shareable")
              return Shareable(
                postObject: bookmarked[index],
              );
            else if (bookmarked[index]['type'] == "blog")
              return BlogPost(
                postObject: bookmarked[index],
              );
            else if (bookmarked[index]['type'] == "poll")
              return PollPost(
                postObject: bookmarked[index],
              );
            else if (bookmarked[index]['type'] == "timeline")
              return Timeline(
                bookmarked[index],
              );
            else
              return ReshareWithComment(
                postObject: bookmarked[index],
              );
          },
        ),
      )),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
