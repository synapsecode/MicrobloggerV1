import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/reshare.dart';
import 'package:MicroBlogger/Components/PostTemplates/shareable.dart';
import 'package:MicroBlogger/Data/datafetcher.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = DataFetcher();
    List bookmarked = [
      ...data.microblogPosts,
      ...data.resharesWithComment,
      ...data.shareablePosts
    ];
    bookmarked.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked MicroBlogs"),
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
            if (bookmarked[index]['type'] == "microblog")
              return MicroBlogPost(
                postObject: bookmarked[index],
              );
            else if (bookmarked[index]['type'] == "shareable")
              return Shareable(
                postObject: bookmarked[index],
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
