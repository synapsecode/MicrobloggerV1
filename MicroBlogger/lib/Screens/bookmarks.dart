import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/microblog.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked MicroBlogs"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return new MicroBlogPost();
            },
          )),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
