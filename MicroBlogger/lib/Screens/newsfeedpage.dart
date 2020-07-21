import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Data/datafetcher.dart';
import 'package:flutter/material.dart';
import '../Components/PostTemplates/news.dart';

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List newsFeed = DataFetcher().newsArticles;
    newsFeed.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: Text("News Feed"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: newsFeed.length,
            itemBuilder: (context, index) {
              return new NewsItem(
                newsObject: newsFeed[index],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
