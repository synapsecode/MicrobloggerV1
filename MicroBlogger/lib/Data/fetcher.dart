import 'dart:convert';
import 'datafetcher.dart';
import 'package:http/http.dart' as http;

final df = DataFetcher();

Future getNewsArticles() async {
  List articles = [];
  print("Initiated News Fetching routine");
  String url =
      'https://newsapi.org/v2/top-headlines?country=in&apiKey=590b8ff1c78d4c0e8088535f3cf54122';
  http.Response response = await http.get(url);
  var x = jsonDecode(response.body);
  print(x['totalResults']);
  if (x['status'] == 'ok') {
    x['articles'].forEach((e) {
      articles.add({
        'source': e['source']['name'],
        'headline': e['title'],
        'link': e['url'],
        'background': e['urlToImage']
      });
    });
  }
  print(articles.length);
  return articles;
}

//MICROBLOGS : https://next.json-generator.com/api/json/get/NyyIqq1lF

// Future getMicroBlogs() async {

// }

getFeed() async {
  List feed = [
    ...df.microblogPosts,
    ...df.blogPosts,
    ...df.pollPosts,
    ...df.timelinePosts,
    ...df.shareablePosts,
    ...df.resharesWithComment,
    ...df.simpleReshares
  ];
  print("Initiated MicroBlog Fetching routine");
  String url = 'https://next.json-generator.com/api/json/get/NyyIqq1lF';
  http.Response response = await http.get(url);
  var x = jsonDecode(response.body);
  x.forEach((e) {
    feed.add(e);
  });
  feed.shuffle();
  print("The Feed has a length of : ${feed.length}");
  return feed;
}
