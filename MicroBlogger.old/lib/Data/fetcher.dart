import 'dart:convert';
import 'datafetcher.dart';
import 'package:http/http.dart' as http;

// final df = DataFetcher();
String serverURL = 'http://localhost:5000';

Object currentUser;

getCurrentUser() {
  return currentUser;
}

setCurrentUser(user) {
  currentUser = user;
}

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

//MICROBLOGS : https://next.json-generator.com/api/json/get/Vki9H0exK

// Future getMicroBlogs() async {

// }

login(username, password) async {
  final response = await http.post(
    '$serverURL/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    if (obj['code'] == 'S1') {
      return obj;
    } else {
      return {'code': 'INCP'};
    }
  } else {
    return {'code': 'ERR'};
  }
}

getFeed(username) async {
  List feed = [
    // ...df.microblogPosts,
    // ...df.blogPosts,
    // ...df.pollPosts,
    // ...df.timelinePosts,
    // ...df.shareablePosts,
    // ...df.resharesWithComment,
    // ...df.simpleReshares
  ];
  print("USERNAME: $username");
  print("fnjfnfjnfjn");
  print("Initiated Feed Fetching routine");
  final response = await http.post(
    '$serverURL/feed',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'username': username}),
  );
  if (response.statusCode == 200) {
    Map obj = json.decode(response.body);
    print((obj).containsKey('user'));
    if (obj['code'] == 'S1') {
      obj['feed'].forEach((e) {
        feed.add(e);
      });
      feed.shuffle();
      print("The Feed has a length of : ${feed.length}");
      return feed;
    } else {
      print("Probably Invalid User Submission or some error has occured");
      return [];
    }
  } else {
    print("Some server side error has occured");
    return [];
  }
}

// getSpecificUser(String username) async {
//   List users = [];
//   String url = 'https://next.json-generator.com/api/json/get/Vki9H0exK';
//   http.Response response = await http.get(url);
//   var x = jsonDecode(response.body);
//   x.forEach((e) {
//     users.add(e['author']);
//   });
//   var user = {};
//   for (var e in users) {
//     if (e['username'] == username) {
//       user = e;
//       break;
//     } else {
//       user = {'username': '0xxFFFFFF'};
//     }
//   }
//   if (user['username'] == '0xxFFFFFF') return user;
//   var finalUser = {
//     'name': '${user["name"]}',
//     'email': '${user["name"]}@gmail.com',
//     'username': '${user["username"]}',
//     'icon': '${user["icon"]}',
//     'background':
//         'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg',
//     'reputation': "15",
//     'followers': "997",
//     'following': "4648",
//     'accountage': 'March 2020',
//     'bio': "Hello! I post my uncensored opinions on Microblog everyday at 7PM!",
//     'likedPosts': [
//       "5f1731df5e46d96525970754",
//       "5f1731dfc8c98d54deb8c1e3",
//       "5f1731df89040b1e33c5bb41",
//       "5f1731df3e75756de5595ee6",
//       "5f1731df2173f6859ad8a2ae",
//       "5f1731dffc3a4b9909afd08d",
//       "5f1731df79f0de509c586158",
//       "5f1731dfb27ddf113ac798ee",
//       "5f1731df5ae3b9f8a1e02336",
//       "5f1731df5608228978476d6a",
//     ],
//     'bookmarkedPosts': [
//       "5f1731dff8f59f583df0fe0d",
//       "5f1731df263ad87d28eb7093",
//       "5f1731df238cb2947d7f921f",
//       "5f1731dfe285e427beb4be01",
//       "5f1731df5608228978476d6a",
//       "5f1731df7c8f17b2a1141031",
//     ],
//     'location': 'The United States of America',
//     'myMicroBlogs': UserData().getMicroBlogPostsByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'myBlogs': UserData().getBlogsByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'myTimelines': UserData().getTimelinesByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'myShareables': UserData().getShareablePostsByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'myReshareWithComments': UserData().getReshareWithCommentPostsByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'mySimpleReshares': UserData().getSimpleResharesByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//     'myPolls': UserData().getPollsByAuthor(
//         "${user['name']}", "${user['username']}", '${user["icon"]}'),
//   };
//   return finalUser;
// }
