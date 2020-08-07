import 'package:MicroBlogger/Views/news_viewer.dart';
import 'package:flutter/material.dart';

class NewsItem extends StatelessWidget {
  final newsObject;
  const NewsItem({Key key, this.newsObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsViewer(link: newsObject['link'])));
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            constraints: new BoxConstraints.expand(
              height: 250.0,
            ),
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: NetworkImage("${newsObject['background']}"),
                  fit: BoxFit.cover),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  left: 0.0,
                  bottom: 20.0,
                  child: Container(
                    width: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("News Article",
                            style: new TextStyle(
                              fontSize: 40.0,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("${newsObject['headline']}",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
